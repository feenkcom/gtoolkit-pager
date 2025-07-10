Class {
	#name : #GtTreePagerFlowPanesElement,
	#superclass : #GtTreePagerBasicElement,
	#category : #'GToolkit-Pager-Tree Pager'
}

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
		cellSpacing: 20
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
GtTreePagerFlowPanesElement >> newNodeElementForPaneModel: aPaneModel [
	^ GtTreePagerPaneElement new
		in: [ :theElement | 
			theElement graph
				beNode;
				model: aPaneModel ];
		paneModel: aPaneModel
]

{ #category : #'private - event handling' }
GtTreePagerFlowPanesElement >> onGtTreePagerLinkModelStateChanged: anAnnouncement [
	anAnnouncement linkModel topPreviousPane = self pagerModel ifFalse: [ ^ self ].

	BlTaskAction
		enqueueElement: self
		action: [ self updateElement ]
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

{ #category : #'api - scrolling' }
GtTreePagerFlowPanesElement >> scrollToColumn: aColumn [
	self
		layoutDo: [ :l | 
			l
				firstVisibleColumn: aColumn;
				horizontalOffset: 0 ]
]

{ #category : #'api - pager model' }
GtTreePagerFlowPanesElement >> subscribeToPagerModel [
	self pagerModel announcer weak
		when: GtTreePagerPaneModelFollowingLinksChanged
			send: #onGtTreePagerPaneModelFollowingPanesChanged:
			to: self;
		when: GtTreePagerPaneModelExpansionChanged
			send: #onGtTreePagerPaneModelExpansionChanged:
			to: self;
		when: GtTreePagerLinkModelStateChanged
			send: #onGtTreePagerLinkModelStateChanged:
			to: self
]

{ #category : #'api - pager model' }
GtTreePagerFlowPanesElement >> unsubscribeFromPagerModel [
	self pagerModel unsubscribe: self
]

{ #category : #'private - updating' }
GtTreePagerFlowPanesElement >> updateElement [
	| displayedElements |
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

	GtTreePagerPanesEdgesUpdater new
		panesElement: self;
		update.

	(self children difference: displayedElements) do: #removeFromParent
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
							and: [ (allRemovedPanes includes: eachChild graph model value)
									or: [ allRemovedPanes includes: eachChild graph model key ] ])
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
						(eachChild graph isEdge
							and: [ eachChild graph model value = aPaneModel
									or: [ eachChild graph model key = aPaneModel ] ])
							ifTrue: [ aStream nextPut: eachChild ] ].

				aPaneModel isCollapsed
					ifTrue: [ self
							childNodeForPaneModel: aPaneModel
							ifFound: [ :anElement | aStream nextPut: anElement ]
							ifNone: [  ] ] ].

	toRemoveElements do: [ :eachChild | eachChild removeFromParent ].

	self updateElement
]
