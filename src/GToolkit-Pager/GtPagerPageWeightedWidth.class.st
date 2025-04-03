Class {
	#name : #GtPagerPageWeightedWidth,
	#superclass : #GtPagerPageWidth,
	#instVars : [
		'weight'
	],
	#classVars : [
		'GtPagerPageDefaultWeight'
	],
	#category : #'GToolkit-Pager-Strategies'
}

{ #category : #defaults }
GtPagerPageWeightedWidth class >> defaultWeight [
	^ GtPagerPageDefaultWeight ifNil: [ GtPagerPageDefaultWeight := 0.5 ]
]

{ #category : #defaults }
GtPagerPageWeightedWidth class >> defaultWeight: aNumberBetween0And0dot5 [
	self
		assert: (aNumberBetween0And0dot5 > 0 and: [ aNumberBetween0And0dot5 <= 0.5 ])
		description: 'The weight must be higher than 0 and less or equal to 0.5'.
	GtPagerPageDefaultWeight := aNumberBetween0And0dot5
]

{ #category : #'as yet unclassified' }
GtPagerPageWeightedWidth >> defaultWeight [
	^ self class defaultWeight
]

{ #category : #initialization }
GtPagerPageWeightedWidth >> initialize [
	super initialize.
	weight := self defaultWeight.
]

{ #category : #'api - size' }
GtPagerPageWeightedWidth >> onElement: aPageElement [
	"Configure the page element"
	aPageElement
		weight: self weight;
		constraintsDo: [ :c | c horizontal matchParent ].
]

{ #category : #printing }
GtPagerPageWeightedWidth >> printOn: aStream [ 
	aStream nextPutAll: 'Weighted width: '; print: self weight
]

{ #category : #accessing }
GtPagerPageWeightedWidth >> weight [
	^ weight
]

{ #category : #accessing }
GtPagerPageWeightedWidth >> weight: anObject [
	weight := anObject
]
