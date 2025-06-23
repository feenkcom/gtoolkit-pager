Class {
	#name : #GtTreePagerPaneFollowingCollapsedElement,
	#superclass : #GtTreePagerPaneBasicElement,
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #initialization }
GtTreePagerPaneFollowingCollapsedElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtTreePagerPaneFollowingCollapsedElement >> initialize [
	super initialize.

	self
		exact: 16 @ 16;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 4);
		outskirts: BlOutskirts inside;
		constraintsDo: [ :c | 
			c linear horizontal alignRight.
			c linear vertical alignCenter ];
		margin: (BlInsets all: 2);
		when: BlClickEvent do: [ :anEvent | self onClickEvent: anEvent ];
		addAptitude: (BrGlamorousWithExplicitContextMenuAptitude new
				handleSubmenu: [ self newContextMenu ]);
		addAptitude: (BrLazyStyleCommonAptitude new
				default: [ :aStyle | 
					aStyle background: self theme button defaultBackground.
					aStyle border: self theme button fadedBackgroundColor ];
				hovered: [ :aStyle | 
					aStyle background: self theme button focusedFadedBackgroundColor.
					aStyle border: self theme button focusedFadedBackgroundColor ])
]

{ #category : #initialization }
GtTreePagerPaneFollowingCollapsedElement >> onClickEvent: anEvent [
	self paneModel ifNil: [ ^ self ].

	anEvent consumed: true.
	self paneModel expand
]
