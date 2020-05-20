Class {
	#name : #GtPagerPageExactWidth,
	#superclass : #GtPagerPageWidth,
	#instVars : [
		'width'
	],
	#category : #'GToolkit-Pager-Strategies'
}

{ #category : #defaults }
GtPagerPageExactWidth >> defaultWidth [
	^ GtPager defaultExtent x // 2
]

{ #category : #initialization }
GtPagerPageExactWidth >> initialize [
	super initialize.
	width := self defaultWidth.
]

{ #category : #'api - size' }
GtPagerPageExactWidth >> onElement: aPageElement [
	"Configure the page element"
	aPageElement width: self width
]

{ #category : #printing }
GtPagerPageExactWidth >> printOn: aStream [ 
	aStream nextPutAll: 'Exact width: '; print: self width
]

{ #category : #accessing }
GtPagerPageExactWidth >> width [
	^ width
]

{ #category : #accessing }
GtPagerPageExactWidth >> width: anObject [
	width := anObject
]
