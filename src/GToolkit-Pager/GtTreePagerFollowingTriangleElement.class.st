Class {
	#name : #GtTreePagerFollowingTriangleElement,
	#superclass : #GtTreePagerPaneBasicElement,
	#instVars : [
		'collapsedToolsElement'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #initialization }
GtTreePagerFollowingTriangleElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtTreePagerFollowingTriangleElement >> initialize [
	super initialize.

	self
		exact: 16 @ 32;
		geometry: (BlPolygonGeometry
				vertices: {0 @ 0.
						16 @ 16.
						0 @ 32});
		aptitude: BrGlamorousFadedButtonExteriourAptitude;
		visibility: BlVisibility visible;
		outskirts: BlOutskirts outside;
		constraintsDo: [ :c | 
			c linear horizontal alignRight.
			c linear vertical alignCenter ];
		margin: (BlInsets all: 2);
		when: BlClickEvent do: [ :anEvent | self onClickEvent: anEvent ];
		addAptitude: (BrGlamorousWithExplicitContextMenuAptitude new
				handleSubmenu: [ self newContextMenu ])
]

{ #category : #initialization }
GtTreePagerFollowingTriangleElement >> newContextMenu [
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
			id: #'menu--remove-pane';
			label: 'Remove' preview: [ self paneModel title ];
			action: [ :anElement :aButtonModel :anEvent | self paneModel removeFromPreviousPane ];
			yourself.
	aMenu addItem: anActionItem.

	^ aMenu
]

{ #category : #'private - event management' }
GtTreePagerFollowingTriangleElement >> onClickEvent: anEvent [
	| aToolModel |
	self visibility isVisible ifFalse: [ ^ self ].
	self paneModel ifNil: [ ^ self ].
	anEvent consumed: true.

	aToolModel := self paneModel expand
]

{ #category : #'private - event handling' }
GtTreePagerFollowingTriangleElement >> onGtTreePagerPaneModelPreviousActiveLinkChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'api - pane model' }
GtTreePagerFollowingTriangleElement >> onPaneModelChanged [
	self updateElement
]

{ #category : #'api - pane model' }
GtTreePagerFollowingTriangleElement >> subscribeToPaneModel [
	self paneModel weak
		when: GtTreePagerPaneModelPreviousActiveLinkChanged
		send: #onGtTreePagerPaneModelPreviousActiveLinkChanged:
		to: self
]

{ #category : #'api - pane model' }
GtTreePagerFollowingTriangleElement >> unsubscribeFromPaneModel [
	self paneModel unsubscribe: self
]

{ #category : #'api - pane model' }
GtTreePagerFollowingTriangleElement >> updateElement [
	self paneModel isActiveLink
		ifTrue: [ self border: (BlBorder paint: self theme default darkBorderColor) ]
		ifFalse: [ self border: BlBorder empty ]
]
