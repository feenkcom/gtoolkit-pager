Class {
	#name : #GtTreePagerFlowPanesElement,
	#superclass : #GtTreePagerBasicElement,
	#traits : 'TBlHorizontalTreeFlowLayoutScrollable',
	#classTraits : 'TBlHorizontalTreeFlowLayoutScrollable classTrait',
	#instVars : [
		'paneElementsCache',
		'toolSelectionStateHandler'
	],
	#category : #'GToolkit-TreePager-UI'
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
		horizontalCellSpacing: GtTreePagerConstants horizontalCellSpacing;
		verticalCellSpacing: GtTreePagerConstants verticalCellSpacing
]

{ #category : #'private - updating' }
GtTreePagerFlowPanesElement >> ensureNodeForPaneModel: aPaneModel row: aRowIndex depth: aDepthIndex span: aSpanIndex [
	| anElement |
	anElement := self
			usedOrCachedChildNodeForPaneModel: aPaneModel
			ifFound: [ :theElement | theElement ]
			ifNone: [ self newNodeElementForPaneModel: aPaneModel ].

	anElement
		constraintsDo: [ :c | 
			c horizontalTreeFlow
				row: aRowIndex;
				depth: aDepthIndex;
				span: aSpanIndex ].

	anElement hasParent ifFalse: [ 
		anElement userData at: #treePagerNewElement put: true.
		self addChild: anElement ].

	^ anElement
]

{ #category : #initialization }
GtTreePagerFlowPanesElement >> initialize [
	super initialize.
	self matchParent.

	toolSelectionStateHandler := GtPhlowToolSelectionStateHandler new.
	
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
						navigationContext: (GtTreePagerPaneNavigationContext new
								pagerElement: self;
								paneElement: aPaneElement);
						addAptitude: (BrGlamorousWithHorizontalResizerAptitude new
								beRight;
								resizerDo: [ :aResizer | 
									aPaneElement
										addAptitude: (BrLazyStyleCommonAptitude new
												default: [ :aStyle | 
													aStyle
														do: [ :aWidget | 
															aPaneElement hideToolbarElements.
															aResizer visibility: BlVisibility hidden ]
														after: [ :aWidget |  ] ];
												hovered: [ :aStyle | 
													aStyle
														do: [ :aWidget | 
															aPaneElement showToolbarElements.
															aResizer visibility: BlVisibility visible ]
														after: [ :aWidget | 
															aPaneElement hideToolbarElements.
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
GtTreePagerFlowPanesElement >> onGtTreePagerLinkModelReplacedLinkRemoved: anAnnouncement [
	anAnnouncement linkModel topPreviousPane = self pagerModel ifFalse: [ ^ self ].

	BlTaskAction
		enqueueElement: self
		action: [ self
				updatePaneElementsCacheDueToRemovedReplacedLinkModel: anAnnouncement replacedLink ]
]

{ #category : #'private - event handling' }
GtTreePagerFlowPanesElement >> onGtTreePagerLinkModelStateChanged: anAnnouncement [
	anAnnouncement linkModel topPreviousPane = self pagerModel ifFalse: [ ^ self ].

	BlTaskAction
		enqueueElement: self
		action: [ self
				updatePaneAndEdgesDueToLinkModel: anAnnouncement linkModel
				oldState: anAnnouncement oldState
				newState: anAnnouncement newState
				reason: anAnnouncement reason ]
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

	BlTaskAction
		enqueueElement: self
		action: [ self
				updatePaneAndEdgesDueToPaneModel: anAnnouncement paneModel
				addedLinks: anAnnouncement addedFollowingLinks
				removedLinks: anAnnouncement removedFollowingLinks
				reason: anAnnouncement reason ]
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
			to: self;
		when: GtTreePagerLinkModelReplacedLinkRemoved
			send: #onGtTreePagerLinkModelReplacedLinkRemoved:
			to: self
]

{ #category : #accessing }
GtTreePagerFlowPanesElement >> toolSelectionStateHandlerDo: aBlock [
	^ toolSelectionStateHandler ifNotNil: aBlock
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
	self smoothNumberOfVisibleColumns: self pagerModel settings numberOfVisibleColumns
]

{ #category : #'private - updating' }
GtTreePagerFlowPanesElement >> updatePaneAndEdgeElements [
	| spawnedElements edgeElements nonSpawnedElements toRemoveElements toRemovePaneElements |
	spawnedElements := OrderedCollection new.
	nonSpawnedElements := OrderedCollection new.

	GtTreePagerHorizontalTreeFlowBuilder new
		linkModels: self pagerModel linkModels;
		replacedLinkModelBlock: [ :aLinkModel | 
			self
				usedOrCachedChildNodeForPaneModel: aLinkModel paneModel
				ifFound: [ :aPaneElement | nonSpawnedElements add: aPaneElement ]
				ifNone: [  ] ];
		nonSpawnedLinkModelBlock: [ :aLinkModel | 
			self
				usedOrCachedChildNodeForPaneModel: aLinkModel paneModel
				ifFound: [ :aPaneElement | nonSpawnedElements add: aPaneElement ]
				ifNone: [  ] ];
		spawnedLinkModelBlock: [ :aLinkModel :aRowIndex :aDepthIndex :aSpanIndex | 
			spawnedElements
				add: (self
						ensureNodeForPaneModel: aLinkModel paneModel
						row: aRowIndex
						depth: aDepthIndex
						span: aSpanIndex) ];
		build.

	edgeElements := GtTreePagerPanesEdgesBuilder new
			panesElement: self;
			displayedPaneElements: spawnedElements;
			build.

	spawnedElements addAll: edgeElements.
	toRemoveElements := self children difference: spawnedElements.
	toRemovePaneElements := toRemoveElements
			select: [ :eachElement | eachElement graph isNode ].

	"Let's store selection state of all removed pane elements."
	toRemovePaneElements do: [ :eachElement | 
		self toolSelectionStateHandlerDo: [ :aHandler | 
			eachElement realToolElementDo: [ :aToolElement | 
				aHandler storeSelectionStateFrom: aToolElement ] ] ].

	toRemoveElements do: [ :eachChild | 
		eachChild removeFromParent.
		(nonSpawnedElements identityIncludes: eachChild) ifFalse: [  
			"Let's notify not-used elements that they are permanently removed."
			BrWidgetPermanentlyRemovedEvent notifyWithAllChildren: eachChild ] ].
			
	"Let's apply selection state to new pane elements."
	self childrenDo: [ :eachChild | 
		(eachChild graph isNode and: [ 
			eachChild userData at: #treePagerNewElement 
				ifPresent: [ :aBoolean | 
					eachChild userData removeKey: #treePagerNewElement ifAbsent: [ "ignore" ].
					aBoolean ] 
				ifAbsent: [ false ] ])
				ifTrue: [ self toolSelectionStateHandlerDo: [ :aHandler | 
					eachChild realToolElementDo: [ :aToolElement | 
						aHandler applySelectionStateTo: aToolElement ] ] ] ].
				
	"For some reason I have to add edges later.
	Covered by `GtTreePagerWithScripterExamples>>#pagerWithFourPanesInFourColumns_collapseD`."
	self addChildren: edgeElements.

	paneElementsCache := nonSpawnedElements.

	self dispatchEvent: GtTreePagerFlowPaneElementsChanged new
]

{ #category : #'private - updating' }
GtTreePagerFlowPanesElement >> updatePaneAndEdgesDueToLinkModel: aLinkModel oldState: anOldState newState: aNewState reason: aReason [
	"From the UI interaction perspective:
	- `anOldState isSpawned` and `aNewState isSpawned not` => pane is not displayed,
		the pane could also be hidden, selected, or collapsed. Currently, we display
		'collapsed' rectangles in all those cases, so it is likely the best check to do
	- `anOldState isSpawned` and `aNewState isCollapsed` => pane is collapsed
	- `anOldState isCollapsed` and `aNewState isSpawned` => pane is expanded
		
	Note: We could optimize this part and not update the element if the state change
	does not affect number of displayed elements and edges.
	
	aReason is `GtTreePagerReason` instance."

	self updatePaneAndEdgeElements
]

{ #category : #'private - updating' }
GtTreePagerFlowPanesElement >> updatePaneAndEdgesDueToPaneModel: aPaneModel addedLinks: addedLinks removedLinks: removedLinks reason: aReason [
	"From the UI interaction perspective:
	- `addedLinks size = 1` and `removedLinks size = 0` => select/spawn action
	- `addedLinks size = 1` and `removedLinks size = 1` => select/spawn action 
		with `addedLinks anyOne replacedLink == removedLinks anyOne`
	- `addedLinks size = 0` and `removedLinks size = 1` => remove action.
	Reason is a `GtTreePagerReason` instance."
	
	self updatePaneAndEdgeElements
]

{ #category : #'private - updating' }
GtTreePagerFlowPanesElement >> updatePaneElementsCacheDueToRemovedReplacedLinkModel: aLinkModel [
	| somePaneModels |
	paneElementsCache ifNil: [ ^ self ].

	somePaneModels := Array streamContents: [ :aStream | 
		aStream nextPut: aLinkModel paneModel.
		aLinkModel allReplacedLinkModelsDo: [ :eachLinkModel | 
			aStream nextPut: eachLinkModel paneModel ] ].

	paneElementsCache := paneElementsCache reject: [ :eachElement | 
		somePaneModels identityIncludes: eachElement paneModel ]
]

{ #category : #'api - children enumeration' }
GtTreePagerFlowPanesElement >> usedOrCachedChildNodeForPaneModel: aPaneModel ifFound: aFoundBlock ifNone: aNoneBlock [
	^ self
		childNodeForPaneModel: aPaneModel
		ifFound: aFoundBlock
		ifNone: [ paneElementsCache
				ifNotNil: [ :aCollection | 
					aCollection
						detect: [ :eachPaneElement | eachPaneElement paneModel = aPaneModel ]
						ifFound: aFoundBlock
						ifNone: aNoneBlock ]
				ifNil: aNoneBlock ]
]
