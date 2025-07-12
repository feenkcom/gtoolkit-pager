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
		margin: (BlInsets all: 2);
		outskirts: BlOutskirts centered;
		when: BlClickEvent do: [ :anEvent | self onClickEvent: anEvent ];
		addAptitude: (BrGlamorousWithExplicitContextMenuAptitude new
				handleSubmenu: [ self newContextMenu ]).

	self initializeElementStyling.
	self initializeGeometryAndSizeStyling
]

{ #category : #initialization }
GtTreePagerLinkFollowingOutputElement >> initializeElementStyling [
	| anAptitude |
	anAptitude := BrLazyStyleCommonAptitude new
			when: BrSizeAdjustmentState normal & BlElementState selected not
						& BlElementState hovered not
				style: [ :aStyle | 
					aStyle background: BlBackground transparent.
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
GtTreePagerLinkFollowingOutputElement >> initializeGeometryAndSizeStyling [
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
GtTreePagerLinkFollowingOutputElement >> newContextMenu [
	^ GtTreePagerLinkContextMenuBuilder new
		linkModel: self linkModel;
		build
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
	| aToolModel |
	self visibility isVisible ifFalse: [ ^ self ].
	self linkModel ifNil: [ ^ self ].
	anEvent consumed: true.

	aToolModel := self linkModel expand
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
	^ 32
]

{ #category : #initialization }
GtTreePagerLinkFollowingOutputElement >> triangleWidth [
	^ 16
]

{ #category : #'api - pane model' }
GtTreePagerLinkFollowingOutputElement >> unsubscribeFromLinkModel [
	self linkModel unsubscribe: self
]

{ #category : #'api - pane model' }
GtTreePagerLinkFollowingOutputElement >> updateElement [
	self linkModel isActive
		ifTrue: [ self states addState: BlElementState selected ]
		ifFalse: [ self states removeState: BlElementState selected ]
]
