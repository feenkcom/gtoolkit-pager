Class {
	#name : #GtTreePagerPaneFollowingCollapsedElement,
	#superclass : #GtTreePagerPaneBasicElement,
	#instVars : [
		'rectangleElement',
		'rightOutputsElement',
		'bottomOutputsElement'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #initialization }
GtTreePagerPaneFollowingCollapsedElement >> defaultLayout [
	^ BlGridLayout horizontal columnCount: 2
]

{ #category : #initialization }
GtTreePagerPaneFollowingCollapsedElement >> initialize [
	super initialize.

	self fitContent.

	self initializeRectangleElement.
	self initializeRightOutputsElement.
	self initializeBottomOutputsElement.

	self
		addChildren: {rectangleElement.
				rightOutputsElement.
				bottomOutputsElement}
]

{ #category : #initialization }
GtTreePagerPaneFollowingCollapsedElement >> initializeBottomOutputsElement [
	bottomOutputsElement := BrHorizontalPane new
			fitContent;
			constraintsDo: [ :c | 
				c grid horizontal alignCenter.
				c grid vertical alignTop ]
]

{ #category : #initialization }
GtTreePagerPaneFollowingCollapsedElement >> initializeRectangleElement [
	rectangleElement := GtTreePagerPaneFollowingRectangleElement new
]

{ #category : #initialization }
GtTreePagerPaneFollowingCollapsedElement >> initializeRightOutputsElement [
	rightOutputsElement := BrVerticalPane new
			fitContent;
			constraintsDo: [ :c | 
				c grid horizontal alignLeft.
				c grid vertical alignCenter ]
]

{ #category : #'private - updating' }
GtTreePagerPaneFollowingCollapsedElement >> newOutputElementForPaneModel: aPaneModel [
	| anElement |
	anElement := GtTreePagerPaneFollowingOutputElement new
			beSmallSize;
			paneModel: aPaneModel.

	aPaneModel isExpanded
		ifTrue: [ anElement beHorizontal.
			anElement margin: (BlInsets top: 1 bottom: 1) ]
		ifFalse: [ anElement beVertical.
			anElement margin: (BlInsets left: 1 right: 1) ].

	^ anElement
]

{ #category : #'api - pane model' }
GtTreePagerPaneFollowingCollapsedElement >> onPaneModelChanged [
	rectangleElement paneModel: self paneModel.
	self updateElement
]

{ #category : #'private - updating' }
GtTreePagerPaneFollowingCollapsedElement >> updateElement [
	self updateRectangleElement.
	self updateOutputElements
]

{ #category : #'private - updating' }
GtTreePagerPaneFollowingCollapsedElement >> updateOutputElements [
	| someElements |
	someElements := self paneModel followingPanes
			collect: [ :eachPane | self newOutputElementForPaneModel: eachPane ]
			as: Array.

	rightOutputsElement
		removeChildren;
		addChildren: (someElements select: [ :each | each paneModel isExpanded ]).

	bottomOutputsElement
		removeChildren;
		addChildren: (someElements select: [ :each | each paneModel isCollapsed ])
]

{ #category : #'private - updating' }
GtTreePagerPaneFollowingCollapsedElement >> updateRectangleElement [
	
]
