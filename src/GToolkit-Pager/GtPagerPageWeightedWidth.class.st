Class {
	#name : #GtPagerPageWeightedWidth,
	#superclass : #GtPagerPageWidth,
	#instVars : [
		'weight'
	],
	#category : #'GToolkit-Pager-Strategies'
}

{ #category : #defaults }
GtPagerPageWeightedWidth >> defaultWeight [
	^ 0.5
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
