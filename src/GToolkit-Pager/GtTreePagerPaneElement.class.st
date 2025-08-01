Class {
	#name : #GtTreePagerPaneElement,
	#superclass : #GtTreePagerPaneBasicElement,
	#instVars : [
		'contentElement',
		'followingsElement',
		'disappearElement',
		'maximizerAptitude',
		'contentContainer',
		'topLeftToolbarElement'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #accessing }
GtTreePagerPaneElement >> contentElement [
	^ contentElement
]

{ #category : #accessing }
GtTreePagerPaneElement >> contentElementDo: aBlock [
	aBlock value: contentElement
]

{ #category : #initialization }
GtTreePagerPaneElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #'focus requesting' }
GtTreePagerPaneElement >> focusTarget [
	^ contentElement
]

{ #category : #views }
GtTreePagerPaneElement >> gtNavigationContextFor: aView [
	<gtView>
	self navigationContext ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Navigation context';
		priority: 1.5;
		object: [ self navigationContext ];
		view: #gtNavigationContextsFor:
]

{ #category : #'api - updating' }
GtTreePagerPaneElement >> hideDisappearElement [
	^ disappearElement visibility: BlVisibility gone
]

{ #category : #'api - updating' }
GtTreePagerPaneElement >> hideMaximizeButton [
	maximizerAptitude hideMaximizeButton
]

{ #category : #'api - updating' }
GtTreePagerPaneElement >> hideTopLeftToolbarElement [
	^ topLeftToolbarElement visibility: BlVisibility gone
]

{ #category : #'accessing - ui' }
GtTreePagerPaneElement >> incomingLinkElements [
	^ followingsElement incomingLinkElements
]

{ #category : #initialization }
GtTreePagerPaneElement >> initialize [
	super initialize.
	self matchParent.
	self clipChildren: false.
	
	self initializeContentElement.
	self initializeContentContainerElement.
	self initializeFollowingsElement.
	self addChild: contentContainer.
	self addChild: followingsElement.
	
	self updateDisappearElementToCollapseIcon.
	
	self initializeEventHandlers.
	self
		addAptitude: (BrLayoutResizerAptitude new
				inherit: contentContainer;
				vInherit: followingsElement).
	
	self states addState: GtPhlowToolDetailState normal
]

{ #category : #initialization }
GtTreePagerPaneElement >> initializeContentContainerElement [
	contentContainer := BrHorizontalPane new
			id: #container;
			clipChildren: false;
			margin: (BlInsets left: 9);
			matchParent;
			addChild: contentElement;
			addChild: (topLeftToolbarElement := BrHorizontalPane new
						fitContent;
						padding: (BlInsets left: 10);
						addChild: self newDropdownMenuElement;
						clipChildren: false;
						constraintsDo: [ :c | 
							c ignoreByLayout.
							c ignored horizontal alignLeft.
							c ignored vertical alignCenterAt: 0 ]);
			addChild: (disappearElement := self newDisappearElement);
			addAptitude: (maximizerAptitude := BrGlamorousWithMaximizerAptitude new
						/ GtTreePagerPaneContentElement;
						preferredBackground: self theme default backdropBackground);
			addAptitude: (BrLayoutResizerAptitude new
					hMatchParentToMatchParent: contentElement;
					vInherit: contentElement)
]

{ #category : #initialization }
GtTreePagerPaneElement >> initializeContentElement [
	contentElement := GtTreePagerPaneContentElement new
			addAptitude: BrGlamorousFocusableShadowAptitude new;
			when: BrMaximizerElementMinimized
				do: [ :anEvent | 
					anEvent currentTarget
						realToolElementDo: [ :aToolElement | 
							aToolElement userData
								at: #previousToolDetailPositionState
								ifPresent: [ :aState | 
									aToolElement states addState: aState.
									aToolElement userData removeKey: #previousToolDetailPositionState ]
								ifAbsent: [  ].
							aToolElement userData
								at: #previousToolDetailState
								ifPresent: [ :aState | 
									aToolElement states addState: aState.
									aToolElement userData removeKey: #previousToolDetailState ]
								ifAbsent: [  ] ].
					anEvent currentTarget requestStyle ];
			when: BrMaximizerElementMaximized
				do: [ :anEvent | 
					anEvent currentTarget
						realToolElementDo: [ :aToolElement | 
							aToolElement states
								stateLike: GtPhlowToolDetailPositionState left
								ifFound: [ :aState | 
									aToolElement userData at: #previousToolDetailPositionState put: aState.
									aToolElement states removeState: aState ]
								ifNone: [  ].
							aToolElement states
								stateLike: GtPhlowToolDetailState normal
								ifFound: [ :aState | 
									aToolElement userData at: #previousToolDetailState put: aState.
									aToolElement states removeState: aState ]
								ifNone: [  ] ].
					anEvent currentTarget requestStyle ].
]

{ #category : #initialization }
GtTreePagerPaneElement >> initializeEventHandlers [
	self
		when: GtPhlowObjectToSelect
			do: [ :anEvent | self onGtPhlowObjectToSelect: anEvent ];
		when: GtPhlowObjectToDeselect
			do: [ :anEvent | self onGtPhlowObjectToDeselect: anEvent ];
		when: GtPhlowObjectToSpawn
			do: [ :anEvent | self onGtPhlowObjectToSpawn: anEvent ].

	self when: BlMouseMoveEvent do: [ :anEvent | self onMouseMoveEvent: anEvent ]
]

{ #category : #initialization }
GtTreePagerPaneElement >> initializeFollowingsElement [
	followingsElement := GtTreePagerPaneFollowingsElement new
			margin: (BlInsets left: 5)
]

{ #category : #'api - requests' }
GtTreePagerPaneElement >> maximize [
	maximizerAptitude dispatchEvent: BrWithMaximizerAptitudeMaximizeWish new
]

{ #category : #accessing }
GtTreePagerPaneElement >> navigationContext [
	<return: #GtTreePagerPaneNavigationContext>
	self contentElementDo: [ :aContentElement |
		^ aContentElement navigationContext ].
	^ nil
]

{ #category : #initialization }
GtTreePagerPaneElement >> newDisappearCollapseIcon [
	^ BlElement new
		size: 2 @ 10;
		background: Color gray
]

{ #category : #initialization }
GtTreePagerPaneElement >> newDisappearElement [
	^ GtInspectorRoundButtonStencil small asElement
		addAptitude: BrGlamorousButtonWithLabelTooltipAptitude2;
		id: GtPagerMaximizeButtonElementId;
		action: [ :aButton :aButtonModel :anEvent | self onDisappearClick: anEvent ];
		actionWithModifiers: [ :aButton :aButtonModel :anEvent | self onDisappearClick: anEvent ];
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c ignored horizontal alignCenterAt: 1.0.
			c ignored vertical alignCenterAt: 0.0 ]
]

{ #category : #initialization }
GtTreePagerPaneElement >> newDisappearRemoveIcon [
	^ BrPlusIconStencil close asElement
]

{ #category : #initialization }
GtTreePagerPaneElement >> newDropdownMenuElement [
	^ GtInspectorRoundButtonStencil small asElement
		id: #'gt-pager-dropdown-menu-button';
		icon: BrGlamorousVectorIcons downwards;
		addAptitude: (BrGlamorousWithExplicitDropdownAptitude
				handle: [ BrButton new
						size: 16 @ 16;
						background: Color white;
						aptitude: BrIconAptitude;
						geometry: BlEllipseGeometry new;
						layout: BlLinearLayout horizontal alignCenter;
						icon: BrGlamorousVectorIcons downwards ]
				menu: [ self newDropdownMenuModel ])
]

{ #category : #initialization }
GtTreePagerPaneElement >> newDropdownMenuModel [
	| aLinkModel |
	self hasPaneModel ifFalse: [ ^ nil ].
	aLinkModel := self paneModel previousLink.
	aLinkModel ifNil: [ ^ nil ].

	^ GtTreePagerLinkContextMenuBuilder new
		linkModel: aLinkModel;
		build
]

{ #category : #'private - event management' }
GtTreePagerPaneElement >> onDisappearClick: anEvent [
	anEvent consumed: true.
	self hasPaneModel ifFalse: [ ^ self ].
	self paneModel depthIndex = 1 ifTrue: [ ^ self ].

	anEvent modifiers isPrimaryModifier
		ifTrue: [ self paneModel removeFromPreviousPane.
			^ self ].

	self paneModel followingSpawnedPaneModels isEmpty
		ifFalse: [ self paneModel collapse ]
		ifTrue: [ self paneModel selectInPreviousPane ]
]

{ #category : #'private - event handling' }
GtTreePagerPaneElement >> onGtPhlowObjectToDeselect: anEvent [
	self paneModel ifNil: [ ^ self ].
	anEvent consumed: true.
	self paneModel removeLink
]

{ #category : #'private - event handling' }
GtTreePagerPaneElement >> onGtPhlowObjectToSelect: anEvent [
	| aSelectedPane |
	self paneModel ifNil: [ ^ self ].
	anEvent consumed: true.
	aSelectedPane := GtTreePagerPaneModel new phlowTool: anEvent tool.
	self paneModel selectPane: aSelectedPane.

	aSelectedPane isSpawned ifFalse: [ ^ self ].
	BlTaskAction
		enqueueElement: self
		action: [ self
				fireEvent: (GtTreePagerScrollToColumnWish new column: self paneModel depthIndex) ]
]

{ #category : #'private - event handling' }
GtTreePagerPaneElement >> onGtPhlowObjectToSpawn: anEvent [
	| aSpawnedPane |
	self paneModel ifNil: [ ^ self ].
	anEvent consumed: true.
	aSpawnedPane := GtTreePagerPaneModel new
			phlowTool: anEvent tool;
			expand.
	self paneModel spawnPane: aSpawnedPane.

	BlTaskAction
		enqueueElement: self
		action: [ self
				fireEvent: (GtTreePagerScrollToColumnWish new column: self paneModel depthIndex) ]
]

{ #category : #'private - event handling' }
GtTreePagerPaneElement >> onGtTreePagerLinkModelStateChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateDisappearElement ]
]

{ #category : #'private - event handling' }
GtTreePagerPaneElement >> onGtTreePagerPaneModelFollowingPanesChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateDisappearElement ]
]

{ #category : #initialization }
GtTreePagerPaneElement >> onMouseMoveEvent: anEvent [
	anEvent consumed: true.
	^ anEvent modifiers isPrimaryModifier
		ifTrue: [ self updateDisappearElementToRemoveIcon ]
		ifFalse: [ self updateDisappearElementToCollapseIcon ]
]

{ #category : #accessing }
GtTreePagerPaneElement >> onPaneModelChanged [
	super onPaneModelChanged.
	contentElement paneModel: self paneModel.
	followingsElement paneModel: self paneModel.
	
	self updateElement.
]

{ #category : #'accessing - ui' }
GtTreePagerPaneElement >> outgoingLinkElements [
	^ followingsElement outgoingLinkElements
]

{ #category : #accessing }
GtTreePagerPaneElement >> realToolElementDo: aBlock [
	self contentElementDo: [ :aContentElement | 
		aContentElement realToolElementDo: aBlock ]
]

{ #category : #'api - updating' }
GtTreePagerPaneElement >> showDisappearElement [
	self hasPaneModel ifFalse: [ ^ self ].
	self paneModel depthIndex = 1 ifTrue: [ ^ self ].
	
	disappearElement visibility: BlVisibility visible
]

{ #category : #'api - updating' }
GtTreePagerPaneElement >> showMaximizeButton [
	maximizerAptitude showMaximizeButton
]

{ #category : #'api - updating' }
GtTreePagerPaneElement >> showTopLeftToolbarElement [
	^ topLeftToolbarElement visibility: BlVisibility visible
]

{ #category : #'api - pane model' }
GtTreePagerPaneElement >> subscribeToPaneModel [
	super subscribeToPaneModel.

	self paneModel announcer weak
		when: GtTreePagerPaneModelFollowingLinksChanged
			send: #onGtTreePagerPaneModelFollowingPanesChanged:
			to: self;
		when: GtTreePagerLinkModelStateChanged
			send: #onGtTreePagerLinkModelStateChanged:
			to: self
]

{ #category : #accessing }
GtTreePagerPaneElement >> toolElement [
	^ contentElement toolElement
]

{ #category : #accessing }
GtTreePagerPaneElement >> toolElementDo: aBlock [
	self toolElement ifNotNil: aBlock
]

{ #category : #'api - pane model' }
GtTreePagerPaneElement >> unsubscribeFromPaneModel [
	super unsubscribeFromPaneModel.

	self paneModel announcer unsubscribe: self
]

{ #category : #'private - updating' }
GtTreePagerPaneElement >> updateDisappearElement [
	self paneModel depthIndex = 1 ifTrue: [ self hideDisappearElement ]
]

{ #category : #'private - updating' }
GtTreePagerPaneElement >> updateDisappearElementToCollapseIcon [
	disappearElement userData
		at: #gtTreePagerIsCollapseIcon
		ifPresent: [ :aBoolean | aBoolean ifTrue: [ ^ self ] ]
		ifAbsent: [  ].

	disappearElement userData at: #gtTreePagerIsCollapseIcon put: true.

	^ disappearElement
		icon: self newDisappearCollapseIcon;
		label: 'Collapse pane'
]

{ #category : #'private - updating' }
GtTreePagerPaneElement >> updateDisappearElementToRemoveIcon [
	disappearElement userData
		at: #gtTreePagerIsCollapseIcon
		ifPresent: [ :aBoolean | aBoolean ifFalse: [ ^ self ] ]
		ifAbsent: [  ].

	disappearElement userData at: #gtTreePagerIsCollapseIcon put: false.

	^ disappearElement
		icon: self newDisappearRemoveIcon;
		label: 'Remove pane'
]

{ #category : #'private - updating' }
GtTreePagerPaneElement >> updateElement [
	self updateDisappearElement

]
