metrics
r0
	| nodesGen2 nodesGen3 |
	nodesGen2 := nodes select: [ :each | each genInfected == 2 ].
	nodesGen3 := nodes select: [ :each | each genInfected == 3 ].
	^ (nodesGen3 size / nodesGen2 size) asFloat