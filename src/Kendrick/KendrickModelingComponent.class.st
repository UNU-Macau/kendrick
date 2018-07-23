Class {
	#name : #KendrickModelingComponent,
	#superclass : #KendrickInternalDSLEntities,
	#instVars : [
		'attributes',
		'parameters',
		'equations',
		'transitions',
		'explicitelySetCompartments',
		'otherCompartmentValue',
		'emptyRate',
		'backEndEntity'
	],
	#category : 'Kendrick-InternalDSL'
}

{ #category : #'public-api' }
KendrickModelingComponent >> allLiteralTransitionRefsForAttribute: attribute [
	
	^ [(attributes at: attribute) collect: [:comp |  attribute  -> comp ]] on: KeyNotFound do: [ self literalTransitionRefFor: attribute ]
]

{ #category : #'public-api' }
KendrickModelingComponent >> allTransitionRefsForAttribute: attribute [
	
	^ (attributes at: attribute) collect: [:comp | '{#' , attribute asString , ': #' , comp , '}']
]

{ #category : #'public-api' }
KendrickModelingComponent >> allTransitionsFor: aFromToList [

		|from to propability|

		from := aFromToList first.
		propability := aFromToList second.
		to := aFromToList last.
		({ from . to } includes: #Empty) ifTrue: [ emptyRate := propability ].
		(self isAttribute: from)
			ifTrue: [ 
				(self allTransitionRefsForAttribute: from) do: [:fromRef |  
					backEndEntity
   						addTransitionFrom: fromRef
   						to: (self transitionRefFor: to)
   						probability: [ :m | m atParameter: propability ].			
				]
			]
			ifFalse: [ "to = all"
				(self isAttribute: to)
					ifTrue: [  
						(self allTransitionRefsForAttribute: from) do: [:toRef |  
							backEndEntity
   								addTransitionFrom: (self transitionRefFor: from)
   								to: toRef
   								probability: [ :m | m atParameter: propability ].			
						]
					] ifFalse: [ "no attributes"  
						backEndEntity
   								addTransitionFrom: (self transitionRefFor: from)
   								to: (self transitionRefFor: to)
   								probability: [ :m | m atParameter: propability ].
					]		
			 ] 
			
	
]

{ #category : #'public-api' }
KendrickModelingComponent >> attribute: anArray [

	attributes 
		at: anArray first 
		put: ((anArray allButFirst select: [:var | var ~= #->]) collect: [ :var | var asString asSymbol]) asOrderedCollection.
	backEndEntity 
		addAttribute: anArray first 
		value: ((anArray allButFirst select: [:var | var ~= #->]) collect: [ :var | var asString asSymbol]). 
	
]

{ #category : #protected }
KendrickModelingComponent >> attributeValuesIncludes: variable [

	^ (attributes values select: [ :values | values includes: variable ]) isEmpty not
]

{ #category : #protected }
KendrickModelingComponent >> attributes [

	^ attributes
]

{ #category : #'public-api' }
KendrickModelingComponent >> equations: anArrayOfSymExpressions [

	equations :=
		KendrickEquations new with: anArrayOfSymExpressions.
	backEndEntity addEquations: equations convertToCompatibleBackendRepresentation.
	
]

{ #category : #'public-api' }
KendrickModelingComponent >> imports: aMatrix using: transition [

|att dom|
att := self attributes associations first key.
dom := self attributes associations first value.
dom size ~= aMatrix size ifTrue: [ ^ self error: 'Size of input is not compatible' ].
1 to: aMatrix size do: [ :row| 
	1 to: (aMatrix at: row) size do: [ :col|
		(((aMatrix at: row) at: col) ~= 0) ifTrue: [ 
			|probability|
			
			probability :=
				((aMatrix at: row) at: col) = 0 
					ifFalse: [ probability := transition asString ]
					ifTrue: [ 0 asString ].
			
			backEndEntity 
				addTransitionFrom: { att->(dom at: row) } to: { att->(dom at: col) } 
				probability:  probability asString].
	]
]
	
	
]

{ #category : #'public-api' }
KendrickModelingComponent >> initialize [
	super initialize.
	attributes := Dictionary new.
	parameters := Dictionary new.
	explicitelySetCompartments := OrderedCollection new.
		
]

{ #category : #protected }
KendrickModelingComponent >> isAttribute: attribute [
	
	^ (attributes keys includes: attribute) 
]

{ #category : #protected }
KendrickModelingComponent >> literalTransitionRefFor: aCompartment [
	
	|assoc|

	
	aCompartment = 'Empty'
		ifTrue: [ ^ #empty ].
	assoc := (attributes associations select: [ :pair | pair value includes: aCompartment ]) first.
	^ {   assoc key -> aCompartment }.
	
]

{ #category : #'public-api' }
KendrickModelingComponent >> others: anInteger [

	otherCompartmentValue := anInteger.
		
]

{ #category : #protected }
KendrickModelingComponent >> parameters [

	^ parameters 
]

{ #category : #'public-api' }
KendrickModelingComponent >> parameters: anArray [

	anArray do: [ :var | parameters at: var put: 0 ]
]

{ #category : #'public-api' }
KendrickModelingComponent >> transitionRates: anExpressionOrBlock [
	"setting same rate for all transitions"
	backEndEntity transitions do: [ :tr| 
		tr probability: anExpressionOrBlock	
	]
]

{ #category : #protected }
KendrickModelingComponent >> transitionRefFor: aCompartment [
	
	|assoc|

	
	aCompartment = 'Empty'
		ifTrue: [ ^ #empty ].
	assoc := (attributes associations select: [ :pair | pair value includes: aCompartment ]) first.
	^ '{#' , assoc key asString , ': #' , aCompartment , '}'.
]

{ #category : #'public-api' }
KendrickModelingComponent >> transitions [

	^ transitions 
		ifNotNil: [ transitions convertToCompatibleBackendRepresentation]
		ifNil: [ 
			transitions := 
				backEndEntity transitions
					collect: [ :t | (t from associations first value -> nil -> t to associations first value) ] 
		]
		
]

{ #category : #'public-api' }
KendrickModelingComponent >> transitions: aSymExpression [
	transitions :=
		KendrickTransitions new with: aSymExpression.
	transitions convertToCompatibleBackendRepresentation do: [:assoc |
		|from to propability|
		from := assoc key key asString asSymbol.
		propability := assoc key value.
		to := assoc value asString asSymbol.
		self allTransitionsFor: { from . propability . to } ].
		
]