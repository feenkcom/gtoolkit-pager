Class {
	#name : #GtTreePagerLinkOutputAndCollapsedPanesElement,
	#superclass : #GtTreePagerLinkBasicElement,
	#instVars : [
		'outputElement',
		'collapsedPanesElement',
		'containerElement',
		'replacedLinkElement'
	],
	#category : #'GToolkit-TreePager-UI'
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
	self initializeReplacedLinkElement.
	self initializeOutputElement.
	self initializeCollapsedPanesElement.

	containerElement addChild: replacedLinkElement as: #replaced.
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
			clipChildren: false;
			constraintsDo: [ :c | 
				"For some reason the replacedLinkElement jumps if we use ignoreByLayout with vertical alignBottomAt:.
				As a workaround, we use linear layout and move the container up."
				c padding: (BlInsets top: GtTreePagerConstants rectangleLengthWithoutSpacing negated).
				
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

{ #category : #initialization }
GtTreePagerLinkOutputAndCollapsedPanesElement >> initializeReplacedLinkElement [
	replacedLinkElement := GtTreePagerLinkReplacedElement new
			constraintsDo: [ :c | 
				"c ignoreByLayout."
				c ignored vertical alignBottomAt: 1.0.
				c ignored horizontal alignCenter.
				c linear vertical alignTop.
				c linear horizontal alignCenter ]
]

{ #category : #'api - link model' }
GtTreePagerLinkOutputAndCollapsedPanesElement >> onLinkModelChanged [
	super onLinkModelChanged.
	replacedLinkElement linkModel: self linkModel.
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
