Class {
	#name : #GtTreePagerLinkFollowingOutputElement,
	#superclass : #GtTreePagerLinkBasicElement,
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
		constraintsDo: [ :c | 
			c linear horizontal alignRight.
			c linear vertical alignCenter ];
		outskirts: BlOutskirts centered;
		when: BlClickEvent do: [ :anEvent | self onClickEvent: anEvent ];
		addAptitude: (GtTreePagerGeometryCountdownAptitude new
				withContextMenuEventHandlers;
				finishedAction: [ self onRemovalCountdownFinished ]);
		addAptitude: (BrGlamorousWithExplicitContextMenuAptitude new
				handleSubmenu: [ self newContextMenu ]).

	self initializeElementStyling.
	self initializeOutgoingLinkElements
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
GtTreePagerLinkFollowingOutputElement >> newContextMenu [
	| aMenuItems |
	self hasLinkModel ifFalse: [ ^ nil ].

	aMenuItems := BrMenuItems new.
	GtTreePagerLinkTarget
		actionsForObject: self linkModel
		collect: [ :eachAction | 
			eachAction
				asMenuItem: [ :aMenuItem | aMenuItems addItem: aMenuItem ]
				withHostElement: self ].

	^ aMenuItems
]

{ #category : #'private - event handling' }
GtTreePagerLinkFollowingOutputElement >> onClickEvent: anEvent [
	self visibility isVisible ifFalse: [ ^ self ].
	self hasLinkModel ifFalse: [ ^ self ].
	anEvent consumed: true.
	
	self dispatchEvent: BrCountdownDisableAndStopWish withoutFinishedAction.
	
	GtTreePagerLinkFollowingOutputClickResolver new 
		element: self;
		linkModel: self linkModel;
		resolve.
]

{ #category : #'private - event handling' }
GtTreePagerLinkFollowingOutputElement >> onGtTreePagerLinkModelStateChanged: anAnnouncement [
	self hasLinkModel ifFalse: [ ^ self ].
	anAnnouncement linkModel = self linkModel ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'api - link model' }
GtTreePagerLinkFollowingOutputElement >> onLinkModelChanged [
	self updateElement
]

{ #category : #'private - event handling' }
GtTreePagerLinkFollowingOutputElement >> onRemovalCountdownFinished [
	self hasLinkModel ifFalse: [ ^ self ].
	self linkModel removeFromPreviousPane
]

{ #category : #'accessing - ui' }
GtTreePagerLinkFollowingOutputElement >> outgoingLinkElements [
	^ self hasLinkModel ifTrue: [ Array with: self ] ifFalse: [ Array empty ]
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
	
	"Disable animation"
	self dispatchEvent: BrCountdownDisableAndStopWish withoutFinishedAction.
	
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
