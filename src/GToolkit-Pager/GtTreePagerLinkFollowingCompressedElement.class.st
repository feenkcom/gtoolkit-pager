Class {
	#name : #GtTreePagerLinkFollowingCompressedElement,
	#superclass : #GtTreePagerLinkBasicElement,
	#instVars : [
		'containerElement'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #initialization }
GtTreePagerLinkFollowingCompressedElement >> defaultLayout [
	^ BlFrameLayout new
]

{ #category : #'private - updating' }
GtTreePagerLinkFollowingCompressedElement >> ensureNodeForPaneModel: aPaneModel row: aRowIndex depth: aDepthIndex span: aSpanIndex [
	| anElement |
	anElement := containerElement children
			detect: [ :eachElement | eachElement paneModel = aPaneModel ]
			ifFound: [ :theElement | theElement ]
			ifNone: [ self newNodeElementForPaneModel: aPaneModel ].

	anElement
		constraintsDo: [ :c | 
			c horizontalTreeFlow
				row: aRowIndex;
				depth: aDepthIndex;
				span: aSpanIndex ].
				
	anElement hasParent ifFalse: [ containerElement addChild: anElement ].

	^ anElement
]

{ #category : #initialization }
GtTreePagerLinkFollowingCompressedElement >> initialize [
	super initialize.
	self fitContent.
	self initializeContainer.
	self addChild: containerElement
]

{ #category : #initialization }
GtTreePagerLinkFollowingCompressedElement >> initializeContainer [
	containerElement := BlElement new
			layout: (BlHorizontalTreeFlowLayout new
					numberOfVisibleColumns: 2;
					firstVisibleColumn: 1;
					horizontalOffset: 0;
					cellSpacing: 2);
			constraintsDo: [ :c | 
				c accountTransformation.
				c horizontal fitContent.
				c vertical exact: 20 ];
			transformDo: [ :t | t rotateBy: 90 ]
]

{ #category : #'private - updating' }
GtTreePagerLinkFollowingCompressedElement >> newContextMenuFor: aPaneModel [
	| aLinkModel |
	aLinkModel := aPaneModel previousLink.
	aLinkModel ifNil: [ ^ nil ].

	^ GtTreePagerLinkContextMenuBuilder new
		linkModel: aLinkModel;
		build
]

{ #category : #'private - updating' }
GtTreePagerLinkFollowingCompressedElement >> newNodeElementForPaneModel: aPaneModel [
	^ GtTreePagerPaneScrollPreviewElement new
		paneModel: aPaneModel;
		hExact: 15;
		vMatchParent;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 2);
		addAptitude: BrGlamorousFadedButtonExteriourAptitude;
		addAptitude: (BrGlamorousWithExplicitContextMenuAptitude new
				handleSubmenu: [ self newContextMenuFor: aPaneModel ]);
		in: [ :theElement | 
			theElement graph
				beNode;
				model: aPaneModel ];
		when: BlClickEvent do: [ :anEvent | self onPaneElementClick: anEvent ]
]

{ #category : #'api - link model' }
GtTreePagerLinkFollowingCompressedElement >> onLinkModelChanged [
	super onLinkModelChanged.

	self updateElement
]

{ #category : #'private - event handling' }
GtTreePagerLinkFollowingCompressedElement >> onPaneElementClick: anEvent [
	| aPaneModel |
	anEvent consumed: true.
	aPaneModel := anEvent currentTarget paneModel ifNil: [ ^ self ].

	aPaneModel expand
]

{ #category : #'private - updating' }
GtTreePagerLinkFollowingCompressedElement >> updateElement [
	| maxDepth displayedElements |
	maxDepth := 1.
	displayedElements := OrderedCollection new.

	GtTreePagerNonSpawnedHorizontalTreeFlowBuilder new
		linkModels: self linkModel followingLinks;
		nonSpawnedLinkModelBlock: [ :aLinkModel :aRowIndex :aDepthIndex :aSpanIndex | 
			maxDepth := maxDepth max: aDepthIndex.
			displayedElements
				add: (self
						ensureNodeForPaneModel: aLinkModel paneModel
						row: aRowIndex
						depth: aDepthIndex
						span: aSpanIndex) ];
		build.

	(containerElement children difference: displayedElements) do: #removeFromParent.

	containerElement layout numberOfVisibleColumns: maxDepth
]
