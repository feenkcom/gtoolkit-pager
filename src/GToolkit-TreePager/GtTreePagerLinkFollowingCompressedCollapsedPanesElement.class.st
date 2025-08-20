Class {
	#name : #GtTreePagerLinkFollowingCompressedCollapsedPanesElement,
	#superclass : #GtTreePagerLinkBasicElement,
	#instVars : [
		'containerElement'
	],
	#category : #'GToolkit-TreePager-UI'
}

{ #category : #initialization }
GtTreePagerLinkFollowingCompressedCollapsedPanesElement >> defaultLayout [
	^ BlFrameLayout new
]

{ #category : #'private - updating' }
GtTreePagerLinkFollowingCompressedCollapsedPanesElement >> ensureNodeForLinkModel: aLinkModel row: aRowIndex depth: aDepthIndex span: aSpanIndex [
	| anElement |
	anElement := containerElement children
			detect: [ :eachElement | eachElement linkModel = aLinkModel ]
			ifFound: [ :theElement | theElement ]
			ifNone: [ self newNodeElementForPaneModel: aLinkModel ].

	anElement
		constraintsDo: [ :c | 
			c horizontalTreeFlow
				row: aRowIndex;
				depth: aDepthIndex;
				span: aSpanIndex ].
				
	anElement hasParent ifFalse: [ containerElement addChild: anElement ].

	^ anElement
]

{ #category : #'accessing - ui' }
GtTreePagerLinkFollowingCompressedCollapsedPanesElement >> incomingLinkElements [
	^ containerElement children flatCollect: #incomingLinkElements
]

{ #category : #initialization }
GtTreePagerLinkFollowingCompressedCollapsedPanesElement >> initialize [
	super initialize.
	self fitContent.
	self initializeContainer.
	self addChild: containerElement
]

{ #category : #initialization }
GtTreePagerLinkFollowingCompressedCollapsedPanesElement >> initializeContainer [
	containerElement := BlElement new
			layout: (BlHorizontalTreeFlowLayout new
					numberOfVisibleColumns: 2;
					firstVisibleColumn: 1;
					horizontalOffset: 0;
					cellSpacing: GtTreePagerConstants previewCellSpacing);
			constraintsDo: [ :c | 
				c accountTransformation.
				c horizontal fitContent.
				c vertical exact: GtTreePagerConstants rectangleLength ];
			transformDo: [ :t | t rotateBy: 90 ]
]

{ #category : #'private - updating' }
GtTreePagerLinkFollowingCompressedCollapsedPanesElement >> newContextMenuFor: aLinkModel [
	aLinkModel ifNil: [ ^ nil ].

	^ GtTreePagerLinkContextMenuBuilder new
		linkModel: aLinkModel;
		build
]

{ #category : #'private - updating' }
GtTreePagerLinkFollowingCompressedCollapsedPanesElement >> newNodeElementForPaneModel: aLinkModel [
	^ GtTreePagerLinkFollowingRotatedCollapsedElement new
		linkModel: aLinkModel;
		hExact: GtTreePagerConstants rectangleLengthWithoutSpacing;
		vMatchParent;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 2);
		addAptitude: BrGlamorousFadedButtonExteriourAptitude;
		addAptitude: (BrGlamorousWithExplicitContextMenuAptitude new
				handleSubmenu: [ self newContextMenuFor: aLinkModel ]);
		in: [ :theElement | 
			theElement graph
				beNode;
				model: aLinkModel ];
		when: BlClickEvent do: [ :anEvent | self onLinkElementClick: anEvent ]
]

{ #category : #'api - link model' }
GtTreePagerLinkFollowingCompressedCollapsedPanesElement >> onGtTreePagerLinkModelStateChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'api - link model' }
GtTreePagerLinkFollowingCompressedCollapsedPanesElement >> onGtTreePagerPaneModelFollowingPanesChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'private - event handling' }
GtTreePagerLinkFollowingCompressedCollapsedPanesElement >> onLinkElementClick: anEvent [
	anEvent consumed: true.
	self hasLinkModel ifFalse: [ ^ self ].

	self linkModel expand
]

{ #category : #'api - link model' }
GtTreePagerLinkFollowingCompressedCollapsedPanesElement >> onLinkModelChanged [
	super onLinkModelChanged.

	self updateElement
]

{ #category : #'accessing - ui' }
GtTreePagerLinkFollowingCompressedCollapsedPanesElement >> outgoingLinkElements [
	^ containerElement children flatCollect: #outgoingLinkElements
]

{ #category : #'api - link model' }
GtTreePagerLinkFollowingCompressedCollapsedPanesElement >> subscribeToLinkModel [
	super subscribeToLinkModel.
	self linkModel weak
		when: GtTreePagerPaneModelFollowingLinksChanged
			send: #onGtTreePagerPaneModelFollowingPanesChanged:
			to: self;
		when: GtTreePagerLinkModelStateChanged
			send: #onGtTreePagerLinkModelStateChanged:
			to: self
]

{ #category : #'api - link model' }
GtTreePagerLinkFollowingCompressedCollapsedPanesElement >> unsubscribeFromLinkModel [
	super unsubscribeFromLinkModel.
	self linkModel unsubscribe: self
]

{ #category : #'private - updating' }
GtTreePagerLinkFollowingCompressedCollapsedPanesElement >> updateElement [
	| maxDepth displayedElements |
	maxDepth := 1.
	displayedElements := OrderedCollection new.

	GtTreePagerNonSpawnedHorizontalTreeFlowBuilder new
		linkModels: {self linkModel};
		nonSpawnedLinkModelBlock: [ :aLinkModel :aRowIndex :aDepthIndex :aSpanIndex | 
			maxDepth := maxDepth max: aDepthIndex.
			displayedElements
				add: (self
						ensureNodeForLinkModel: aLinkModel
						row: aRowIndex
						depth: aDepthIndex
						span: aSpanIndex) ];
		build.

	(containerElement children difference: displayedElements) do: #removeFromParent.

	containerElement layoutDo: [ :l | l numberOfVisibleColumns: maxDepth ]
]
