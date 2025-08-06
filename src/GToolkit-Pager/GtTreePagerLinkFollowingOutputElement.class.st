Class {
	#name : #GtTreePagerLinkFollowingOutputElement,
	#superclass : #GtTreePagerLinkBasicElement,
	#traits : 'TBrSizeAdjustable',
	#classTraits : 'TBrSizeAdjustable classTrait',
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'api - orientation' }
GtTreePagerLinkFollowingOutputElement >> beHorizontal [
	self states addState: BrListOrientationState horizontal
]

{ #category : #'api - orientation' }
GtTreePagerLinkFollowingOutputElement >> beVertical [
	self states addState: BrListOrientationState vertical
]

{ #category : #initialization }
GtTreePagerLinkFollowingOutputElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #'accessing - ui' }
GtTreePagerLinkFollowingOutputElement >> incomingLinkElements [
	^ Array empty
]

{ #category : #initialization }
GtTreePagerLinkFollowingOutputElement >> initialize [
	super initialize.

	self
		beNormalSize;
		constraintsDo: [ :c | 
			c linear horizontal alignRight.
			c linear vertical alignCenter ];
		outskirts: BlOutskirts centered;
		when: BlClickEvent do: [ :anEvent | self onClickEvent: anEvent ];
		addAptitude: (BrGlamorousWithExplicitContextMenuAptitude new
				handleSubmenu: [ self newContextMenu ]).

	self initializeElementStyling.
	self initializeGeometryAndSizeStyling.
	self initializeOutgoingLinkElements.
]

{ #category : #initialization }
GtTreePagerLinkFollowingOutputElement >> initializeElementStyling [
	| anAptitude |
	anAptitude := BrLazyStyleCommonAptitude new
			when: BrSizeAdjustmentState normal & BlElementState selected not
						& BlElementState hovered not
				style: [ :aStyle | 
					aStyle background: BlBackground transparent.
					aStyle border: (BlBorder paint: self theme default backdropEmphasisBackground width: 1) ];
			when: BrSizeAdjustmentState small & BlElementState selected not
						& BlElementState hovered not
				style: [ :aStyle | aStyle background: self theme default backdropEmphasisBackground ];
			when: BrSizeAdjustmentState normal & BlElementState hovered
				style: [ :aStyle | 
					aStyle background: self theme button focusedFadedBackgroundColor.
					aStyle border: self theme button focusedFadedBackgroundColor ];
			when: BrSizeAdjustmentState small & BlElementState hovered
				style: [ :aStyle | aStyle background: self theme button focusedFadedBackgroundColor ];
			when: BrSizeAdjustmentState normal & BlElementState selected
						& BlElementState hovered not
				style: [ :aStyle | 
					aStyle background: self theme default backdropEmphasisBackground .
					aStyle border: self theme default backdropEmphasisBackground  ];
			when: BrSizeAdjustmentState small & BlElementState selected
						& BlElementState hovered not
				style: [ :aStyle | aStyle background: self theme default backdropEmphasisBackground  ].

	self addAptitude: anAptitude
]

{ #category : #initialization }
GtTreePagerLinkFollowingOutputElement >> initializeGeometryAndSizeStyling [
	| anAptitude |
	anAptitude := BrSizeAdjustmentAptitude new
			when: BrListOrientationState vertical & BrSizeAdjustmentState small
				style: [ :aStyle | 
					aStyle geometry: BlRectangleGeometry new.
					aStyle
						do: [ :aWidget | aWidget exact: GtTreePagerConstants outputLenght @ 1 ] ];
			when: BrListOrientationState horizontal & BrSizeAdjustmentState small
				style: [ :aStyle | 
					aStyle geometry: BlRectangleGeometry new.
					aStyle
						do: [ :aWidget | aWidget exact: 1 @ GtTreePagerConstants outputLenght ] ];
			when: BrListOrientationState horizontal & BrSizeAdjustmentState normal
				style: [ :aStyle | 
					aStyle geometry: self normalSizeGeometry.
					aStyle
						do: [ :aWidget | aWidget exact: self triangleWidth @ self triangleHeight ] ];
			when: BrListOrientationState vertical & BrSizeAdjustmentState normal
				style: [ :aStyle | 
					aStyle geometry: self normalSizeCollapsedGeometry.
					aStyle
						do: [ :aWidget | aWidget exact: GtTreePagerConstants rectangleLength @ (GtTreePagerConstants rectangleLength // 2) ] ].

	self addAptitude: anAptitude
]

{ #category : #initialization }
GtTreePagerLinkFollowingOutputElement >> initializeOutgoingLinkElements [
	self
		addAptitude: (BrLazyStyleCommonAptitude new
				hovered: [ :aStyle | 
					aStyle
						do: [ :aWidget | 
							aWidget userData
								at: #outgoingLineElement
								ifPresent: [ :aCollection | 
									aCollection
										do: [ :eachLinkElement | eachLinkElement states addState: BlElementState hovered ] ]
								ifAbsent: [  ] ]
						after: [ :aWidget | 
							aWidget userData
								at: #outgoingLineElement
								ifPresent: [ :aCollection | 
									aCollection
										do: [ :eachLinkElement | eachLinkElement states removeState: BlElementState hovered ] ]
								ifAbsent: [  ] ] ])
]

{ #category : #initialization }
GtTreePagerLinkFollowingOutputElement >> newContextMenu [
	^ GtTreePagerLinkContextMenuBuilder new
		linkModel: self linkModel;
		build
]

{ #category : #initialization }
GtTreePagerLinkFollowingOutputElement >> normalSizeCollapsedGeometry [
	^ BlPolygonGeometry
		vertices: {0 @ 0.
				GtTreePagerConstants rectangleLength @ 0.
				(GtTreePagerConstants rectangleLength // 2) @ (GtTreePagerConstants rectangleLength // 2)}
]

{ #category : #initialization }
GtTreePagerLinkFollowingOutputElement >> normalSizeGeometry [
	^ BlPolygonGeometry
		vertices: {0 @ 0.
				self triangleWidth @ (self triangleHeight // 2).
				0 @ self triangleHeight}
]

{ #category : #'private - event management' }
GtTreePagerLinkFollowingOutputElement >> onClickEvent: anEvent [
	self visibility isVisible ifFalse: [ ^ self ].
	self hasLinkModel ifFalse: [ ^ self ].
	anEvent consumed: true.

	GtTreePagerLinkFollowingOutputClickResolver new 
		element: self;
		linkModel: self linkModel;
		resolve.
]

{ #category : #'private - event handling' }
GtTreePagerLinkFollowingOutputElement >> onGtTreePagerLinkModelStateChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'api - pane model' }
GtTreePagerLinkFollowingOutputElement >> onLinkModelChanged [
	self updateElement
]

{ #category : #'accessing - ui' }
GtTreePagerLinkFollowingOutputElement >> outgoingLinkElements [
	^ self hasLinkModel ifTrue: [ Array with: self ] ifFalse: [ Array empty ]
]

{ #category : #'api - pane model' }
GtTreePagerLinkFollowingOutputElement >> subscribeToLinkModel [
	super subscribeToLinkModel.
	self linkModel weak
		when: GtTreePagerLinkModelStateChanged
			send: #onGtTreePagerLinkModelStateChanged:
			to: self
]

{ #category : #initialization }
GtTreePagerLinkFollowingOutputElement >> triangleHeight [
	^ GtTreePagerConstants triangleHeight
]

{ #category : #initialization }
GtTreePagerLinkFollowingOutputElement >> triangleWidth [
	^ GtTreePagerConstants triangleWidth
]

{ #category : #'api - pane model' }
GtTreePagerLinkFollowingOutputElement >> unsubscribeFromLinkModel [
	self linkModel unsubscribe: self
]

{ #category : #'api - pane model' }
GtTreePagerLinkFollowingOutputElement >> updateElement [
	self linkModel isActive
		ifTrue: [ self states addState: BlElementState selected ]
		ifFalse: [ self states removeState: BlElementState selected ].

	((self states hasState: BrSizeAdjustmentState normal)
		and: [ self linkModel isSpawned ])
		ifFalse: [ self states addState: BrListOrientationState vertical ]
		ifTrue: [ self states addState: BrListOrientationState horizontal ]
]
