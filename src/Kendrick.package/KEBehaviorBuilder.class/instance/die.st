behavior
die
	|ind model pop|
	ind := self arguments at: #ind.
	model := self arguments at: #model.
	pop := model population at: (model getPID).
	pop removeIndividual: ind.
	(pop at: ind currentStatus) removeIndividual: 1.
	pop hasGraph ifTrue: [ pop graph releaseRoom: (ind) ].
	^ true