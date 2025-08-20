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
GtTreePagerLinkFollowingRectangleElement >> newContextMenu [
	"Note: can be removed."

	| aMenu anActionItem |
	aMenu := BrMenuItems new.

	anActionItem := BrMenuActionItem new
			id: #'tree-pager--menu--expand';
			label: 'Expand' preview: [ self linkModel isInHiddenLink 
				ifFalse: [ self linkModel title ]
				ifTrue: [ 'Expand top link first' ] ];
			action: [ :anElement :aButtonModel :anEvent | self linkModel expand ];
			disableIf: [ :aMenuItem | self linkModel isInHiddenLink ];
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
	"Note: can be removed."

	anEvent consumed: true.
	self linkModel ifNil: [ ^ self ].

	self linkModel expand
]
