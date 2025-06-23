Class {
	#name : #GtTreePagerFlowPanesElement,
	#superclass : #GtTreePagerBasicElement,
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'api - children enumeration' }
GtTreePagerFlowPanesElement >> childEdgeFromPaneModel: aFromPaneModel toPaneModel: aToPaneModel ifFound: aFoundBlock ifNone: aNoneBlock [
	^ self children
		detect: [ :eachElement | 
			eachElement graph isEdge
				and: [ | anAssoc |
					anAssoc := eachElement graph model.
					anAssoc key = aFromPaneModel and: [ anAssoc value = aToPaneModel ] ] ]
		ifFound: aFoundBlock
		ifNone: aNoneBlock
]

{ #category : #'api - children enumeration' }
GtTreePagerFlowPanesElement >> childNodeForPaneModel: aPaneModel ifFound: aFoundBlock ifNone: aNoneBlock [
	^ self children
		detect: [ :eachElement | eachElement graph isNode and: [ eachElement paneModel = aPaneModel ] ]
		ifFound: aFoundBlock
		ifNone: aNoneBlock
]

{ #category : #initialization }
GtTreePagerFlowPanesElement >> defaultLayout [
	^ BlHorizontalTreeFlowLayout new
		numberOfVisibleColumns: 2;
		firstVisibleColumn: 1;
		horizontalOffset: 0;
		cellSpacing: 10
]

{ #category : #'private - updating' }
GtTreePagerFlowPanesElement >> ensureEdgeFromPaneModel: aFromPaneModel toPaneModel: aToPaneModel [
	| anElement |
	anElement := self
			childEdgeFromPaneModel: aFromPaneModel
			toPaneModel: aToPaneModel
			ifFound: [ :aLineElement | aLineElement ]
			ifNone: [ self
					newEdgeElementFromPaneModel: aFromPaneModel
					toPaneModel: aToPaneModel ].

	anElement hasParent ifFalse: [ self addChild: anElement ]
]

{ #category : #'private - updating' }
GtTreePagerFlowPanesElement >> ensureNodeForPaneModel: aPaneModel row: aRowIndex depth: aDepthIndex [
	| anElement |
	aPaneModel isCollapsed
		ifTrue: [ ^ self ensureRemoveElementForPaneModel: aPaneModel ].

	anElement := self
			childNodeForPaneModel: aPaneModel
			ifFound: [ :theElement | theElement ]
			ifNone: [ self newNodeElementForPaneModel: aPaneModel ].

	anElement
		constraintsDo: [ :c | 
			c horizontalTreeFlow
				row: aRowIndex;
				depth: aDepthIndex ].

	anElement hasParent ifFalse: [ self addChild: anElement ]
]

{ #category : #'private - updating' }
GtTreePagerFlowPanesElement >> ensureRemoveElementForPaneModel: aPaneModel [
	self
		childNodeForPaneModel: aPaneModel
		ifFound: [ :anElement | anElement removeFromParent ]
		ifNone: [  "ignore" ]
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
GtTreePagerFlowPanesElement >> newEdgeElementFromPaneModel: aFromPaneModel toPaneModel: aToPaneModel [
	| aFromElement aToElement aFromTriangleQuery aFromTriangleElement |
	aFromElement := self
			childNodeForPaneModel: aFromPaneModel
			ifFound: [ :anElement | anElement ]
			ifNone: [ NotFound signalFor: aFromPaneModel in: self children ].

	aToElement := self
			childNodeForPaneModel: aToPaneModel
			ifFound: [ :anElement | anElement ]
			ifNone: [ NotFound signalFor: aToPaneModel in: self children ].

	aFromTriangleQuery := (aFromElement query
			// GtTreePagerPaneFollowingExpandedElement)
			@ [ :each | each paneModel = aToPaneModel ].
	aFromTriangleQuery result
		ifEmpty: [ NotFound signalFor: aToPaneModel in: aFromTriangleQuery ].
	aFromTriangleElement := aFromTriangleQuery result anyOne.

	^ BlManhattanLineElement new
		in: [ :theElement | 
			theElement graph
				beEdge;
				model: aFromPaneModel -> aToPaneModel ];
		zIndex: -1;
		border: (BlBorder paint: self theme button fadedBackgroundColor);
		beFixedTo;
		fixedDistance: 10;
		cornerRadius: 10;
		fromAnchor: (BlElementCenterRightAnchor element: aFromTriangleElement);
		toAnchor: (BlElementCenterLeftAnchor element: aToElement)
]

{ #category : #'private - updating' }
GtTreePagerFlowPanesElement >> newNodeElementForPaneModel: aPaneModel [
	^ GtTreePagerPaneElement new
		in: [ :theElement | 
			theElement graph
				beNode;
				model: aPaneModel ];
		paneModel: aPaneModel
]

{ #category : #'private - event handling' }
GtTreePagerFlowPanesElement >> onGtTreePagerPaneModelExpansionChanged: anAnnouncement [
	anAnnouncement paneModel topPreviousPane = self pagerModel ifFalse: [ ^ self ].

	BlTaskAction
		enqueueElement: self
		action: [ self updateElementDueToExpansionChange: anAnnouncement paneModel ]
]

{ #category : #'private - event handling' }
GtTreePagerFlowPanesElement >> onGtTreePagerPaneModelFollowingPanesChanged: anAnnouncement [
	anAnnouncement paneModel topPreviousPane = self pagerModel ifFalse: [ ^ self ].

	BlTaskAction
		enqueueElement: self
		action: [ self
				updateElementDueTo: anAnnouncement paneModel
				addedFollowingPanes: anAnnouncement addedFollowingPanes
				removedFollowingPanes: anAnnouncement removedFollowingPanes ]
]

{ #category : #'api - pager model' }
GtTreePagerFlowPanesElement >> onPagerModelChanged [
	super onPagerModelChanged.
	self updateElement
]

{ #category : #'api - pager model' }
GtTreePagerFlowPanesElement >> subscribeToPagerModel [
	self pagerModel announcer weak
		when: GtTreePagerPaneModelFollowingPanesChanged
			send: #onGtTreePagerPaneModelFollowingPanesChanged:
			to: self;
		when: GtTreePagerPaneModelExpansionChanged
			send: #onGtTreePagerPaneModelExpansionChanged:
			to: self
]

{ #category : #'api - pager model' }
GtTreePagerFlowPanesElement >> unsubscribeFromPagerModel [
	self pagerModel unsubscribe: self
]

{ #category : #'private - updating' }
GtTreePagerFlowPanesElement >> updateElement [
	GtTreePagerHorizontalTreeFlowBuilder new
		paneModels: self pagerModel paneModels;
		forEachPaneModelDo: [ :aPaneModel :aRowIndex :aDepthIndex | 
			self
				ensureNodeForPaneModel: aPaneModel
				row: aRowIndex
				depth: aDepthIndex ];
		build.

	self pagerModel
		allPanesBreadthFirstDo: [ :eachFromPane | 
			eachFromPane isCollapsed
				ifFalse: [ eachFromPane followingExpandedPaneModels
						do: [ :eachToPane | 
							eachToPane isCollapsed
								ifFalse: [ self ensureEdgeFromPaneModel: eachFromPane toPaneModel: eachToPane ] ] ] ]
]

{ #category : #'private - updating' }
GtTreePagerFlowPanesElement >> updateElementDueTo: aPaneModel addedFollowingPanes: addedFollowingPanes removedFollowingPanes: removedFollowingPanes [
	| allRemovedPanes toRemoveElements |
	allRemovedPanes := removedFollowingPanes
			flatCollect: [ :eachPane | eachPane withAllFollowingPanes ].

	toRemoveElements := Array
			streamContents: [ :aStream | 
				self
					childrenDo: [ :eachChild | 
						(eachChild graph isEdge
							and: [ allRemovedPanes includes: eachChild graph model value ])
							ifTrue: [ aStream nextPut: eachChild ] ].

				allRemovedPanes
					do: [ :eachPaneModel | 
						self
							childNodeForPaneModel: eachPaneModel
							ifFound: [ :anElement | aStream nextPut: anElement ]
							ifNone: [  ] ] ].

	toRemoveElements do: [ :eachChild | eachChild removeFromParent ].

	self updateElement
]

{ #category : #'private - updating' }
GtTreePagerFlowPanesElement >> updateElementDueToExpansionChange: aPaneModel [
	| toRemoveElements |
	toRemoveElements := Array
			streamContents: [ :aStream | 
				self
					childrenDo: [ :eachChild | 
						(eachChild graph isEdge and: [ eachChild graph model value = aPaneModel ])
							ifTrue: [ aStream nextPut: eachChild ] ].

				aPaneModel isCollapsed
					ifTrue: [ self
							childNodeForPaneModel: aPaneModel
							ifFound: [ :anElement | aStream nextPut: anElement ]
							ifNone: [  ] ] ].

	toRemoveElements do: [ :eachChild | eachChild removeFromParent ].

	self updateElement
]
