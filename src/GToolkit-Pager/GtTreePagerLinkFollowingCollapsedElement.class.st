Class {
	#name : #GtTreePagerLinkFollowingCollapsedElement,
	#superclass : #GtTreePagerLinkBasicElement,
	#instVars : [
		'rectangleElement',
		'rightOutputsElement',
		'bottomOutputsElement'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #initialization }
GtTreePagerLinkFollowingCollapsedElement >> defaultLayout [
	^ BlGridLayout horizontal columnCount: 2
]

{ #category : #'accessing - ui' }
GtTreePagerLinkFollowingCollapsedElement >> incomingLinkElements [
	^ Array with: rectangleElement
]

{ #category : #initialization }
GtTreePagerLinkFollowingCollapsedElement >> initialize [
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
GtTreePagerLinkFollowingCollapsedElement >> initializeBottomOutputsElement [
	bottomOutputsElement := BrHorizontalPane new
			fitContent;
			constraintsDo: [ :c | 
				c grid horizontal alignCenter.
				c grid vertical alignTop ]
]

{ #category : #initialization }
GtTreePagerLinkFollowingCollapsedElement >> initializeRectangleElement [
	rectangleElement := GtTreePagerLinkFollowingRectangleElement new
]

{ #category : #initialization }
GtTreePagerLinkFollowingCollapsedElement >> initializeRightOutputsElement [
	rightOutputsElement := BrVerticalPane new
			fitContent;
			constraintsDo: [ :c | 
				c grid horizontal alignLeft.
				c grid vertical alignCenter ]
]

{ #category : #'private - updating' }
GtTreePagerLinkFollowingCollapsedElement >> newOutputElementForLinkModel: aLinkModel [
	| anElement |
	anElement := GtTreePagerLinkFollowingOutputElement new
			beSmallSize;
			linkModel: aLinkModel.

	aLinkModel isSpawned
		ifTrue: [ anElement beHorizontal.
			anElement margin: (BlInsets top: 1 bottom: 1) ]
		ifFalse: [ anElement beVertical.
			anElement margin: (BlInsets left: 1 right: 1) ].

	^ anElement
]

{ #category : #'private - event handling' }
GtTreePagerLinkFollowingCollapsedElement >> onGtTreePagerPaneModelFollowingLinksChanged: anAnnouncement [
]

{ #category : #'api - pane model' }
GtTreePagerLinkFollowingCollapsedElement >> onLinkModelChanged [
	rectangleElement linkModel: self linkModel.
	self updateElement
]

{ #category : #'accessing - ui' }
GtTreePagerLinkFollowingCollapsedElement >> outgoingLinkElements [
	^ (rightOutputsElement children flatCollect: #outgoingLinkElements)
		, (bottomOutputsElement children flatCollect: #outgoingLinkElements)
]

{ #category : #'api - link model' }
GtTreePagerLinkFollowingCollapsedElement >> subscribeToLinkModel [
	super subscribeToLinkModel.

	self linkModel announcer weak
		when: GtTreePagerPaneModelFollowingLinksChanged
		send: #onGtTreePagerPaneModelFollowingLinksChanged:
		to: self
]

{ #category : #'api - link model' }
GtTreePagerLinkFollowingCollapsedElement >> unsubscribeFromLinkModel [
	super unsubscribeFromLinkModel.

	self linkModel announcer unsubscribe: self
]

{ #category : #'private - updating' }
GtTreePagerLinkFollowingCollapsedElement >> updateElement [
	self updateRectangleElement.
	self updateOutputElements
]

{ #category : #'private - updating' }
GtTreePagerLinkFollowingCollapsedElement >> updateOutputElements [
	| someElements |
	someElements := self linkModel followingLinks
			collect: [ :eachLink | self newOutputElementForLinkModel: eachLink ]
			as: Array.

	rightOutputsElement
		removeChildren;
		addChildren: (someElements select: [ :each | each linkModel isSpawned ]).

	bottomOutputsElement
		removeChildren;
		addChildren: (someElements select: [ :each | each linkModel isSpawned not ])
]

{ #category : #'private - updating' }
GtTreePagerLinkFollowingCollapsedElement >> updateRectangleElement [
	
]
