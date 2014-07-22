as yet unclassified
calculateEventRates: events
	|rates|
	rates := Dictionary new.
	model PIDList do: [ :pid| rates at: pid put: (OrderedCollection new) ].
	model PIDList do: [ :pid|
		model setPID: pid.
		pid isArray ifTrue: [ model setIndex: (pid last) ].
		events do: [ :each|
			|r|
			r := (each evaluateWithModel: model).
			each fromStatus ~= #empty ifTrue: [ 
				r := r * (((model population at: pid) at: (each fromStatus asSymbol)) currentNbIndividuals)
				 ].
			(rates at: pid) add: r 
			 ]
		 ].
	^ rates