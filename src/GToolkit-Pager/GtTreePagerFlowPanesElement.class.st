Class {
	#name : #GtTreePagerFlowPanesElement,
	#superclass : #GtTreePagerBasicElement,
	#traits : 'TBlHorizontalTreeFlowLayoutScrollable',
	#classTraits : 'TBlHorizontalTreeFlowLayoutScrollable classTrait',
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'api - children enumeration' }
GtTreePagerFlowPanesElement >> childNodeForPaneModel: aPaneModel ifFound: aFoundBlock ifNone: aNoneBlock [
	^ self children
		detect: [ :eachElement | eachElement graph isNode and: [ eachElement paneModel = aPaneModel ] ]
		ifFound: aFoundBlock
		ifNone: aNoneBlock
]

{ #category : #'api - children enumeration' }
GtTreePagerFlowPanesElement >> childrenNodesAtColumn: aDepth do: aDoBlock [
	self
		childrenNodesSuchThat: [ :eachNodeElement | eachNodeElement constraints horizontalTreeFlow depth = aDepth ]
		do: aDoBlock
]

{ #category : #'api - children enumeration' }
GtTreePagerFlowPanesElement >> childrenNodesDo: aBlock [
	self childrenDo: [ :eachElement | 
		eachElement graph isNode ifTrue: [ 
			aBlock value: eachElement ] ]
]

{ #category : #'api - children enumeration' }
GtTreePagerFlowPanesElement >> childrenNodesLastColumn [
	| maxDepth |
	maxDepth := 0.
	self childrenNodesDo: [ :eachNodeElement | 
		maxDepth := maxDepth max: eachNodeElement constraints horizontalTreeFlow depth ].
	^ maxDepth
]

{ #category : #'api - children enumeration' }
GtTreePagerFlowPanesElement >> childrenNodesSuchThat: aConditionBlock do: aDoBlock [
	self childrenNodesDo: [ :eachNodeElement | 
		(aConditionBlock value: eachNodeElement) ifTrue: [ 
			aDoBlock value: eachNodeElement ] ]
]

{ #category : #initialization }
GtTreePagerFlowPanesElement >> defaultLayout [
	^ BlHorizontalTreeFlowLayout new
		numberOfVisibleColumns: 2;
		firstVisibleColumn: 1;
		horizontalOffset: 0;
		cellSpacing: GtTreePagerConstants cellSpacing
]

{ #category : #'private - updating' }
GtTreePagerFlowPanesElement >> ensureNodeForPaneModel: aPaneModel row: aRowIndex depth: aDepthIndex span: aSpanIndex [
	| anElement |
	anElement := self
			childNodeForPaneModel: aPaneModel
			ifFound: [ :theElement | theElement ]
			ifNone: [ self newNodeElementForPaneModel: aPaneModel ].

	anElement
		constraintsDo: [ :c | 
			c horizontalTreeFlow
				row: aRowIndex;
				depth: aDepthIndex;
				span: aSpanIndex ].

	anElement hasParent ifFalse: [ self addChild: anElement ].
	
	^ anElement
]

{ #category : #initialization }
GtTreePagerFlowPanesElement >> initialize [
	super initialize.
	self matchParent.

	self
		when: BlMouseWheelEvent
		do: [ :anEvent | self layoutDo: [ :aLayout | aLayout mouseWheelEvent: anEvent ] ]
]

{ #category : #'private - updating' }
GtTreePagerFlowPanesElement >> newNodeElementForPaneModel: aPaneModel [
	^ GtTreePagerPaneElement new
		in: [ :aPaneElement | 
			aPaneElement
				contentElementDo: [ :aContentElement | 
					aContentElement
						addAptitude: (BrGlamorousWithHorizontalResizerAptitude new
								beRight;
								resizerDo: [ :aResizer | 
									aPaneElement
										addAptitude: (BrLazyStyleCommonAptitude new
												default: [ :aStyle | 
													aStyle
														do: [ :aWidget | 
															aPaneElement hideMaximizeButton.
															aPaneElement hideDisappearElement.
															aResizer visibility: BlVisibility hidden ]
														after: [ :aWidget |  ] ];
												hovered: [ :aStyle | 
													aStyle
														do: [ :aWidget | 
															aPaneElement showMaximizeButton.
															aPaneElement showDisappearElement.
															aResizer visibility: BlVisibility visible ]
														after: [ :aWidget | 
															aPaneElement hideMaximizeButton.
															aPaneElement hideDisappearElement.
															aResizer visibility: BlVisibility hidden ] ]).

									aResizer
										when: BlDoubleClickEvent
										do: [ :anEvent | self onPaneElement: aPaneElement resizerDoubleClickEvent: anEvent ] ];
								whenResizedDo: [ :anEvent | self onPaneElement: aPaneElement resizedEvent: anEvent ]) ].
			aPaneElement graph
				beNode;
				model: aPaneModel ];
		paneModel: aPaneModel
]

{ #category : #'private - event handling' }
GtTreePagerFlowPanesElement >> onGtTreePagerLinkModelStateChanged: anAnnouncement [
	anAnnouncement linkModel topPreviousPane = self pagerModel ifFalse: [ ^ self ].

	BlTaskAction
		enqueueElement: self
		action: [ self updatePaneAndEdgeElements ]
]

{ #category : #'private - event handling' }
GtTreePagerFlowPanesElement >> onGtTreePagerModelColumnHeightChanged: anAnnouncement [
	self pagerModel settings = anAnnouncement settings ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ self updateElementLayoutColumnHeight ]
]

{ #category : #'private - event handling' }
GtTreePagerFlowPanesElement >> onGtTreePagerModelNumberOfVisibleColumnsChanged: anAnnouncement [
	self pagerModel settings = anAnnouncement settings ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ self updateElementLayoutNumberOfVisibleColumns ]
]

{ #category : #'private - event handling' }
GtTreePagerFlowPanesElement >> onGtTreePagerPaneModelFollowingPanesChanged: anAnnouncement [
	anAnnouncement paneModel topPreviousPane = self pagerModel ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ self updatePaneAndEdgeElements ]
]

{ #category : #'api - pager model' }
GtTreePagerFlowPanesElement >> onPagerModelChanged [
	super onPagerModelChanged.
	self updateElement
]

{ #category : #'private - event handling' }
GtTreePagerFlowPanesElement >> onPaneElement: aPaneElement resizedEvent: anEvent [
	| aDepth |
	anEvent consumed: true.
	aPaneElement hFitContent.

	aDepth := aPaneElement constraints horizontalTreeFlow depth.
	
	"Let's keep the last column inside of the parent element bounds."
	((self childrenNodesLastColumn = aDepth) and: [ 
		anEvent originalExtent x < anEvent extent x ]) ifTrue: [
			self scrollToColumn: aDepth ].
	
	anEvent modifiers isPrimaryModifier ifTrue: [ ^ self ].
	
	"Let's resize all panes in the same column"
	self
		childrenNodesAtColumn: aDepth
		do: [ :eachPaneElement | 
			aPaneElement ~= eachPaneElement ifTrue: [ 
				eachPaneElement contentElement hExact: anEvent extent x.
				eachPaneElement hFitContent ] ]
]

{ #category : #'private - event handling' }
GtTreePagerFlowPanesElement >> onPaneElement: aPaneElement resizerDoubleClickEvent: anEvent [
	"I do not understand why I have to call `aPaneElement contentElement hMatchParent`.
	I think the resizer used in `GtTreePagerPaneElement>>#initialize` should handle this case nicely."

	| aDepth |
	anEvent consumed: true.

	aPaneElement hMatchParent.
	aPaneElement contentElement hMatchParent.

	anEvent modifiers isPrimaryModifier ifTrue: [ ^ self ].
	
	"Let's resize all panes in the same column"
	aDepth := aPaneElement constraints horizontalTreeFlow depth.
	self
		childrenNodesAtColumn: aDepth
		do: [ :eachPaneElement | 
			aPaneElement ~= eachPaneElement ifTrue: [
				eachPaneElement hMatchParent.
				eachPaneElement contentElement hMatchParent ] ]
]

{ #category : #'api - pager model' }
GtTreePagerFlowPanesElement >> subscribeToPagerModel [
	self pagerModel announcer weak
		when: GtTreePagerPaneModelFollowingLinksChanged
			send: #onGtTreePagerPaneModelFollowingPanesChanged:
			to: self;
		when: GtTreePagerLinkModelStateChanged
			send: #onGtTreePagerLinkModelStateChanged:
			to: self;
		when: GtTreePagerModelColumnHeightChanged
			send: #onGtTreePagerModelColumnHeightChanged:
			to: self;
		when: GtTreePagerModelNumberOfVisibleColumnsChanged
			send: #onGtTreePagerModelNumberOfVisibleColumnsChanged:
			to: self
]

{ #category : #'api - pager model' }
GtTreePagerFlowPanesElement >> unsubscribeFromPagerModel [
	self pagerModel unsubscribe: self
]

{ #category : #'private - updating' }
GtTreePagerFlowPanesElement >> updateElement [
	self updateElementLayoutNumberOfVisibleColumns.
	self updateElementLayoutColumnHeight.
	self updatePaneAndEdgeElements
]

{ #category : #'private - updating' }
GtTreePagerFlowPanesElement >> updateElementLayoutColumnHeight [
	self layoutDo: [ :l | l rowCount: self pagerModel settings columnHeight ]
]

{ #category : #'private - updating' }
GtTreePagerFlowPanesElement >> updateElementLayoutNumberOfVisibleColumns [
	self
		layoutDo: [ :l | l numberOfVisibleColumns: self pagerModel settings numberOfVisibleColumns ]
]

{ #category : #'private - updating' }
GtTreePagerFlowPanesElement >> updatePaneAndEdgeElements [
	| displayedElements edgeElements |
	displayedElements := OrderedCollection new.

	GtTreePagerHorizontalTreeFlowBuilder new
		linkModels: self pagerModel linkModels;
		forEachPaneModelDo: [ :aLinkModel :aRowIndex :aDepthIndex :aSpanIndex | 
			displayedElements
				add: (self
						ensureNodeForPaneModel: aLinkModel paneModel
						row: aRowIndex
						depth: aDepthIndex
						span: aSpanIndex) ];
		build.

	edgeElements := GtTreePagerPanesEdgesBuilder new
			panesElement: self;
			displayedPaneElements: displayedElements;
			build.

	self addChildren: edgeElements.
	displayedElements addAll: edgeElements.

	(self children difference: displayedElements) do: #removeFromParent.

	self dispatchEvent: GtTreePagerFlowPaneElementsChanged new
]
