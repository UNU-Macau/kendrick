initialization
initializeStatus
	| initialInfectedNode |
	network nodes do: [ :each | each currentStatus: #S ].
	"Start the infection at the center of the network"
	initialInfectedNode := network nodes at: (network n )* (network n // 2) + (network n // 2) +1.
	initialInfectedNode
		currentStatus: #I;
		genInfected: 1