Class {
	#name : #GtTreePagerLinkFollowingRectangleElement,
	#superclass : #GtTreePagerLinkBasicElement,
	#category : #'GToolkit-TreePager-UI'
}

{ #category : #initialization }
GtTreePagerLinkFollowingRectangleElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtTreePagerLinkFollowingRectangleElement >> initialize [
	super initialize.

	self
		matchParent;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 2);
		constraintsDo: [ :c | 
			c linear horizontal alignRight.
			c linear vertical alignCenter ];
		when: BlClickEvent do: [ :anEvent | self onClickEvent: anEvent ];
		addAptitude: (BrLazyStyleCommonAptitude new
				default: [ :aStyle | aStyle background: self theme default backdropEmphasisBackground ];
				hovered: [ :aStyle | aStyle background: self theme button focusedFadedBackgroundColor ]);
		addAptitude: (BrGlamorousWithExplicitContextMenuAptitude new
				handleSubmenu: [ self newContextMenu ]);
		addAptitude: (GtTreePagerGeometryCountdownAptitude new
				withContextMenuEventHandlers;
				finishedAction: [ self onRemovalCountdownFinished ])
]

{ #category : #'private - updating' }
GtTreePagerLinkFollowingRectangleElement >> newContextMenu [
	self hasLinkModel ifFalse: [ ^ nil ].

	^ GtTreePagerLinkContextMenuBuilder new
		linkModel: self linkModel;
		build
]

{ #category : #initialization }
GtTreePagerLinkFollowingRectangleElement >> onClickEvent: anEvent [
	"Note: can be removed."

	anEvent consumed: true.
	self dispatchEvent: BrCountdownDisableAndStopWish new.
	self hasLinkModel ifFalse: [ ^ self ].

	self linkModel expand
]

{ #category : #'api - link model' }
GtTreePagerLinkFollowingRectangleElement >> onLinkModelChanged [
	super onLinkModelChanged.
	self updateElement
]

{ #category : #'private - event handling' }
GtTreePagerLinkFollowingRectangleElement >> onRemovalCountdownFinished [
	self hasLinkModel ifFalse: [ ^ self ].
	self linkModel removeFromPreviousPane
]

{ #category : #'private - updating' }
GtTreePagerLinkFollowingRectangleElement >> updateElement [
	self hasLinkModel ifFalse: [ ^ self ].
	self dispatchEvent: BrCountdownDisableAndStopWish new.
	self linkModel isRemoved
		ifTrue: [ self updateRemovedElement ]
		ifFalse: [ self updateRegularElement ]
]

{ #category : #'private - updating' }
GtTreePagerLinkFollowingRectangleElement >> updateRegularElement [
	self dispatchEvent: BrCountdownDisableAndStopWish new.
	self geometry: (BlRoundedRectangleGeometry cornerRadius: 2)
]

{ #category : #'private - updating' }
GtTreePagerLinkFollowingRectangleElement >> updateRemovedElement [
	self dispatchEvent: BrCountdownEnableAndStartWish new
]
