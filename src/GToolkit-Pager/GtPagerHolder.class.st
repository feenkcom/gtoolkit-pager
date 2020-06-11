Class {
	#name : #GtPagerHolder,
	#superclass : #GtPagerAbstractHolder,
	#traits : 'TGtPagerAccessors',
	#classTraits : 'TGtPagerAccessors classTrait',
	#category : #'GToolkit-Pager-Strategies'
}

{ #category : #factory }
GtPagerHolder class >> null [
	^ GtPagerNullHolder default
]

{ #category : #'announcer - subscription' }
GtPagerHolder >> addEventHandler: anEventHandler [
	self pager addEventHandler: anEventHandler
]

{ #category : #'api - actions' }
GtPagerHolder >> close: aPageElement [
	"Close/remove a page from a pager"
	self pager removePage: aPageElement.
]

{ #category : #'api - actions' }
GtPagerHolder >> isFirstPageEqualTo: aPageElement [
	<return: #Boolean>
	^ aPageElement viewModel = self pager pages first
]

{ #category : #'api - actions' }
GtPagerHolder >> isLastPageEqualTo: aPageElement [
	<return: #Boolean>
	^ aPageElement viewModel = self pager pages last
]

{ #category : #'api - actions' }
GtPagerHolder >> maximizeIn: aCreationContext [
	aCreationContext maximizePageContentInPager: self pager
]

{ #category : #'announcer - subscription' }
GtPagerHolder >> removeEventHandler: anEventHandler [
	self pager removeEventHandler: anEventHandler
]

{ #category : #'api - actions' }
GtPagerHolder >> select: aGtPagerPageSelectionContext [
	"Select a new page in a pager"
	self pager select: aGtPagerPageSelectionContext
]

{ #category : #'api - actions' }
GtPagerHolder >> smoothScrollToLast [
	"Scroll to the last page"
]

{ #category : #'api - actions' }
GtPagerHolder >> spawn: aGtPagerPageSelectionContext [
	"Spawn a new page in a pager"
	self pager spawn: aGtPagerPageSelectionContext
]
