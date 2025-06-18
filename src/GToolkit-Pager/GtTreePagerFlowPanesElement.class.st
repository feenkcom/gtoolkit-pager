Class {
	#name : #GtTreePagerFlowPanesElement,
	#superclass : #GtTreePagerBasicElement,
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'api - children enumeration' }
GtTreePagerFlowPanesElement >> childForPaneModel: aPaneModel ifFound: aFoundBlock ifNone: aNoneBlock [
	^ self children
		detect: [ :eachElement | eachElement paneModel = aPaneModel ]
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
GtTreePagerFlowPanesElement >> ensureElementForPaneModel: aPaneModel row: aRowIndex depth: aDepthIndex [
	| anElement |
	aPaneModel isCollapsed
		ifTrue: [ ^ self ensureRemoveElementForPaneModel: aPaneModel ].

	anElement := self
			childForPaneModel: aPaneModel
			ifFound: [ :theElement | theElement ]
			ifNone: [ self newPaneElementForPaneModel: aPaneModel ].

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
		childForPaneModel: aPaneModel
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
GtTreePagerFlowPanesElement >> newPaneElementForPaneModel: aPaneModel [
	^ GtTreePagerPaneElement new paneModel: aPaneModel
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
				ensureElementForPaneModel: aPaneModel
				row: aRowIndex
				depth: aDepthIndex ];
		build
]

{ #category : #'private - updating' }
GtTreePagerFlowPanesElement >> updateElementDueTo: aPaneModel addedFollowingPanes: addedFollowingPanes removedFollowingPanes: removedFollowingPanes [
	| allRemovedPanes |
	allRemovedPanes := removedFollowingPanes
			flatCollect: [ :eachPane | eachPane withAllFollowingPanes ].

	allRemovedPanes
		do: [ :eachPaneModel | 
			self
				childForPaneModel: eachPaneModel
				ifFound: [ :anElement | anElement removeFromParent ]
				ifNone: [  ] ].

	self updateElement
]
