Class {
	#name : #GtTreePagerScrollbarElement,
	#superclass : #GtTreePagerBasicElement,
	#instVars : [
		'scrollbarElement',
		'previewsElement',
		'panesElement'
	],
	#category : #'GToolkit-TreePager-UI'
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
	| rootContainer previewContainer configurationElement |
	super initialize.
	self hMatchParent.
	self vFitContent.

	previewsElement := BlElement new.
	previewsElement
		id: #'tree-pager--previews';
		clipChildren: false;
		layout: (BlHorizontalTreeFlowLayout new
				numberOfVisibleColumns: 2;
				firstVisibleColumn: 1;
				horizontalOffset: 0;
				cellSpacing: 2);
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical exact: GtTreePagerConstants previewHeight ].

	scrollbarElement := BlHorizontalScrollbarElement new
			disableClickToScroll;
			beAlwaysVisible;
			constraintsDo: [ :c | c vertical exact: GtTreePagerConstants previewScrollbar ];
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
			addChild: previewsElement;
			addChild: scrollbarElement.

	configurationElement := self newConfigurationElement.

	rootContainer := BrHorizontalPane new
			margin: (BlInsets top: 5);
			alignCenter;
			hMatchParent;
			vFitContent;
			addChild: previewContainer;
			addChild: configurationElement.

	self addChild: rootContainer
]

{ #category : #initialization }
GtTreePagerScrollbarElement >> newConfigurationElement [
	^ BrButton new
		id: #'tree-pager--configuration-menu-button';
		fitContent;
		aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonExteriorAptitude;
		icon: (BrGlamorousVectorIcons hamburger asElement
				background: self theme button fadedBackgroundColor);
		label: 'Pager configuration';
		constraintsDo: [ :c | 
			c margin: (BlInsets right: 10).
			c ignoreByLayout.
			c ignored vertical alignCenter.
			c ignored horizontal alignRight ];
		addAptitude: (BrGlamorousWithExplicitDropdownAptitude new
				withGainFocusOnShow;
				handle: [ BrButton new
							id: #'tree-pager--configuration-menu-handle';
							fitContent;
							aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonWithLabelTooltipAptitude2
									- BrGlamorousButtonExteriorAptitude;
							icon: (BrGlamorousVectorIcons hamburger asElement
									background: self theme button fadedBackgroundColor);
							label: 'Pager configuration';
							yourself ]
					submenu: [ self newConfigurationMenu ])
]

{ #category : #initialization }
GtTreePagerScrollbarElement >> newConfigurationMenu [
	| aMenuItems aMenuItem |
	self hasPagerModel ifFalse: [ ^ nil ].

	aMenuItems := BrMenuItems new.

	aMenuItem := BrMenuActionItem new.
	aMenuItem id: #'tree-pager--column-height'.
	aMenuItem
		icon: [ GtTreePagerColumnHeightElementBuilder new
				columnHeight: self pagerModel settings columnHeight;
				icon ]
		label: [ GtTreePagerColumnHeightElementBuilder new
				columnHeight: self pagerModel settings columnHeight;
				label ]
		preview: [ GtTreePagerColumnHeightElementBuilder new
				columnHeight: self pagerModel settings columnHeight;
				preview ].
	aMenuItem action: [ :aButton | self onChangeColumnHeightSettingsFrom: aButton ].
	aMenuItem hideOnClick: false.
	aMenuItem
		updateWhen: GtTreePagerModelColumnHeightChanged
		from: self pagerModel announcer.
	aMenuItems addItem: aMenuItem.

	aMenuItem := BrMenuExplicitItem new.
	aMenuItem id: #'tree-pager--visible-columns'.
	aMenuItem
		stencil: [ BlElement new
				layout: BlLinearLayout horizontal;
				viewModel: BrWidgetModel new;
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical fitContent ];
				addChild: (BlElement new size: 20 @ 3);
				addChild: (BrLabel new
						hFitContentLimited;
						id: #'tree-pager--visible-columns-decrease';
						text: 'Number of visible columns';
						aptitude: BrGlamorousLabelAptitude new;
						constraintsDo: [ :c | 
							c linear horizontal alignLeft.
							c linear vertical alignCenter ]);
				addChild: (BrButton new
						aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonExteriorAptitude;
						icon: BrGlamorousVectorIcons remove;
						label: 'Decrease number of columns';
						action: [ :aButton | self onDecreaseNumberOfVisibleColumnsSettingsFrom: aButton ];
						constraintsDo: [ :c | 
							c linear horizontal alignLeft.
							c linear vertical alignCenter ]);
				addChild: (BrLabel new
						id: #'tree-pager--visible-columns-value';
						text: self pagerModel settings numberOfVisibleColumns asString;
						aptitude: BrGlamorousLabelAptitude new;
						constraintsDo: [ :c | 
							c linear horizontal alignLeft.
							c linear vertical alignCenter ]);
				addChild: (BrButton new
						id: #'tree-pager--visible-columns-increase';
						aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonExteriorAptitude;
						icon: BrGlamorousVectorIcons add;
						label: 'Increase number of columns';
						action: [ :aButton | self onIncreaseNumberOfVisibleColumnsSettingsFrom: aButton ];
						constraintsDo: [ :c | 
							c linear horizontal alignLeft.
							c linear vertical alignCenter ]);
				when: BrPopoverUpdateWish
					do: [ :anEvent | 
						(anEvent currentTarget childWithId: #'tree-pager--visible-columns-value')
							text: self pagerModel settings numberOfVisibleColumns asString ] ].

	aMenuItem
		updateWhen: GtTreePagerModelNumberOfVisibleColumnsChanged
		from: self pagerModel announcer.
	aMenuItems addItem: aMenuItem.

	^ aMenuItems
]

{ #category : #'private - updating' }
GtTreePagerScrollbarElement >> newContextMenuFor: aPaneModel [
	| aLinkModel |
	aLinkModel := aPaneModel previousLink.
	aLinkModel ifNil: [ ^ nil ].

	^ GtTreePagerPanePreviewContextMenuBuilder new
		linkModel: aLinkModel;
		build
]

{ #category : #'private - updating' }
GtTreePagerScrollbarElement >> newPreviewElementForPaneModel: aPaneModel paneElement: aPaneElement [
	^ GtTreePagerPaneScrollPreviewElement new
		paneModel: aPaneModel;
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
]

{ #category : #'private - event handling' }
GtTreePagerScrollbarElement >> onDecreaseNumberOfVisibleColumnsSettingsFrom: aButton [
	self pagerModel settings decreaseNumberOfVisibleColumns
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
		action: [ self updateElementLayoutColumnHeight ]
]

{ #category : #'private - event handling' }
GtTreePagerScrollbarElement >> onGtTreePagerPaneModelFollowingPanesChanged: anAnnouncement [
	anAnnouncement paneModel topPreviousPane = self pagerModel ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ self updatePreviewsElement ]
]

{ #category : #'private - event handling' }
GtTreePagerScrollbarElement >> onIncreaseNumberOfVisibleColumnsSettingsFrom: aButton [
	self pagerModel settings increaseNumberOfVisibleColumns
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
		do: [ :anEvent | self onGtTreePagerFlowPaneElementsChanged: anEvent ].
	scrollbarElement attachTo: aPanesElement
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
GtTreePagerScrollbarElement >> updateElement [
	self updateElementLayoutColumnHeight.
	self updatePreviewsElement
]

{ #category : #'private - updating' }
GtTreePagerScrollbarElement >> updateElementLayoutColumnHeight [
	previewsElement layoutDo: [ :l | l rowCount: self pagerModel settings columnHeight ]
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
