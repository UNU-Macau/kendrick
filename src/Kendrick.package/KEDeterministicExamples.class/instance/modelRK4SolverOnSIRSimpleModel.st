examples
modelRK4SolverOnSIRSimpleModel
	"self new exampleRK4SolverOnSIRSimpleModel"

	| model |
	model := KEModel new.
	model
		buildFromCompartments:
			'{
		{ #status: #S }: 99999,
		{ #status: #I }: 1,
		{ #status: #R }: 0
	}'.
	model addParameters: '{#beta: 0.0052, #gamma: 52}'.
	model
		addTransitionFrom: '{#status: #S}'
		to: '{#status: #I}'
		probability: [ :m | (m atParameter: #beta) * (m atCompartment: '{#status: #I}') ].
	model addTransitionFrom: '{#status: #I}' to: '{#status: #R}' probability: [ :m | m atParameter: #gamma ].
	^ model