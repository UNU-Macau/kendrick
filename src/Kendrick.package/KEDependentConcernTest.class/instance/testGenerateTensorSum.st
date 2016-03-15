tests-as yet unclassified
testGenerateTensorSum
	|model concern|
	model := KEModel new.
	model integrate: self sirConcern.
	model integrate: self spatialConcern.
	concern := KEConcern dependOn: (self sirConcern).
	concern atAttribute: #status add: #E.
	concern removeTransitionFrom: { #status->#S } to: { #status->#I }.
	concern addTransitionFrom: { #status->#S } to: { #status->#E } probability: [ :aModel| aModel atParameter: #lambda ].
	concern addTransitionFrom: { #status->#E } to: { #status->#I } probability: [ :aModel| aModel atParameter: #epsilon ].
	concern addTransitionFrom: { #status->#E } to: #empty probability: [ :aModel| aModel atParameter: #mu ].
	concern addParameter: #epsilon.
	self assert: (concern generateTensorSum: model transitions) size equals: 60.