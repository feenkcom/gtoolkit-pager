Class {
	#name : #GtTreePagerPaneFollowingExpandedElement,
	#superclass : #GtTreePagerPaneBasicElement,
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #initialization }
GtTreePagerPaneFollowingExpandedElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtTreePagerPaneFollowingExpandedElement >> initialize [
	super initialize.

	self
		exact: 16 @ 32;
		geometry: (BlPolygonGeometry
				vertices: {0 @ 0.
						16 @ 16.
						0 @ 32});
		constraintsDo: [ :c | 
			c linear horizontal alignRight.
			c linear vertical alignCenter ];
		outskirts: BlOutskirts inside;
		margin: (BlInsets all: 2);
		when: BlClickEvent do: [ :anEvent | self onClickEvent: anEvent ];
		addAptitude: (BrGlamorousWithExplicitContextMenuAptitude new
				handleSubmenu: [ self newContextMenu ]).
				
	self initializeElementStyling
]

{ #category : #initialization }
GtTreePagerPaneFollowingExpandedElement >> initializeElementStyling [
	| anAptitude |
	anAptitude := BrLazyStyleCommonAptitude new
			default: [ :aStyle | 
				aStyle background: self theme button defaultBackground.
				aStyle border: self theme button fadedBackgroundColor ];
			hovered: [ :aStyle | 
					aStyle background: self theme button focusedFadedBackgroundColor.
					aStyle border: self theme button focusedFadedBackgroundColor ];
			when: BlElementState selected & BlElementState hovered not
				style: [ :aStyle | 
					aStyle background: self theme button fadedBackgroundColor.
					aStyle border: self theme button fadedBackgroundColor ].

	self addAptitude: anAptitude
]

{ #category : #initialization }
GtTreePagerPaneFollowingExpandedElement >> newContextMenu [
	| aMenu anActionItem |
	aMenu := BrMenuItems new.

	self paneModel isActiveLink
		ifTrue: [ anActionItem := BrMenuActionItem new
					id: #'menu--keep-link';
					label: 'Keep' preview: [ self paneModel title ];
					action: [ :anElement :aButtonModel :anEvent | self paneModel beInactiveLink ];
					yourself ]
		ifFalse: [ anActionItem := BrMenuActionItem new
					id: #'menu--activate-link';
					label: 'Activate' preview: [ self paneModel title ];
					action: [ :anElement :aButtonModel :anEvent | self paneModel beActiveLink ];
					yourself ].
	aMenu addItem: anActionItem.
	
	anActionItem := BrMenuActionItem new
			id: #'menu--collapse-pane';
			label: 'Collapse' preview: [ self paneModel title ];
			action: [ :anElement :aButtonModel :anEvent | self paneModel collapse ];
			yourself.
	aMenu addItem: anActionItem.

	anActionItem := BrMenuActionItem new
			id: #'menu--remove-pane';
			label: 'Remove' preview: [ self paneModel title ];
			action: [ :anElement :aButtonModel :anEvent | self paneModel removeFromPreviousPane ];
			yourself.
	aMenu addItem: anActionItem.

	^ aMenu
]

{ #category : #'private - event management' }
GtTreePagerPaneFollowingExpandedElement >> onClickEvent: anEvent [
	| aToolModel |
	self visibility isVisible ifFalse: [ ^ self ].
	self paneModel ifNil: [ ^ self ].
	anEvent consumed: true.

	aToolModel := self paneModel expand
]

{ #category : #'private - event handling' }
GtTreePagerPaneFollowingExpandedElement >> onGtTreePagerPaneModelPreviousActiveLinkChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'api - pane model' }
GtTreePagerPaneFollowingExpandedElement >> onPaneModelChanged [
	self updateElement
]

{ #category : #'api - pane model' }
GtTreePagerPaneFollowingExpandedElement >> subscribeToPaneModel [
	self paneModel weak
		when: GtTreePagerPaneModelPreviousActiveLinkChanged
		send: #onGtTreePagerPaneModelPreviousActiveLinkChanged:
		to: self
]

{ #category : #'api - pane model' }
GtTreePagerPaneFollowingExpandedElement >> unsubscribeFromPaneModel [
	self paneModel unsubscribe: self
]

{ #category : #'api - pane model' }
GtTreePagerPaneFollowingExpandedElement >> updateElement [
	self paneModel isActiveLink
		ifTrue: [ self states addState: BlElementState selected ]
		ifFalse: [ self states removeState: BlElementState selected ]
]
