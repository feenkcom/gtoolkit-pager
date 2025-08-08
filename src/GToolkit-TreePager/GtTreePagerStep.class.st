Class {
	#name : #GtTreePagerStep,
	#superclass : #BlDevScripterToolActionStep,
	#category : #'GToolkit-TreePager-Examples'
}

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

{ #category : #'steps - interactions' }
GtTreePagerStep >> clickDropdownCollapseMenuItem [
	^ self menuStep
		clickMenuItemWithId: #'tree-pager--menu-collapse';
		onMenuContainer;
		referenceSender
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
