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
		action: [ self updatePaneAndEdgeElements ]
]

{ #category : #'private - event handling' }
GtTreePagerFlowPanesElement >> onGtTreePagerModelColumnHeightChanged: anAnnouncement [
	self pagerModel settings = anAnnouncement settings ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ self updatePreviewsElementLayoutColumnHeight ]
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
		when: GtTreePagerLinkModelStateChanged
			send: #onGtTreePagerLinkModelStateChanged:
			to: self;
		when: GtTreePagerModelColumnHeightChanged
			send: #onGtTreePagerModelColumnHeightChanged:
			to: self
]

{ #category : #'api - pager model' }
GtTreePagerFlowPanesElement >> unsubscribeFromPagerModel [
	self pagerModel unsubscribe: self
]

{ #category : #'private - updating' }
GtTreePagerFlowPanesElement >> updateElement [
	self updatePreviewsElementLayoutColumnHeight.
	self updatePaneAndEdgeElements
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

{ #category : #'private - updating' }
GtTreePagerFlowPanesElement >> updatePreviewsElementLayoutColumnHeight [
	self layoutDo: [ :l | l rowCount: self pagerModel settings columnHeight ]
]
