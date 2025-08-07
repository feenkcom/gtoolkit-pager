Class {
	#name : #GtTreePagerPaneElement,
	#superclass : #GtTreePagerPaneBasicElement,
	#instVars : [
		'contentElement',
		'followingsElement',
		'maximizerAptitude',
		'contentContainer',
		'dropdownElement',
		'keysEventHandler'
	],
	#category : #'GToolkit-TreePager-UI'
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
GtTreePagerPaneElement >> hideDropdownElement [
	dropdownElement ifNotNil: [ :anElement | anElement visibility: BlVisibility gone ].
]

{ #category : #deprecated }
GtTreePagerPaneElement >> hideMaximizeButton [
	maximizerAptitude hideMaximizeButton
]

{ #category : #deprecated }
GtTreePagerPaneElement >> hideToolbarElements [
	self hideDropdownElement.
	self hideMaximizeButton.
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
			addChild: (dropdownElement := self newDropdownMenuElement);
			addAptitude: (maximizerAptitude := BrGlamorousWithMaximizerAptitude new
						hideMaximizeButton;
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

	keysEventHandler := GtTreePagerPaneKeyEventHandler new paneElement: self.
	
	self when: BlMouseEnterEvent do: [ :anEvent | self onBlMouseEnterEvent: anEvent ].
	self when: BlMouseLeaveEvent do: [ :anEvent | self onBlMouseLeaveEvent: anEvent ]
]

{ #category : #initialization }
GtTreePagerPaneElement >> initializeFollowingsElement [
	followingsElement := GtTreePagerPaneCompressedFollowingsElement new
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
GtTreePagerPaneElement >> newDropdownCollapseIcon [
	^ BlElement new
		size: 2 @ 10;
		background: Color gray
]

{ #category : #initialization }
GtTreePagerPaneElement >> newDropdownDownwardsIcon [
	^ BrGlamorousVectorIcons downwards
]

{ #category : #initialization }
GtTreePagerPaneElement >> newDropdownMaximizeIcon [
	^ BrPlusIconStencil new radius: 4
]

{ #category : #initialization }
GtTreePagerPaneElement >> newDropdownMenuElement [
	^ GtInspectorRoundButtonStencil small asElement
		id: #'gt-pager-dropdown-menu-button';
		icon: self newDropdownDownwardsIcon;
		actionWithModifiers: [ :aButton :aButtonModel :anEvent | self onDropdownWithModifiersCollapseClick: anEvent ];
		actionWithModifiers: [ :aButton :aButtonModel :anEvent | self onDropdownWithModifiersMaximizeClick: anEvent ];
		addAptitude: (BrGlamorousWithExplicitDropdownAptitude new
				handle: [ BrButton new
							size: 16 @ 16;
							background: Color white;
							aptitude: BrIconAptitude;
							geometry: BlEllipseGeometry new;
							layout: BlLinearLayout horizontal alignCenter;
							icon: BrGlamorousVectorIcons downwards ]
					menu: [ self newDropdownMenuModel ]);
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c ignored horizontal alignCenterAt: 1.0.
			c ignored vertical alignCenterAt: 0.0 ]
]

{ #category : #initialization }
GtTreePagerPaneElement >> newDropdownMenuModel [
	| aLinkModel |
	self hasPaneModel ifFalse: [ ^ nil ].
	aLinkModel := self paneModel previousLink.
	aLinkModel ifNil: [ ^ nil ].

	^ GtTreePagerPaneContextMenuBuilder new
		linkModel: aLinkModel;
		build
]

{ #category : #'private - event handling' }
GtTreePagerPaneElement >> onBlMouseEnterEvent: anEvent [
	self isAttachedToSceneGraph ifFalse: [ ^ self ].

	self space addEventFilter: keysEventHandler.
	self onModifiersEvent: anEvent
]

{ #category : #'private - event handling' }
GtTreePagerPaneElement >> onBlMouseLeaveEvent: anEvent [
	self isAttachedToSceneGraph ifFalse: [ ^ self ].

	self space removeEventFilter: keysEventHandler
]

{ #category : #'private - event management' }
GtTreePagerPaneElement >> onDropdownWithModifiersCollapseClick: anEvent [
	anEvent consumed: true.
	self hasPaneModel ifFalse: [ ^ self ].
	self paneModel depthIndex = 1 ifTrue: [ ^ self ].

	anEvent modifiers isSoftPrimaryModifierOnly ifFalse: [ ^ self ].

	dropdownElement dispatchEvent: BrDropdownHideWish new.
	self paneModel collapseOrSelect
]

{ #category : #'private - event management' }
GtTreePagerPaneElement >> onDropdownWithModifiersMaximizeClick: anEvent [
	anEvent consumed: true.
	self hasPaneModel ifFalse: [ ^ self ].

	anEvent modifiers isSoftShiftPrimaryModifierOnly ifFalse: [ ^ self ].

	dropdownElement dispatchEvent: BrDropdownHideWish new.
	self maximize
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

{ #category : #deprecated }
GtTreePagerPaneElement >> onGtTreePagerLinkModelStateChanged: anAnnouncement [
	
]

{ #category : #deprecated }
GtTreePagerPaneElement >> onGtTreePagerPaneModelFollowingPanesChanged: anAnnouncement [
	anAnnouncement paneModel = self paneModel ifFalse: [ ^ self ]
]

{ #category : #'private - event handling' }
GtTreePagerPaneElement >> onGtTreePagerPaneModelMaximizeRequest: anAnnouncement [
	anAnnouncement paneModel = self paneModel ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ self maximize ]
]

{ #category : #'api - event managing' }
GtTreePagerPaneElement >> onModifiersEvent: anEvent [
	"I update the dropdown element based on event modifiers"

	anEvent modifiers isSoftPrimaryModifierOnly
		ifTrue: [ ^ self updateDropdownElementToCollapseIcon ].

	anEvent modifiers isSoftShiftPrimaryModifierOnly
		ifTrue: [ ^ self updateDropdownElementToMaximizeIcon ].

	self updateDropdownElementToDownwardsIcon
]

{ #category : #accessing }
GtTreePagerPaneElement >> onPaneModelChanged [
	super onPaneModelChanged.
	contentElement paneModel: self paneModel.
	followingsElement paneModel: self paneModel.
	
	self updateElement.
]

{ #category : #'hooks - children' }
GtTreePagerPaneElement >> onRemovedFromSceneGraph [
	super onRemovedFromSceneGraph.
	keysEventHandler uninstall
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
GtTreePagerPaneElement >> showDropdownElement [
	dropdownElement
		ifNotNil: [ :anElement | anElement visibility: BlVisibility visible ]
]

{ #category : #deprecated }
GtTreePagerPaneElement >> showMaximizeButton [
	maximizerAptitude showMaximizeButton
]

{ #category : #'api - updating' }
GtTreePagerPaneElement >> showToolbarElements [
	self showDropdownElement.
	self showMaximizeButton
]

{ #category : #'api - pane model' }
GtTreePagerPaneElement >> subscribeToPaneModel [
	super subscribeToPaneModel.

	self paneModel announcer weak
		when: GtTreePagerPaneModelMaximizeRequest
			send: #onGtTreePagerPaneModelMaximizeRequest:
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
GtTreePagerPaneElement >> updateDropdownElementToCollapseIcon [
	dropdownElement ifNil: [ ^ self ].

	self paneModel ifNil: [ ^ self ].
	self paneModel depthIndex = 1
		ifTrue: [ ^ self updateDropdownElementToDownwardsIcon ].

	dropdownElement userData
		at: #gtTreePagerDropdownElementState
		ifPresent: [ :aSymbol | aSymbol = #collapse ifTrue: [ ^ self ] ]
		ifAbsent: [  ].

	dropdownElement userData at: #gtTreePagerDropdownElementState put: #collapse.

	^ dropdownElement
		icon: self newDropdownCollapseIcon;
		label: 'Collapse pane'
]

{ #category : #'private - updating' }
GtTreePagerPaneElement >> updateDropdownElementToDownwardsIcon [
	dropdownElement ifNil: [ ^ self ].

	dropdownElement userData
		at: #gtTreePagerDropdownElementState
		ifPresent: [ :aSymbol | aSymbol = #downwards ifTrue: [ ^ self ] ]
		ifAbsent: [  ].

	dropdownElement userData at: #gtTreePagerDropdownElementState put: #downwards.

	^ dropdownElement
		icon: self newDropdownDownwardsIcon;
		label: 'Display menu'
]

{ #category : #'private - updating' }
GtTreePagerPaneElement >> updateDropdownElementToMaximizeIcon [
	dropdownElement ifNil: [ ^ self ].

	dropdownElement userData
		at: #gtTreePagerDropdownElementState
		ifPresent: [ :aSymbol | aSymbol = #maximize ifTrue: [ ^ self ] ]
		ifAbsent: [  ].

	dropdownElement userData at: #gtTreePagerDropdownElementState put: #maximize.

	^ dropdownElement
		icon: self newDropdownMaximizeIcon;
		label: 'Maximize pane'
]

{ #category : #'private - updating' }
GtTreePagerPaneElement >> updateElement [
	
]
