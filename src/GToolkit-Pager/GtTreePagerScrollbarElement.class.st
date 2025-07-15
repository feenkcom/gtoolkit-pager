Class {
	#name : #GtTreePagerScrollbarElement,
	#superclass : #GtTreePagerBasicElement,
	#traits : 'TBlHorizontalTreeFlowLayoutRowCountVisitor',
	#classTraits : 'TBlHorizontalTreeFlowLayoutRowCountVisitor classTrait',
	#instVars : [
		'scrollbarElement',
		'columnHeightElement',
		'previewsElement',
		'panesElement'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'api - children enumeration' }
GtTreePagerScrollbarElement >> childNodeForPaneModel: aPaneModel ifFound: aFoundBlock ifNone: aNoneBlock [
	^ previewsElement children
		detect: [ :eachElement | eachElement graph isNode and: [ eachElement paneModel = aPaneModel ] ]
		ifFound: aFoundBlock
		ifNone: aNoneBlock
]

{ #category : #initialization }
GtTreePagerScrollbarElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #'private - updating' }
GtTreePagerScrollbarElement >> ensurePreviewForPaneElement: aPaneElement [
	| aPreviewElement |
	aPreviewElement := self
			childNodeForPaneModel: aPaneElement paneModel
			ifFound: [ :theElement | theElement ]
			ifNone: [ self
					newPreviewElementForPaneModel: aPaneElement paneModel
					paneElement: aPaneElement ].

	aPreviewElement
		constraintsDo: [ :c | 
			| layoutConstraints |
			layoutConstraints := aPaneElement constraints horizontalTreeFlow.
			c horizontalTreeFlow
				row: layoutConstraints row;
				depth: layoutConstraints depth;
				span: layoutConstraints span ].

	aPaneElement
		removeEventHandlersSuchThat: [ :each | each isKindOf: GtTreePagerPanePreviewResizeListener ].
	aPaneElement
		removeEventHandlersSuchThat: [ :each | each isKindOf: GtTreePagerPanePreviewFocusListener ].
	aPaneElement
		addEventHandler: (GtTreePagerPanePreviewResizeListener new previewElement: aPreviewElement).
	aPaneElement
		addEventHandler: (GtTreePagerPanePreviewFocusListener new
				previewElement: aPreviewElement;
				scrollbarElement: self).

	aPreviewElement hasParent
		ifFalse: [ previewsElement addChild: aPreviewElement ].

	^ aPreviewElement
]

{ #category : #initialization }
GtTreePagerScrollbarElement >> initialize [
	| rootContainer previewContainer toolbarElement |
	super initialize.
	self hMatchParent.
	self vFitContent.

	previewsElement := BlElement new.
	previewsElement
		clipChildren: false;
		layout: (BlHorizontalTreeFlowLayout new
				numberOfVisibleColumns: 2;
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

	previewContainer := BrVerticalPane new
			fitContent;
			addChild: previewsElement";
			addChild: scrollbarElement".

	toolbarElement := BrToolbar new
			aptitude: (BrGlamorousToolbarAptitude new spacing: 5);
			fitContent;
			margin: (BlInsets left: 5 right: 5);
			constraintsDo: [ :c | 
				c ignoreByLayout.
				c ignored horizontal alignRight.
				c ignored vertical alignCenter ];
			addItem: (columnHeightElement := BrButton new
						beSmallSize;
						aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonExteriorAptitude;
						icon: self newFillRowHeightIcon;
						label: 'Use whole column height';
						action: [ :aButton | self onChangeColumnHeightSettingsFrom: aButton ]).

	rootContainer := BrHorizontalPane new
			margin: (BlInsets top: 5);
			alignCenter;
			hMatchParent;
			vFitContent;
			addChild: previewContainer;
			addChild: toolbarElement.

	self addChild: rootContainer
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

{ #category : #visiting }
GtTreePagerScrollbarElement >> newFillColumnHeightIcon [
	^ BrHorizontalPane new
		cellSpacing: 2;
		fitContent;
		alignTopLeft;
		addChild: (BlElement new
				size: 7 @ 14;
				background: self theme button fadedBackgroundColor);
		addChild: (BlElement new
				size: 7 @ 14;
				background: self theme button fadedBackgroundColor);
		in: [ :theIcon | 
			theIcon
				addAptitude: BrGlamorousFadedButtonExteriourAptitude new
						/ [ :each | (theIcon childAt: 1) == each ];
				addAptitude: BrGlamorousFadedButtonExteriourAptitude new
						/ [ :each | (theIcon childAt: 2) == each ] ];
		yourself
]

{ #category : #visiting }
GtTreePagerScrollbarElement >> newFillRowHeightIcon [
	^ BrHorizontalPane new
		cellSpacing: 2;
		fitContent;
		alignTopLeft;
		addChild: (BlElement new
				size: 7 @ 14;
				background: self theme button fadedBackgroundColor);
		addChild: (BlElement new
				size: 7 @ 7;
				background: self theme button fadedBackgroundColor);
		in: [ :theIcon | 
			theIcon
				addAptitude: BrGlamorousFadedButtonExteriourAptitude new
						/ [ :each | (theIcon childAt: 1) == each ];
				addAptitude: BrGlamorousFadedButtonExteriourAptitude new
						/ [ :each | (theIcon childAt: 2) == each ] ];
		yourself
]

{ #category : #'private - updating' }
GtTreePagerScrollbarElement >> newPreviewElementForPaneModel: aPaneModel paneElement: aPaneElement [
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
		when: BlClickEvent
			do: [ :anEvent | self onPaneElementClick: anEvent paneElement: aPaneElement ];
		addAptitude: (BrGlamorousWithExplicitTooltipAptitude new
				content: [ BrElementAsFormPreview
						forElement: aPaneElement contentElement
						preferredExtent: 400 @ 400 ];
				showDelay: 100 milliSeconds;
				hideDelay: 50 milliSeconds)
]

{ #category : #'private - event handling' }
GtTreePagerScrollbarElement >> onChangeColumnHeightSettingsFrom: aButton [
	self hasPagerModel ifFalse: [ ^ self ].
	
	GtTreePagerColumnHeightChanger new 
		settings: self pagerModel settings;
		change.
	
	self visitLayoutRowCount: self pagerModel settings columnHeight
]

{ #category : #'private - event handling' }
GtTreePagerScrollbarElement >> onGtTreePagerFlowPaneElementsChanged: anEvent [
	anEvent consumed: true.
	self updatePreviewsElement
]

{ #category : #'private - event handling' }
GtTreePagerScrollbarElement >> onGtTreePagerLinkModelStateChanged: anAnnouncement [
	anAnnouncement linkModel topPreviousPane = self pagerModel ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ self updatePreviewsElement ]
]

{ #category : #'private - event handling' }
GtTreePagerScrollbarElement >> onGtTreePagerModelColumnHeightChanged: anAnnouncement [
	self pagerModel settings = anAnnouncement settings ifFalse: [ ^ self ].

	BlTaskAction
		enqueueElement: self
		action: [ self updatePreviewsElementLayoutColumnHeight.
			self updateColumnHeightSettingsElement ]
]

{ #category : #'private - event handling' }
GtTreePagerScrollbarElement >> onGtTreePagerPaneModelFollowingPanesChanged: anAnnouncement [
	anAnnouncement paneModel topPreviousPane = self pagerModel ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ self updatePreviewsElement ]
]

{ #category : #'api - pager model' }
GtTreePagerScrollbarElement >> onPagerModelChanged [
	super onPagerModelChanged.
	self updateElement
]

{ #category : #'private - event handling' }
GtTreePagerScrollbarElement >> onPaneElementClick: anEvent paneElement: aPaneElement [
	| aFocusTarget |
	anEvent consumed: true.

	self
		fireEvent: (GtTreePagerScrollToColumnWish new
				column: anEvent currentTarget constraints horizontalTreeFlow depth).

	aFocusTarget := anEvent currentTarget userData
			at: #previousFocusedElement
			ifPresent: [ :aWeakReference | 
				(aWeakReference at: 1)
					ifNotNil: [ :aPreviouslyFocusedElement | 
						(aPreviouslyFocusedElement hasParent: aPaneElement)
							ifTrue: [ aPreviouslyFocusedElement ]
							ifFalse: [ aPaneElement ] ]
					ifNil: [ aPaneElement ] ]
			ifAbsent: [ aPaneElement ].

	aFocusTarget ifNotNil: #requestFocus
]

{ #category : #accessing }
GtTreePagerScrollbarElement >> panesElement [
	"Return panes element that have pane elements as its direct children."

	^ panesElement
]

{ #category : #accessing }
GtTreePagerScrollbarElement >> panesElement: aPanesElement [
	"Set panes element that have pane elements as its direct children."

	self assert: [ panesElement isNil ].
	self assert: [ aPanesElement isNotNil ].

	panesElement := aPanesElement.

	aPanesElement
		when: GtTreePagerFlowPaneElementsChanged
		do: [ :anEvent | self onGtTreePagerFlowPaneElementsChanged: anEvent ]
]

{ #category : #'api - selection' }
GtTreePagerScrollbarElement >> selectPreviewElement: aPreviewElement [
	previewsElement children
		do: [ :eachPreview | eachPreview dispatchEvent: (BlElementSelectedStateWish selected: false) ].

	aPreviewElement dispatchEvent: (BlElementSelectedStateWish selected: true)
]

{ #category : #'api - pager model' }
GtTreePagerScrollbarElement >> subscribeToPagerModel [
	"It is not necessary to subscribe for spanwned pane changes,
	since we listen to panesElement changes and take the values from there."

	super subscribeToPagerModel.

	self pagerModel announcer weak
		when: GtTreePagerModelColumnHeightChanged
		send: #onGtTreePagerModelColumnHeightChanged:
		to: self
]

{ #category : #'api - pager model' }
GtTreePagerScrollbarElement >> unsubscribeFromPagerModel [
	super unsubscribeFromPagerModel.

	self pagerModel unsubscribe: self
]

{ #category : #'private - updating' }
GtTreePagerScrollbarElement >> updateColumnHeightSettingsElement [
	self visitLayoutRowCount: self pagerModel settings columnHeight
]

{ #category : #'private - updating' }
GtTreePagerScrollbarElement >> updateElement [
	self updateColumnHeightSettingsElement.
	self updatePreviewsElementLayoutColumnHeight.
	self updatePreviewsElement
]

{ #category : #'private - updating' }
GtTreePagerScrollbarElement >> updatePreviewsElement [
	| displayedElements paneElements maxDepth |
	displayedElements := OrderedCollection new.

	paneElements := panesElement children
			select: [ :eachChild | eachChild graph isNode ].

	paneElements
		do: [ :eachPaneElement | displayedElements add: (self ensurePreviewForPaneElement: eachPaneElement) ].

	maxDepth := 1.
	paneElements
		do: [ :eachPaneElement | eachPaneElement constraints horizontalTreeFlow depth max: maxDepth ].

	(previewsElement children difference: displayedElements) do: #removeFromParent.

	previewsElement layoutDo: [ :l | l numberOfVisibleColumns: maxDepth ]
]

{ #category : #'private - updating' }
GtTreePagerScrollbarElement >> updatePreviewsElementLayoutColumnHeight [
	previewsElement layoutDo: [ :l | l rowCount: self pagerModel settings columnHeight ]
]

{ #category : #visiting }
GtTreePagerScrollbarElement >> visitBlHorizontalTreeFlowLayoutCellCount: aCount [
	columnHeightElement
		label: 'Click to fill row height (instead of column height)';
		icon: self newFillColumnHeightIcon
]

{ #category : #visiting }
GtTreePagerScrollbarElement >> visitBlHorizontalTreeFlowLayoutRowGrowingCount: aCount [
	columnHeightElement
		label: 'Click to fill column height (instead of row height)';
		icon: self newFillRowHeightIcon
]
