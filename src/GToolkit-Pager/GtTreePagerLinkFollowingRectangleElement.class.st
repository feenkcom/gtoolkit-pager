Class {
	#name : #GtTreePagerLinkFollowingRectangleElement,
	#superclass : #GtTreePagerLinkBasicElement,
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #initialization }
GtTreePagerLinkFollowingRectangleElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtTreePagerLinkFollowingRectangleElement >> initialize [
	super initialize.

	self
		exact: GtTreePagerConstants rectangleLength @ GtTreePagerConstants rectangleLength;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 2);
		outskirts: BlOutskirts inside;
		constraintsDo: [ :c | 
			c linear horizontal alignRight.
			c linear vertical alignCenter ];
		when: BlClickEvent do: [ :anEvent | self onClickEvent: anEvent ];
		addAptitude: (BrGlamorousWithExplicitContextMenuAptitude new
				handleSubmenu: [ self newContextMenu ]);
		addAptitude: (BrLazyStyleCommonAptitude new
				default: [ :aStyle | 
					aStyle background: self theme button fadedBackgroundColor.
					aStyle border: self theme button fadedBackgroundColor ];
				hovered: [ :aStyle | 
					aStyle background: self theme button focusedFadedBackgroundColor.
					aStyle border: self theme button focusedFadedBackgroundColor ])
]

{ #category : #initialization }
GtTreePagerLinkFollowingRectangleElement >> newContextMenu [
	| aMenu anActionItem |
	aMenu := BrMenuItems new.

	anActionItem := BrMenuActionItem new
			id: #'menu--expand-pane';
			label: 'Expand' preview: [ self linkModel title ];
			action: [ :anElement :aButtonModel :anEvent | self linkModel expand ];
			yourself.
	aMenu addItem: anActionItem.

	anActionItem := BrMenuActionItem new
			id: #'menu--remove-pane';
			label: 'Remove'
				preview: [ '{1}{2}'
						format: {self linkModel title.
								self linkModel allFollowingPanesCount
									ifNotNil: [ :aCount | 
										aCount isZero
											ifTrue: [ '' ]
											ifFalse: [ ' and {1} other {2}'
													format: {aCount.
															'pane' asPluralBasedOn: aCount} ] ]
									ifNil: [ '' ]} ];
			action: [ :anElement :aButtonModel :anEvent | self linkModel removeFromPreviousPane ];
			yourself.
	aMenu addItem: anActionItem.

	^ aMenu
]

{ #category : #initialization }
GtTreePagerLinkFollowingRectangleElement >> onClickEvent: anEvent [
	anEvent consumed: true.
	self linkModel ifNil: [ ^ self ].

	self linkModel expand
]
