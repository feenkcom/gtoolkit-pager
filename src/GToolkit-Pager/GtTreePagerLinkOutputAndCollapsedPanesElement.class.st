Class {
	#name : #GtTreePagerLinkOutputAndCollapsedPanesElement,
	#superclass : #GtTreePagerLinkBasicElement,
	#instVars : [
		'outputElement',
		'collapsedPanesElement',
		'containerElement'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #initialization }
GtTreePagerLinkOutputAndCollapsedPanesElement >> defaultLayout [
	^ BlFrameLayout new
]

{ #category : #'accessing - ui' }
GtTreePagerLinkOutputAndCollapsedPanesElement >> incomingLinkElements [
	^ collapsedPanesElement incomingLinkElements
]

{ #category : #initialization }
GtTreePagerLinkOutputAndCollapsedPanesElement >> initialize [
	super initialize.
	self
		vMatchParent;
		hFitContent.

	self initializeContainerElement.
	self initializeOutputElement.
	self initializeCollapsedPanesElement.

	containerElement addChild: outputElement as: #output.
	containerElement addChild: collapsedPanesElement as: #collapsed.
	self addChild: containerElement
]

{ #category : #initialization }
GtTreePagerLinkOutputAndCollapsedPanesElement >> initializeCollapsedPanesElement [
	collapsedPanesElement := GtTreePagerLinkFollowingCompressedCollapsedPanesElement new
			margin: (BlInsets left: GtTreePagerConstants leftShift);
			constraintsDo: [ :c | 
				c linear vertical alignTop.
				c linear horizontal alignLeft ]
]

{ #category : #initialization }
GtTreePagerLinkOutputAndCollapsedPanesElement >> initializeContainerElement [
	containerElement := BrVerticalPane new
			fitContent;
			constraintsDo: [ :c | 
				c frame horizontal alignLeft.
				c frame vertical alignCenter ]
]

{ #category : #initialization }
GtTreePagerLinkOutputAndCollapsedPanesElement >> initializeOutputElement [
	outputElement := GtTreePagerLinkFollowingOutputElement new
			beNormalSize;
			constraintsDo: [ :c | 
				c linear vertical alignTop.
				c linear horizontal alignLeft ]
]

{ #category : #'api - link model' }
GtTreePagerLinkOutputAndCollapsedPanesElement >> onLinkModelChanged [
	super onLinkModelChanged.
	outputElement linkModel: self linkModel.
	collapsedPanesElement linkModel: self linkModel
]

{ #category : #'accessing - ui' }
GtTreePagerLinkOutputAndCollapsedPanesElement >> outgoingLinkElements [
	^ Array
		streamContents: [ :aStream | 
			aStream nextPutAll: outputElement outgoingLinkElements.
			aStream nextPutAll: collapsedPanesElement outgoingLinkElements ]
]
