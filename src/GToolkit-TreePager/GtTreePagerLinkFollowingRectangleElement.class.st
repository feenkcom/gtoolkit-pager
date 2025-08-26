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
		outskirts: BlOutskirts inside;
		constraintsDo: [ :c | 
			c linear horizontal alignRight.
			c linear vertical alignCenter ];
		addAptitude: (BrLazyStyleCommonAptitude new
				default: [ :aStyle | 
					aStyle background: self theme default backdropEmphasisBackground.
					aStyle border: self theme default backdropEmphasisBackground ];
				hovered: [ :aStyle | 
					aStyle background: self theme button focusedFadedBackgroundColor.
					aStyle border: self theme button focusedFadedBackgroundColor ])
]

{ #category : #initialization }
GtTreePagerLinkFollowingRectangleElement >> onClickEvent: anEvent [
	"Note: can be removed."

	anEvent consumed: true.
	self linkModel ifNil: [ ^ self ].

	self linkModel expand
]
