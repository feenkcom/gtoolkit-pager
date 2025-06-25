Class {
	#name : #GtTreePagerPaneFollowingOutputElement,
	#superclass : #GtTreePagerPaneBasicElement,
	#traits : 'TBrSizeAdjustable',
	#classTraits : 'TBrSizeAdjustable classTrait',
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'api - orientation' }
GtTreePagerPaneFollowingOutputElement >> beHorizontal [
	self states addState: BrListOrientationState horizontal
]

{ #category : #'api - orientation' }
GtTreePagerPaneFollowingOutputElement >> beVertical [
	self states addState: BrListOrientationState vertical
]

{ #category : #initialization }
GtTreePagerPaneFollowingOutputElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtTreePagerPaneFollowingOutputElement >> initialize [
	super initialize.

	self
		beNormalSize;
		constraintsDo: [ :c | 
			c linear horizontal alignRight.
			c linear vertical alignCenter ];
		margin: (BlInsets all: 2);
		outskirts: BlOutskirts centered;
		when: BlClickEvent do: [ :anEvent | self onClickEvent: anEvent ];
		addAptitude: (BrGlamorousWithExplicitContextMenuAptitude new
				handleSubmenu: [ self newContextMenu ]).

	self initializeElementStyling.
	self initializeGeometryAndSizeStyling
]

{ #category : #initialization }
GtTreePagerPaneFollowingOutputElement >> initializeElementStyling [
	| anAptitude |
	anAptitude := BrLazyStyleCommonAptitude new
			when: BrSizeAdjustmentState normal & BlElementState selected not
						& BlElementState hovered not
				style: [ :aStyle | 
					aStyle background: self theme button defaultBackground.
					aStyle border: self theme button fadedBackgroundColor ];
			when: BrSizeAdjustmentState small & BlElementState selected not
						& BlElementState hovered not
				style: [ :aStyle | aStyle background: self theme button fadedBackgroundColor ];
			when: BrSizeAdjustmentState normal & BlElementState hovered
				style: [ :aStyle | 
					aStyle background: self theme button focusedFadedBackgroundColor.
					aStyle border: self theme button focusedFadedBackgroundColor ];
			when: BrSizeAdjustmentState small & BlElementState hovered
				style: [ :aStyle | aStyle background: self theme button focusedFadedBackgroundColor ];
			when: BrSizeAdjustmentState normal & BlElementState selected
						& BlElementState hovered not
				style: [ :aStyle | 
					aStyle background: self theme button fadedBackgroundColor.
					aStyle border: self theme button fadedBackgroundColor ];
			when: BrSizeAdjustmentState small & BlElementState selected
						& BlElementState hovered not
				style: [ :aStyle | aStyle background: self theme button fadedBackgroundColor ].

	self addAptitude: anAptitude
]

{ #category : #initialization }
GtTreePagerPaneFollowingOutputElement >> initializeGeometryAndSizeStyling [
	| anAptitude |
	anAptitude := BrSizeAdjustmentAptitude new
			when: BrListOrientationState horizontal & BrSizeAdjustmentState small
				style: [ :aStyle | 
					aStyle geometry: BlRectangleGeometry new.
					aStyle do: [ :aWidget | aWidget exact: 6 @ 1 ] ];
			when: BrListOrientationState vertical & BrSizeAdjustmentState small
				style: [ :aStyle | 
					aStyle geometry: BlRectangleGeometry new.
					aStyle do: [ :aWidget | aWidget exact: 1 @ 6 ] ];
			normal: [ :aStyle | 
				aStyle geometry: self normalSizeGeometry.
				aStyle
					do: [ :aWidget | aWidget exact: self triangleWidth @ self triangleHeight ] ].

	self addAptitude: anAptitude
]

{ #category : #initialization }
GtTreePagerPaneFollowingOutputElement >> newContextMenu [
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

	self paneModel isExpanded
		ifTrue: [ anActionItem := BrMenuActionItem new
					id: #'menu--collapse-pane';
					label: 'Collapse' preview: [ self paneModel title ];
					action: [ :anElement :aButtonModel :anEvent | self paneModel collapse ];
					yourself ]
		ifFalse: [ anActionItem := BrMenuActionItem new
					id: #'menu--expand-pane';
					label: 'Expand' preview: [ self paneModel title ];
					action: [ :anElement :aButtonModel :anEvent | self paneModel expand ];
					yourself ].
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
GtTreePagerPaneFollowingOutputElement >> normalSizeGeometry [
	^ BlPolygonGeometry
		vertices: {0 @ 0.
				self triangleWidth @ (self triangleHeight // 2).
				0 @ self triangleHeight}
]

{ #category : #'private - event management' }
GtTreePagerPaneFollowingOutputElement >> onClickEvent: anEvent [
	| aToolModel |
	self visibility isVisible ifFalse: [ ^ self ].
	self paneModel ifNil: [ ^ self ].
	anEvent consumed: true.

	aToolModel := self paneModel expand
]

{ #category : #'private - event handling' }
GtTreePagerPaneFollowingOutputElement >> onGtTreePagerPaneModelPreviousActiveLinkChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'api - pane model' }
GtTreePagerPaneFollowingOutputElement >> onPaneModelChanged [
	self updateElement
]

{ #category : #'api - pane model' }
GtTreePagerPaneFollowingOutputElement >> subscribeToPaneModel [
	self paneModel weak
		when: GtTreePagerPaneModelPreviousActiveLinkChanged
		send: #onGtTreePagerPaneModelPreviousActiveLinkChanged:
		to: self
]

{ #category : #initialization }
GtTreePagerPaneFollowingOutputElement >> triangleHeight [
	^ 32
]

{ #category : #initialization }
GtTreePagerPaneFollowingOutputElement >> triangleWidth [
	^ 16
]

{ #category : #'api - pane model' }
GtTreePagerPaneFollowingOutputElement >> unsubscribeFromPaneModel [
	self paneModel unsubscribe: self
]

{ #category : #'api - pane model' }
GtTreePagerPaneFollowingOutputElement >> updateElement [
	self paneModel isActiveLink
		ifTrue: [ self states addState: BlElementState selected ]
		ifFalse: [ self states removeState: BlElementState selected ]
]
