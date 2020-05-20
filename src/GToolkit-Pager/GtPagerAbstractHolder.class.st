Class {
	#name : #GtPagerAbstractHolder,
	#superclass : #Object,
	#category : #'GToolkit-Pager-Strategies'
}

{ #category : #'api - actions' }
GtPagerAbstractHolder >> close: aPageElement [
	"Close/remove a page from a pager"
	self subclassResponsibility
]

{ #category : #testing }
GtPagerAbstractHolder >> isFirstPageEqualTo: aPageElement [
	<return: #Boolean>
	^ self subclassResponsibility
]

{ #category : #testing }
GtPagerAbstractHolder >> isLastPageEqualTo: aPageElement [
	<return: #Boolean>
	^ self subclassResponsibility
]

{ #category : #'api - actions' }
GtPagerAbstractHolder >> maximizeIn: aCreationContext [
	"maximize a page"
	self subclassResponsibility
]

{ #category : #'api - actions' }
GtPagerAbstractHolder >> select: aGtPagerPageSelectionContext [
	"Select a new page in a pager"
	self subclassResponsibility
]

{ #category : #'api - actions' }
GtPagerAbstractHolder >> smoothScrollToLast [
	"Scroll to the last page"
	self subclassResponsibility
]

{ #category : #'api - actions' }
GtPagerAbstractHolder >> spawn: aGtPagerPageSelectionContext [
	"Spawn a new page in a pager"
	self subclassResponsibility
]

{ #category : #'announcer - subscription' }
GtPagerAbstractHolder >> when: anEvent do: aBlock [
	"Register an event handler"
	^ self subclassResponsibility
]
