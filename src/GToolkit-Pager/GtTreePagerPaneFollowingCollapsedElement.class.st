Class {
	#name : #GtTreePagerPaneFollowingCollapsedElement,
	#superclass : #GtTreePagerLinkBasicElement,
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

{ #category : #'accessing - ui' }
GtTreePagerPaneFollowingCollapsedElement >> incomingLinkElements [
	^ Array with: rectangleElement
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
GtTreePagerPaneFollowingCollapsedElement >> newOutputElementForLinkModel: aLinkModel [
	| anElement |
	anElement := GtTreePagerPaneFollowingOutputElement new
			beSmallSize;
			linkModel: aLinkModel.

	aLinkModel isSpawned
		ifTrue: [ anElement beHorizontal.
			anElement margin: (BlInsets top: 1 bottom: 1) ]
		ifFalse: [ anElement beVertical.
			anElement margin: (BlInsets left: 1 right: 1) ].

	^ anElement
]

{ #category : #'api - pane model' }
GtTreePagerPaneFollowingCollapsedElement >> onLinkModelChanged [
	rectangleElement linkModel: self linkModel.
	self updateElement
]

{ #category : #'accessing - ui' }
GtTreePagerPaneFollowingCollapsedElement >> outgoingLinkElements [
	^ (rightOutputsElement children flatCollect: #outgoingLinkElements)
		, (bottomOutputsElement children flatCollect: #outgoingLinkElements)
]

{ #category : #'private - updating' }
GtTreePagerPaneFollowingCollapsedElement >> updateElement [
	self updateRectangleElement.
	self updateOutputElements
]

{ #category : #'private - updating' }
GtTreePagerPaneFollowingCollapsedElement >> updateOutputElements [
	| someElements |
	someElements := self linkModel followingLinks
			collect: [ :eachLink | self newOutputElementForLinkModel: eachLink ]
			as: Array.

	rightOutputsElement
		removeChildren;
		addChildren: (someElements select: [ :each | each linkModel isExpanded ]).

	bottomOutputsElement
		removeChildren;
		addChildren: (someElements select: [ :each | each linkModel isCollapsed ])
]

{ #category : #'private - updating' }
GtTreePagerPaneFollowingCollapsedElement >> updateRectangleElement [
	
]
