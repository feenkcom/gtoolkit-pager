Class {
	#name : #GtTreePagerPaneFollowingTriangleElement,
	#superclass : #GtTreePagerPaneBasicElement,
	#traits : 'TBrSizeAdjustable',
	#classTraits : 'TBrSizeAdjustable classTrait',
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #initialization }
GtTreePagerPaneFollowingTriangleElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtTreePagerPaneFollowingTriangleElement >> initialize [
	super initialize.

	self
		beNormalSize;
		constraintsDo: [ :c | 
			c linear horizontal alignRight.
			c linear vertical alignCenter ];
		outskirts: BlOutskirts centered;
		margin: (BlInsets all: 2);
		when: BlClickEvent do: [ :anEvent | self onClickEvent: anEvent ];
		addAptitude: (BrGlamorousWithExplicitContextMenuAptitude new
				handleSubmenu: [ self newContextMenu ]).

	self initializeElementStyling.
	self initializeSizeStyling.
]

{ #category : #initialization }
GtTreePagerPaneFollowingTriangleElement >> initializeElementStyling [
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
GtTreePagerPaneFollowingTriangleElement >> initializeSizeStyling [
	| anAptitude |
	anAptitude := BrSizeAdjustmentAptitude new
			small: [ :aStyle | 
				aStyle geometry: self smallSizeGeometry.
				aStyle do: [ :aWidget | aWidget exact: 10 @ 20 ] ];
			normal: [ :aStyle | 
				aStyle geometry: self normalSizeGeometry.
				aStyle do: [ :aWidget | aWidget exact: 16 @ 30 ] ].

	self addAptitude: anAptitude
]

{ #category : #initialization }
GtTreePagerPaneFollowingTriangleElement >> newContextMenu [
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
			label: 'Remove'
				preview: [ '{1}{2}'
						format: {self paneModel title.
								self paneModel allFollowingPanesCount
									ifNotNil: [ :aCount | 
										aCount isZero
											ifTrue: [ '' ]
											ifFalse: [ ' and {1} other {2}'
													format: {aCount.
															'pane' asPluralBasedOn: aCount} ] ]
									ifNil: [ '' ]} ];
			action: [ :anElement :aButtonModel :anEvent | self paneModel removeFromPreviousPane ];
			yourself.
	aMenu addItem: anActionItem.

	^ aMenu
]

{ #category : #initialization }
GtTreePagerPaneFollowingTriangleElement >> normalSizeGeometry [
	^ BlPolygonGeometry
		vertices: {0 @ 0.
				16 @ 16.
				0 @ 32}
]

{ #category : #'private - event management' }
GtTreePagerPaneFollowingTriangleElement >> onClickEvent: anEvent [
	| aToolModel |
	self visibility isVisible ifFalse: [ ^ self ].
	self paneModel ifNil: [ ^ self ].
	anEvent consumed: true.

	aToolModel := self paneModel expand
]

{ #category : #'private - event handling' }
GtTreePagerPaneFollowingTriangleElement >> onGtTreePagerPaneModelPreviousActiveLinkChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'api - pane model' }
GtTreePagerPaneFollowingTriangleElement >> onPaneModelChanged [
	self updateElement
]

{ #category : #initialization }
GtTreePagerPaneFollowingTriangleElement >> smallSizeGeometry [
	^ BlPolygonGeometry
		vertices: {0 @ 0.
				10 @ 10.
				0 @ 20}
]

{ #category : #'api - pane model' }
GtTreePagerPaneFollowingTriangleElement >> subscribeToPaneModel [
	self paneModel weak
		when: GtTreePagerPaneModelPreviousActiveLinkChanged
		send: #onGtTreePagerPaneModelPreviousActiveLinkChanged:
		to: self
]

{ #category : #'api - pane model' }
GtTreePagerPaneFollowingTriangleElement >> unsubscribeFromPaneModel [
	self paneModel unsubscribe: self
]

{ #category : #'api - pane model' }
GtTreePagerPaneFollowingTriangleElement >> updateElement [
	self paneModel isActiveLink
		ifTrue: [ self states addState: BlElementState selected ]
		ifFalse: [ self states removeState: BlElementState selected ]
]
