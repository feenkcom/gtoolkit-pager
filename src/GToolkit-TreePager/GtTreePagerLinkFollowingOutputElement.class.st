Class {
	#name : #GtTreePagerLinkFollowingOutputElement,
	#superclass : #GtTreePagerLinkBasicElement,
	#traits : 'TBrSizeAdjustable',
	#classTraits : 'TBrSizeAdjustable classTrait',
	#instVars : [
		'timeAnimation',
		'timeAnimationState'
	],
	#category : #'GToolkit-TreePager-UI'
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
				handleSubmenu: [ self newContextMenu ]);
				when: BrContextMenuIsVisible do: [ :anEvent | self onBrContextMenuIsVisible: anEvent ];
				when: BrContextMenuIsHidden do: [ :anEvent | self onBrContextMenuIsHidden: anEvent ].

	self initializeElementStyling.
	self initializeAboutToRemoveAnimationStyling.
	self initializeOutgoingLinkElements
]

{ #category : #initialization }
GtTreePagerLinkFollowingOutputElement >> initializeAboutToRemoveAnimationStyling [
	self
		addAptitude: (BrLazyStyleCommonAptitude new
				hovered: [ :aStyle | aStyle do: [ :aWidget | self onHovered ] after: [ :aWidget | self onUnhovered ] ])
]

{ #category : #initialization }
GtTreePagerLinkFollowingOutputElement >> initializeElementStyling [
	| anAptitude |
	anAptitude := BrLazyStyleCommonAptitude new
			when: BlElementState selected not & BlElementState hovered not
				style: [ :aStyle | 
					aStyle background: self theme default backdropEmphasisBackground.
					aStyle
						border: (BlBorder paint: self theme default backdropEmphasisBackground width: 1) ];
			when: BlElementState selected & BlElementState hovered not
				style: [ :aStyle | 
					aStyle background: self theme default backdropEmphasisBackground.
					aStyle border: self theme button focusedFadedBackgroundColor ];
			when: BlElementState hovered
				style: [ :aStyle | 
					aStyle background: self theme button focusedFadedBackgroundColor.
					aStyle border: self theme button focusedFadedBackgroundColor ].

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
GtTreePagerLinkFollowingOutputElement >> newAboutToBeRemovedGeometry [
	^ BlAnnulusSectorGeometry new
		startAngle: -90;
		endAngle: 270;
		innerRadius: 0
]

{ #category : #initialization }
GtTreePagerLinkFollowingOutputElement >> newAnimation [
	^ BlNumberTransition new
		onStepDo: [ :eachOffset | 
			self
				geometry: (self newAboutToBeRemovedGeometry
						startAngle: eachOffset;
						endAngle: 270) ];
		from: -90;
		to: 270;
		by: 6;
		duration: GtTreePagerConstants replacedLinkRestoration;
		onFinishedDo: [ self onAnimationFinished ]
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

{ #category : #'private - event handling' }
GtTreePagerLinkFollowingOutputElement >> onAnimationFinished [
	timeAnimation := nil.
	self geometry: self newAboutToBeRemovedGeometry.
	
	"Let's ensure we do not remove the about to remove link."
	timeAnimationState ifNotNil: [ ^ self ].
	
	self hasLinkModel ifFalse: [ ^ self ].
	self linkModel removeFromPreviousPane
]

{ #category : #'private - event handling' }
GtTreePagerLinkFollowingOutputElement >> onBrContextMenuIsHidden: anEvent [
	anEvent consumed: true.
	self hasLinkModel ifFalse: [ ^ self ].
	self linkModel isRemoved ifFalse: [ ^ self ].
	
	timeAnimationState = #contextMenu ifFalse: [ ^ self ].
	
	timeAnimationState := nil.
	self startAnimation.
]

{ #category : #'private - event handling' }
GtTreePagerLinkFollowingOutputElement >> onBrContextMenuIsVisible: anEvent [
	anEvent consumed: true.
	self hasLinkModel ifFalse: [ ^ self ].
	self linkModel isRemoved ifFalse: [ ^ self ].

	"Let's ensure we do not remove the removed link."
	timeAnimationState := #contextMenu.
	self stopAnimation.
	self geometry: self newAboutToBeRemovedGeometry.
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
		
	timeAnimationState := nil
]

{ #category : #'private - event handling' }
GtTreePagerLinkFollowingOutputElement >> onGtTreePagerLinkModelStateChanged: anAnnouncement [
	self hasLinkModel ifFalse: [ ^ self ].
	anAnnouncement linkModel = self linkModel ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'private - event handling' }
GtTreePagerLinkFollowingOutputElement >> onHovered [
	self hasLinkModel ifFalse: [ ^ self ].
	self linkModel isRemoved ifFalse: [ ^ self ].
	
	"Context menu reason, have priority."
	timeAnimationState = #contextMenu ifTrue: [ ^ self ].

	"Let's ensure we do not remove the removed link."
	timeAnimationState := #hovered.
	self stopAnimation.
	self geometry: self newAboutToBeRemovedGeometry.
]

{ #category : #'api - link model' }
GtTreePagerLinkFollowingOutputElement >> onLinkModelChanged [
	self updateElement
]

{ #category : #'private - event handling' }
GtTreePagerLinkFollowingOutputElement >> onUnhovered [
	self hasLinkModel ifFalse: [ ^ self ].
	self linkModel isRemoved ifFalse: [ ^ self ].
	
	"Context menu reason, have priority."
	timeAnimationState = #contextMenu ifTrue: [ ^ self ].
	
	timeAnimationState := nil.
	self startAnimation.
]

{ #category : #'accessing - ui' }
GtTreePagerLinkFollowingOutputElement >> outgoingLinkElements [
	^ self hasLinkModel ifTrue: [ Array with: self ] ifFalse: [ Array empty ]
]

{ #category : #animations }
GtTreePagerLinkFollowingOutputElement >> startAnimation [
	timeAnimation ifNotNil: [ ^ self ].

	GtTreePagerAnimationFeatures
		ifEnabled: [ 
			timeAnimation := self newAnimation.
			self addAnimation: timeAnimation ]
		ifDisabled: [  ]
]

{ #category : #animations }
GtTreePagerLinkFollowingOutputElement >> stopAnimation [
	timeAnimation ifNotNil: [ :anAnimation | anAnimation stopIfRunning ].
	timeAnimation := nil
]

{ #category : #'api - link model' }
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

{ #category : #'api - link model' }
GtTreePagerLinkFollowingOutputElement >> unsubscribeFromLinkModel [
	self linkModel unsubscribe: self
]

{ #category : #'private - updating' }
GtTreePagerLinkFollowingOutputElement >> updateElement [
	self hasLinkModel ifFalse: [ ^ self ].
	
	"Reset animation"
	self stopAnimation.
	timeAnimationState := nil.
	
	"Selection state is used to define active links"
	self linkModel isActive
		ifTrue: [ self states addState: BlElementState selected ]
		ifFalse: [ self states removeState: BlElementState selected ].

	"Update element acording to its link state"
	GtTreePagerLinkFollowingOutputElementUpdater new
		linkModel: self linkModel;
		linkElement: self;
		update
]
