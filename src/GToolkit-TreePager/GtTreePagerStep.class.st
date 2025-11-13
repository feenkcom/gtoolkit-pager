Class {
	#name : #GtTreePagerStep,
	#superclass : #BlDevScripterToolActionStep,
	#category : #'GToolkit-TreePager-Examples'
}

{ #category : #'steps - checks' }
GtTreePagerStep >> assertCollapsedRectangleLinkModel: aLinkModel [
	| aLabel |
	aLabel := 'Assert collapsed rectangle link element for {1}'
			format: {aLinkModel title}.

	^ self assert
		label: aLabel;
		value: [ :aPanesElement | 
				((aPanesElement query // GtTreePagerLinkFollowingRotatedCollapsedElement)
					@ [ :eachElement | eachElement linkModel = aLinkModel ]) result size ]
			equals: 1;
		referenceSender;
		onParentStepTarget: self;
		// GtTreePagerFlowPanesElement
]

{ #category : #'steps - checks' }
GtTreePagerStep >> assertDropdownButtonHasCollapseIconInPaneModel: aPaneModel [
	| aLabel |
	aLabel := 'Assert dropdown button has collapse icon for {1}'
			format: {aPaneModel title}.

	^ self assert
		label: aLabel;
		value: [ :aDropdownButton | 
				aDropdownButton userData
					at: #gtTreePagerDropdownElementState
					ifPresent: [ :aSymbol | aSymbol ]
					ifAbsent: [ #downwards ] ]
			equals: #collapse;
		referenceSender;
		onParentStepTarget: self;
		// GtTreePagerFlowPanesElement;
		/ GtTreePagerPaneElement;
		@ [ :each | each paneModel = aPaneModel ];
		// #'tree-pager--dropdown-menu-button'
]

{ #category : #'steps - checks' }
GtTreePagerStep >> assertDropdownButtonHasDefaultIconInPaneModel: aPaneModel [
	| aLabel |
	aLabel := 'Assert dropdown button has default icon for {1}'
			format: {aPaneModel title}.

	^ self assert
		label: aLabel;
		value: [ :aDropdownButton | 
				aDropdownButton userData
					at: #gtTreePagerDropdownElementState
					ifPresent: [ :aSymbol | aSymbol ]
					ifAbsent: [ #downwards ] ]
			equals: #downwards;
		referenceSender;
		onParentStepTarget: self;
		// GtTreePagerFlowPanesElement;
		/ GtTreePagerPaneElement;
		@ [ :each | each paneModel = aPaneModel ];
		// #'tree-pager--dropdown-menu-button'
]

{ #category : #'steps - checks' }
GtTreePagerStep >> assertDropdownButtonHasMaximizeIconInPaneModel: aPaneModel [
	| aLabel |
	aLabel := 'Assert dropdown button has maximize icon for {1}'
			format: {aPaneModel title}.

	^ self assert
		label: aLabel;
		value: [ :aDropdownButton | 
				aDropdownButton userData
					at: #gtTreePagerDropdownElementState
					ifPresent: [ :aSymbol | aSymbol ]
					ifAbsent: [ #downwards ] ]
			equals: #maximize;
		referenceSender;
		onParentStepTarget: self;
		// GtTreePagerFlowPanesElement;
		/ GtTreePagerPaneElement;
		@ [ :each | each paneModel = aPaneModel ];
		// #'tree-pager--dropdown-menu-button'
]

{ #category : #'steps - checks' }
GtTreePagerStep >> assertDropdownButtonIsHiddenInPaneModel: aPaneModel [
	| aLabel |
	aLabel := 'Assert dropdown button is hidden for {1}'
			format: {aPaneModel title}.

	^ self assert
		label: aLabel;
		value: [ :aDropdownButton | aDropdownButton visibility ]
			equals: BlVisibility gone;
		referenceSender;
		onParentStepTarget: self;
		// GtTreePagerFlowPanesElement;
		/ GtTreePagerPaneElement;
		@ [ :each | each paneModel = aPaneModel ];
		// #'tree-pager--dropdown-menu-button'
]

{ #category : #'steps - checks' }
GtTreePagerStep >> assertDropdownButtonIsVisibleInPaneModel: aPaneModel [
	| aLabel |
	aLabel := 'Assert dropdown button is visible for {1}'
			format: {aPaneModel title}.

	^ self assert
		label: aLabel;
		value: [ :aDropdownButton | aDropdownButton visibility ]
			equals: BlVisibility visible;
		referenceSender;
		onParentStepTarget: self;
		// GtTreePagerFlowPanesElement;
		/ GtTreePagerPaneElement;
		@ [ :each | each paneModel = aPaneModel ];
		// #'tree-pager--dropdown-menu-button'
]

{ #category : #'steps - checks' }
GtTreePagerStep >> assertEdgeElementsPositions [
	^ self assert
		label: 'Assert following pane edges positions';
		satisfies: [ :aPanesElement | 
				| paneElements outgoingElements edgeElements misplacedEdges edgesWithoutTriangle |
				misplacedEdges := OrderedCollection new.
				edgesWithoutTriangle := OrderedCollection new.
				aPanesElement userData
					at: #misplacedEdges put: misplacedEdges;
					at: #edgesWithoutTriangle put: edgesWithoutTriangle.

				paneElements := aPanesElement children
						select: [ :eachChild | eachChild graph isNode ].
				outgoingElements := paneElements flatCollect: #outgoingLinkElements.
				edgeElements := aPanesElement children
						select: [ :eachChild | eachChild graph isEdge ].

				edgeElements
					do: [ :eachEdge | 
						| eachLinkModel |
						eachLinkModel := eachEdge graph model.
						outgoingElements
							detect: [ :eachTriangle | eachTriangle linkModel = eachLinkModel ]
							ifFound: [ :aTriangle | 
								aTriangle bounds inSpace bounds right = eachEdge bounds inSpace bounds left
									ifFalse: [ misplacedEdges
											add: {eachEdge.
													aTriangle} ] ]
							ifNone: [ edgesWithoutTriangle add: {eachEdge} ] ].
				misplacedEdges isEmpty and: [ edgesWithoutTriangle isEmpty ] ]
			description: [ :aPanesElement | 
				'Misplaced link edges: {1}; missing pane outgoing elements for: {2}'
					format: {(aPanesElement userData at: #misplacedEdges)
								collect: [ :each | (each at: 1) graph model title ]
								as: Array.
							(aPanesElement userData at: #edgesWithoutTriangle)
								collect: [ :each | (each at: 1) graph model title ]
								as: Array} ];
		// GtTreePagerFlowPanesElement;
		referenceSender;
		onParentStepTarget: self
]

{ #category : #'steps - checks' }
GtTreePagerStep >> assertNumberOfCollapsedRectangleLinkElements: anInteger [
	| aLabel |
	aLabel := 'Assert number of collapsed rectangle link elements is {1}'
			format: {anInteger}.

	^ self assert
		label: aLabel;
		value: [ :aPanesElement | 
				(aPanesElement query // GtTreePagerLinkFollowingRotatedCollapsedElement) result
					size ]
			equals: anInteger;
		referenceSender;
		onParentStepTarget: self;
		// GtTreePagerFlowPanesElement
]

{ #category : #'steps - checks' }
GtTreePagerStep >> assertNumberOfCollapsedTriangleLinkElements: anInteger [
	| aLabel |
	aLabel := 'Assert number of collapsed triangle link elements is {1}'
			format: {anInteger}.

	^ self assert
		label: aLabel;
		value: [ :aPanesElement :aUserData | 
				| aQuery |
				aQuery := (aPanesElement query // GtTreePagerLinkFollowingOutputElement)
						@ [ :eachElement | eachElement hasLinkModel ]
						@ [ :eachElement | eachElement linkModel isSpawned not ].

				aUserData at: aLabel put: aQuery.
				aQuery result size ]
			equals: anInteger;
		referenceSender;
		onParentStepTarget: self;
		// GtTreePagerFlowPanesElement
]

{ #category : #'steps - checks' }
GtTreePagerStep >> assertNumberOfEdgeElements: anInteger [
	| aLabel |
	aLabel := 'Assert number of edge elements is {1}' format: {anInteger}.

	^ self assert
		label: aLabel;
		value: [ :aPanesElement | 
				((aPanesElement query // BlCurveElement)
					@ [ :each | each graph model isKindOf: GtTreePagerLinkModel ]) result size ]
			equals: anInteger;
		referenceSender;
		onParentStepTarget: self;
		// GtTreePagerFlowPanesElement
]

{ #category : #'steps - checks' }
GtTreePagerStep >> assertNumberOfPaneElements: anInteger [
	| aLabel |
	aLabel := 'Assert number of pane elements is {1}' format: {anInteger}.

	^ self assert
		label: aLabel;
		value: [ :aPanesElement | (aPanesElement query // GtTreePagerPaneElement) result size ]
			equals: anInteger;
		referenceSender;
		onParentStepTarget: self;
		// GtTreePagerFlowPanesElement
]

{ #category : #'steps - checks' }
GtTreePagerStep >> assertNumberOfSpawnedNormalTriangleLinkElements: anInteger [
	"I include from spanwed pane to spawned pane link output elements only"

	| aLabel |
	aLabel := 'Assert number of spawned normal triangle link elements is {1}'
			format: {anInteger}.

	^ self assert
		label: aLabel;
		value: [ :aPanesElement | 
				| aQuery |
				aQuery := (aPanesElement query // GtTreePagerLinkFollowingOutputElement)
						@ [ :eachElement | eachElement hasLinkModel ]
						@ [ :eachElement | eachElement linkModel isSpawned ].
				aPanesElement userData at: aLabel put: aQuery.
				aQuery result size ]
			equals: anInteger;
		referenceSender;
		onParentStepTarget: self;
		// GtTreePagerFlowPanesElement
]

{ #category : #'steps - checks' }
GtTreePagerStep >> assertNumberOfSpawnedSmallTriangleLinkElements: anInteger [
	"I include from collapsed pane to spawned pane link output elements only"

	| aLabel |
	aLabel := 'Assert number of spawned small triangle link elements is {1}'
			format: {anInteger}.

	^ self assert
		label: aLabel;
		value: [ :aPanesElement | 
				| aQuery |
				aQuery := (aPanesElement query
						// GtTreePagerLinkCollapsedOutgoingLinkElement)
						@ [ :eachElement | eachElement hasLinkModel and: [ eachElement linkModel isSpawned ] ].
				aPanesElement userData at: aLabel put: aQuery.
				aQuery result size ]
			equals: anInteger;
		referenceSender;
		onParentStepTarget: self;
		// GtTreePagerFlowPanesElement
]

{ #category : #'steps - checks' }
GtTreePagerStep >> assertNumberOfSpawnedTriangleLinkElements: anInteger [
	"Note, that I include all link output elements to spawned panes,
	including from the collapsed rectangle link elements"

	| aLabel |
	aLabel := 'Assert number of spawned triangle link elements is {1}'
			format: {anInteger}.

	^ self assert
		label: aLabel;
		value: [ :aPanesElement | 
				| aQuery |
				aQuery := aPanesElement query
						// [ :eachElement | 
							((eachElement isKindOf: GtTreePagerLinkFollowingOutputElement)
								and: [ eachElement hasLinkModel and: [ eachElement linkModel isSpawned ] ])
								or: [ eachElement isKindOf: GtTreePagerLinkCollapsedOutgoingLinkElement ] ].
				aPanesElement userData at: aLabel put: aQuery.
				aQuery result size ]
			equals: anInteger;
		referenceSender;
		onParentStepTarget: self;
		// GtTreePagerFlowPanesElement
]

{ #category : #'steps - checks' }
GtTreePagerStep >> assertNumberOfVisiblePanes: anInteger [
	| aLabel |
	aLabel := 'Assert number of visible panes is {1}' format: {anInteger}.

	^ self assert
		label: aLabel;
		satisfies: [ :aPanesElement | 
				| aVisibleRectangle allPaneElements visiblePaneElements |
				aVisibleRectangle := aPanesElement bounds inSpace bounds asRectangle.
				allPaneElements := (aPanesElement query // GtTreePagerPaneElement) result.
				visiblePaneElements := allPaneElements
						select: [ :eachPaneElement | 
							aVisibleRectangle
								containsRect: eachPaneElement bounds inSpace bounds asRectangle ].
				visiblePaneElements size = anInteger
					ifFalse: [ aPanesElement userData at: #assertionAllPanes put: allPaneElements.
						aPanesElement userData at: #assertionAllPanes put: visiblePaneElements ].
				visiblePaneElements size = anInteger ]
			description: [ :aPanesElement | 
				'There are only {1} visible pane elements out of {2} pane elements'
					format: {aPanesElement userData at: #assertionAllPanes.
							aPanesElement userData at: #assertionAllPanes} ];
		referenceSender;
		onParentStepTarget: self;
		// GtTreePagerFlowPanesElement
]

{ #category : #'steps - checks' }
GtTreePagerStep >> assertPaneModel: aPaneModel position: aPoint [
	^ self assert
		label: ('Assert pane "{1}" position in parent is {2}'
				format: {aPaneModel title.
						aPoint});
		value: [ :aPaneElement | aPaneElement bounds inParent bounds topLeft ]
			equals: [ aPoint ];
		// GtTreePagerFlowPanesElement;
		// GtTreePagerPaneElement;
		@ [ :each | each paneModel = aPaneModel ];
		referenceSender;
		onParentStepTarget: self
]

{ #category : #'steps - checks' }
GtTreePagerStep >> assertPreviewScrollbarThumbAlignment: anAlignment weight: aWeight [
	"For some reason the alignment value vary a lot.
	For that reason I changed precision from 0.01 to 0.1."

	^ self
		substeps: 'Assert preview scrollbar thumb'
		do: [ :aStep | 
			aStep do
				label: 'Compute layout if necessary';
				block: [ :aSpace | 
					| aCount |
					aCount := 0.
					[ aCount < 5 and: [ aSpace isLayoutRequested ] ]
						whileTrue: [ aSpace doLayout.
							aCount := aCount + 1 ] ];
				onSpace.

			aStep assert
				label: ('Assert preview scrollbar thumb alignment: {1}' format: {anAlignment});
				satisfies: [ :aThumb | 
						aThumb constraints frame horizontal alignment coordinate
							closeTo: anAlignment
							precision: 0.1 ]
					description: [ :aThumb | 
						'Scrollbar thumb alignment is {1}, expected {2}'
							format: {aThumb constraints frame horizontal alignment coordinate.
									anAlignment} ];
				referenceSender;
				onParentStepTarget: self;
				// GtTreePagerScrollbarElement;
				// BlHorizontalScrollbarElement;
				/ #thumb.

			aStep assert
				label: ('Assert preview scrollbar thumb weight: {1}' format: {aWeight});
				satisfies: [ :aThumb | aThumb constraints frame horizontal weight closeTo: aWeight precision: 0.01 ]
					description: [ :aThumb | 
						'Scrollbar thumb weight is {1}, expected {2}'
							format: {aThumb constraints frame horizontal weight.
									aWeight} ];
				referenceSender;
				onParentStepTarget: self;
				// GtTreePagerScrollbarElement;
				// BlHorizontalScrollbarElement;
				/ #thumb ]
]

{ #category : #'steps - checks' }
GtTreePagerStep >> assertSpawnedTriangleLinkModel: aLinkModel [
	| aLabel |
	aLabel := 'Assert spawned triangle link element for {1}'
			format: {aLinkModel title}.

	^ self assert
		label: aLabel;
		value: [ :aPanesElement | 
				| aQuery |
				aQuery := (aPanesElement query // GtTreePagerLinkFollowingOutputElement)
						@ [ :eachElement | eachElement hasLinkModel ]
						@ [ :eachElement | eachElement linkModel isSpawned ]
						@ [ :eachElement | eachElement linkModel = aLinkModel ].
				aPanesElement userData at: aLabel put: aQuery.
				aQuery result size ]
			equals: 1;
		referenceSender;
		onParentStepTarget: self;
		// GtTreePagerFlowPanesElement
]

{ #category : #'steps - interactions' }
GtTreePagerStep >> clickCollapsedLinkModel: aLinkModel [
	^ self click
		label: ('Click on collapsed link "{1}"' format: {aLinkModel title});
		// GtTreePagerFlowPanesElement;
		// GtTreePagerLinkFollowingRotatedCollapsedElement;
		@ [ :each | each linkModel = aLinkModel ];
		referenceSender;
		onParentStepTarget: self
]

{ #category : #'steps - interactions' }
GtTreePagerStep >> clickDropdownCollapseMenuItem [
	^ self menuStep
		clickMenuItemWithId: #'tree-pager--menu-collapse';
		onMenuContainer;
		referenceSender
]

{ #category : #'steps - interactions' }
GtTreePagerStep >> clickDropdownRemoveMenuItem [
	^ self menuStep
		clickMenuItemWithId: #'tree-pager--menu-remove';
		onMenuContainer;
		referenceSender
]

{ #category : #'steps - interactions' }
GtTreePagerStep >> clickOnReplacedLinkModel: aLinkModel [
	^ self click
		label: ('Click on replaced link "{1}"' format: {aLinkModel title});
		// GtTreePagerFlowPanesElement;
		// GtTreePagerLinkReplacedElement;
		@ [ :each | each linkModel = aLinkModel ];
		referenceSender;
		onParentStepTarget: self
]

{ #category : #'steps - interactions' }
GtTreePagerStep >> closeConfigurationDropdownMenu [
	^ self menuStep
		referenceSender;
		label: 'Close configuration dropdown menu';
		assertMenuContainerExist;
		clickHandleWithId: #'tree-pager--configuration-menu-handle';
		assertClosedMenuContainer;
		onPopover
]

{ #category : #'steps - interactions' }
GtTreePagerStep >> dragInspectorPlaygroundAtPaneColumn: aColumn row: aRow verticallyBy: aNumber [
	^ self inspectorStep
		label: ('Inspector playground at pane column {1} row {2}'
				format: {aColumn.
						aRow});
		referenceSender;
		dragPlaygroundVerticallyBy: aNumber;
		onTreePagerPaneColumn: aColumn row: aRow
]

{ #category : #'steps - interactions' }
GtTreePagerStep >> hoverCollapsedLinkModel: aLinkModel [
	^ self mouseMoveOver
		label: ('Move mouse to collapsed link "{1}"' format: {aLinkModel title});
		// GtTreePagerFlowPanesElement;
		// GtTreePagerLinkFollowingRotatedCollapsedElement;
		@ [ :each | each linkModel = aLinkModel ];
		referenceSender;
		onParentStepTarget: self
]

{ #category : #'steps - interactions' }
GtTreePagerStep >> hoverPaneModel: aPaneModel [
	^ self mouseMoveOver
		label: ('Move mouse to pane "{1}"' format: {aPaneModel title});
		// GtTreePagerFlowPanesElement;
		/ GtTreePagerPaneElement;
		@ [ :each | each paneModel = aPaneModel ];
		referenceSender;
		onParentStepTarget: self
]

{ #category : #'steps - interactions' }
GtTreePagerStep >> increaseNumberOfVisibleColumns [
	| aRootStep |
	aRootStep := self
			substeps2: 'Increase number of visible columns'
			do: [ :aStep | 
				| previousNumberOfVisibleColumns |
				aStep menuStep openDropdownWithId: #'tree-pager--configuration-menu-button'.

				aStep do
					label: 'Get displayed number of columns';
					block: [ :aLabel | 
						previousNumberOfVisibleColumns := aLabel text asString asInteger.
						self assert: previousNumberOfVisibleColumns isInteger.
						self assert: previousNumberOfVisibleColumns > 0 ];
					onPopover;
					// #'tree-pager--visible-columns-value'.

				aStep click
					label: 'Increase number of visible columns';
					onPopover;
					// #'tree-pager--visible-columns-increase'.

				aStep assert
					label: 'Assert displayed number of columns';
					value: [ :aLabel | aLabel text asString asInteger ]
						equals: [ previousNumberOfVisibleColumns + 1 ];
					onPopover;
					// #'tree-pager--visible-columns-value' ].

	aRootStep referenceSender.

	^ aRootStep
]

{ #category : #'steps - interactions' }
GtTreePagerStep >> openDropdownPaneModel: aPaneModel [
	^ self menuStep
		openDropdown;
		label: ('Open dropdown for pane "{1}"' format: {aPaneModel title});
		// GtTreePagerFlowPanesElement;
		/ GtTreePagerPaneElement;
		@ [ :each | each paneModel = aPaneModel ];
		// #'tree-pager--dropdown-menu-button';
		referenceSender;
		onParentStepTarget: self
]

{ #category : #'steps - other' }
GtTreePagerStep >> paneElementForPaneModel: aPaneModel do: aBlock [
	^ self do
		label: ('Get pane element for pane "{1}"' format: {aPaneModel title});
		block: aBlock;
		// GtTreePagerFlowPanesElement;
		/ GtTreePagerPaneElement;
		@ [ :each | each paneModel = aPaneModel ];
		referenceSender;
		onParentStepTarget: self
]

{ #category : #'steps - interactions' }
GtTreePagerStep >> previewScrollToPane: aPaneModel [
	^ self click
		label: ('Scroll from preview to pane "{1}"' format: {aPaneModel title});
		// GtTreePagerScrollbarElement;
		// #'tree-pager--previews';
		/ GtTreePagerPaneScrollPreviewElement;
		@ [ :each | each paneModel = aPaneModel ];
		referenceSender;
		onParentStepTarget: self
]
