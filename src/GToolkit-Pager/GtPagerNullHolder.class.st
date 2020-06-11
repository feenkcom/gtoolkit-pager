Class {
	#name : #GtPagerNullHolder,
	#superclass : #GtPagerAbstractHolder,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#category : #'GToolkit-Pager-Strategies'
}

{ #category : #'announcer - subscription' }
GtPagerNullHolder >> addEventHandler: anEventHandler [
	"Do nothing"
]

{ #category : #'api - actions' }
GtPagerNullHolder >> close: aPageElement [
	"do nothing"
]

{ #category : #testing }
GtPagerNullHolder >> isFirstPageEqualTo: aPageElement [
	^ false
]

{ #category : #testing }
GtPagerNullHolder >> isLastPageEqualTo: aPageElement [
	^ false
]

{ #category : #'api - actions' }
GtPagerNullHolder >> maximizeIn: aCreationContext [
	"do nothing"
]

{ #category : #'announcer - subscription' }
GtPagerNullHolder >> removeEventHandler: anEventHandler [
	"Do nothing"
]

{ #category : #'api - actions' }
GtPagerNullHolder >> select: aGtPagerPageSelectionContext [
	"do nothing"
]

{ #category : #'api - actions' }
GtPagerNullHolder >> smoothScrollToLast [
	"do nothing"
]

{ #category : #'api - actions' }
GtPagerNullHolder >> spawn: aGtPagerPageSelectionContext [
	"do nothing"
]
