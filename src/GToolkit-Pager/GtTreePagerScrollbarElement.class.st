Class {
	#name : #GtTreePagerScrollbarElement,
	#superclass : #GtTreePagerBasicElement,
	#instVars : [
		'scrollbarElement',
		'pageModelsAndElements',
		'panesElement'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'api - children enumeration' }
GtTreePagerScrollbarElement >> childNodeForPaneModel: aPaneModel ifFound: aFoundBlock ifNone: aNoneBlock [
	^ panesElement children
		detect: [ :eachElement | eachElement graph isNode and: [ eachElement paneModel = aPaneModel ] ]
		ifFound: aFoundBlock
		ifNone: aNoneBlock
]

{ #category : #initialization }
GtTreePagerScrollbarElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #'private - updating' }
GtTreePagerScrollbarElement >> ensureNodeForPaneModel: aPaneModel row: aRowIndex depth: aDepthIndex span: aSpanIndex [
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

	anElement hasParent ifFalse: [ panesElement addChild: anElement ].
	
	^ anElement
]

{ #category : #initialization }
GtTreePagerScrollbarElement >> initialize [
	| containerElement wrapperElement |
	super initialize.
	self hMatchParent.
	self vFitContent.

	pageModelsAndElements := OrderedCollection new.

	panesElement := BlElement new.
	panesElement
		layout: (BlHorizontalTreeFlowLayout new
				numberOfVisibleColumns: 20;
				firstVisibleColumn: 1;
				horizontalOffset: 0;
				cellSpacing: 2);
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical exact: 20 ].

	scrollbarElement := BlHorizontalScrollbarElement new
			disableClickToScroll;
			beAlwaysVisible;
			constraintsDo: [ :c | c vertical exact: 6 ];
			track: (BlElement new size: 0 @ 0);
			thumb: (BlElement new
					geometry: BlStadiumGeometry new beHorizontal;
					constraintsDo: [ :c | 
						c horizontal matchParent.
						c vertical matchParent.
						c frame horizontal weight: 0.25.
						c frame vertical alignCenter ];
					aptitude: BrGlamorousFadedButtonExteriourAptitude).

	wrapperElement := BrVerticalPane new
			fitContent;
			addChild: panesElement;
			addChild: scrollbarElement.

	containerElement := BrHorizontalPane new
			margin: (BlInsets top: 5);
			alignCenter;
			hMatchParent;
			vFitContent;
			addChild: wrapperElement.

	self addChild: containerElement
]

{ #category : #'private - updating' }
GtTreePagerScrollbarElement >> newContextMenuFor: aPaneModel [
	| aLinkModel |
	aLinkModel := aPaneModel previousLink.
	aLinkModel ifNil: [ ^ nil ].

	^ GtTreePagerLinkContextMenuBuilder new
		linkModel: aLinkModel;
		build
]

{ #category : #'private - updating' }
GtTreePagerScrollbarElement >> newNodeElementForPaneModel: aPaneModel [
	^ GtTreePagerPaneScrollPreviewElement new
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

{ #category : #'private - event handling' }
GtTreePagerScrollbarElement >> onGtTreePagerLinkModelStateChanged: anAnnouncement [
	anAnnouncement linkModel topPreviousPane = self pagerModel ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'private - event handling' }
GtTreePagerScrollbarElement >> onGtTreePagerPaneModelFollowingPanesChanged: anAnnouncement [
	anAnnouncement paneModel topPreviousPane = self pagerModel ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'api - pager model' }
GtTreePagerScrollbarElement >> onPagerModelChanged [
	super onPagerModelChanged.
	self updateElement
]

{ #category : #'private - event handling' }
GtTreePagerScrollbarElement >> onPaneElementClick: anEvent [
	anEvent consumed: true.

	self
		fireEvent: (GtTreePagerScrollToColumnWish new
				column: anEvent currentTarget constraints horizontalTreeFlow depth)
]

{ #category : #'api - pager model' }
GtTreePagerScrollbarElement >> subscribeToPagerModel [
	self pagerModel announcer weak
		when: GtTreePagerPaneModelFollowingLinksChanged
			send: #onGtTreePagerPaneModelFollowingPanesChanged:
			to: self;
		when: GtTreePagerLinkModelStateChanged
			send: #onGtTreePagerLinkModelStateChanged:
			to: self
]

{ #category : #'api - pager model' }
GtTreePagerScrollbarElement >> unsubscribeFromPagerModel [
	self pagerModel unsubscribe: self
]

{ #category : #'private - updating' }
GtTreePagerScrollbarElement >> updateElement [
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

	(panesElement children difference: displayedElements) do: #removeFromParent
]
