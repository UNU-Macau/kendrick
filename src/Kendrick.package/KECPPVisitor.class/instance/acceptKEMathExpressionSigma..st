as yet unclassified
acceptKEMathExpressionSigma: aNode
	|aStream|
	aStream := WriteStream on: (String new: 60).
	aStream nextPutAll: 'tmp'.
	bStream nextPutAll: 'double tmp = 0;';cr.
	bStream nextPutAll: 'for (int ', (aNode idVariable) asString, '=', 'KEmin_', (aNode idVariable) asString,'-1',';', (aNode idVariable) asString, '<', 'KEmax_', (aNode idVariable) asString,';', (aNode idVariable) asString, '+=','KEstep_',(aNode idVariable) asString,')';cr.
	bStream nextPutAll: '{';cr.
			bStream nextPutAll: 'tmp += '.
			(aNode exprInFunction class == KEVariable) | (aNode exprInFunction class == KENumerical) 
			ifTrue: [ bStream  nextPutAll: '(' ].
			bStream  nextPutAll: (self visitNode: aNode exprInFunction).
			(aNode exprInFunction class == KEVariable) | (aNode exprInFunction class == KENumerical) 
			ifTrue: [ bStream  nextPutAll: ')';cr. ].
			bStream nextPutAll: ';';cr.
	bStream nextPutAll: '}';cr.
	"
	aStream nextPutAll: (aNode function asString).
	(aNode exprInFunction class == KEVariable) | (aNode exprInFunction class == KENumerical) 
		ifTrue: [ aStream nextPutAll: '(' ].
	aStream nextPutAll: (self visitNode: aNode exprInFunction).
	(aNode exprInFunction class == KEVariable) | (aNode exprInFunction class == KENumerical) 
		ifTrue: [ aStream nextPutAll: ')' ]."
	^ aStream contents
	