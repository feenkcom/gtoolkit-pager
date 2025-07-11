Class {
	#name : #GtTreePagerPaneFollowingOutputElement,
	#superclass : #GtTreePagerLinkBasicElement,
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

{ #category : #'accessing - ui' }
GtTreePagerPaneFollowingOutputElement >> incomingLinkElements [
	^ Array empty
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
	^ GtTreePagerLinkContextMenuBuilder new
		linkModel: self linkModel;
		build
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
	self linkModel ifNil: [ ^ self ].
	anEvent consumed: true.

	aToolModel := self linkModel expand
]

{ #category : #'private - event handling' }
GtTreePagerPaneFollowingOutputElement >> onGtTreePagerLinkModelStateChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'api - pane model' }
GtTreePagerPaneFollowingOutputElement >> onLinkModelChanged [
	self updateElement
]

{ #category : #'accessing - ui' }
GtTreePagerPaneFollowingOutputElement >> outgoingLinkElements [
	^ self hasLinkModel ifTrue: [ Array with: self ] ifFalse: [ Array empty ]
]

{ #category : #'api - pane model' }
GtTreePagerPaneFollowingOutputElement >> subscribeToLinkModel [
	super subscribeToLinkModel.
	self linkModel weak
		when: GtTreePagerLinkModelStateChanged
			send: #onGtTreePagerLinkModelStateChanged:
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
GtTreePagerPaneFollowingOutputElement >> unsubscribeFromLinkModel [
	self linkModel unsubscribe: self
]

{ #category : #'api - pane model' }
GtTreePagerPaneFollowingOutputElement >> updateElement [
	self linkModel isActive
		ifTrue: [ self states addState: BlElementState selected ]
		ifFalse: [ self states removeState: BlElementState selected ]
]
