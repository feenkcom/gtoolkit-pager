Class {
	#name : #GtTreePagerLinkReplacedElement,
	#superclass : #GtTreePagerLinkBasicElement,
	#instVars : [
		'timeAnimation',
		'timeAnimationState'
	],
	#category : #'GToolkit-TreePager-UI'
}

{ #category : #initialization }
GtTreePagerLinkReplacedElement >> initialize [
	super initialize.

	self
		exact: GtTreePagerConstants rectangleLengthWithoutSpacing @ GtTreePagerConstants rectangleLengthWithoutSpacing;
		geometry: self newGeometry;
		when: BlClickEvent do: [ :anEvent | self onClickEvent: anEvent ].

	self
		addAptitude: (BrLazyStyleCommonAptitude new
				default: [ :aStyle | aStyle background: self theme default backdropEmphasisBackground ];
				hovered: [ :aStyle | 
					aStyle
						background: self theme button focusedFadedBackgroundColor;
						do: [ :aWidget | self onHovered ] after: [ :aWidget | self onUnhovered ] ]).

	self
		addAptitude: (BrGlamorousWithExplicitContextMenuAptitude
				menu: [ self newReplacedLinkContextMenu ])
]

{ #category : #initialization }
GtTreePagerLinkReplacedElement >> newAnimation [
	^ BlNumberTransition new
		onStepDo: [ :eachOffset | 
			self
				geometry: (self geometry
						startAngle: eachOffset;
						endAngle: 270) ];
		from: -90;
		to: 270;
		by: 6;
		duration: GtTreePagerConstants replacedLinkRestoration;
		onFinishedDo: [ self onAnimationFinished ]
]

{ #category : #initialization }
GtTreePagerLinkReplacedElement >> newGeometry [
	^ BlAnnulusSectorGeometry new
		startAngle: -90;
		endAngle: 270;
		innerRadius: 0
]

{ #category : #initialization }
GtTreePagerLinkReplacedElement >> newReplacedLinkContextMenu [
	| aReplacedLink |
	self hasLinkModel ifFalse: [ ^ nil ].
	aReplacedLink := self linkModel replacedLink ifNil: [ ^ nil ].

	^ BrMenuItems new
		addItemId: #'tree-pager--restore-link'
			icon: BrGlamorousVectorIcons add
			label: 'Restore'
			preview: [ aReplacedLink title ]
			action: [ :aButton | self onRestoreReplacedLinkClick: aButton ];
		addItemId: #'tree-pager--remove-link'
			icon: BrGlamorousVectorIcons remove
			label: 'Remove'
			preview: [ aReplacedLink title ]
			action: [ :aButton | self onRemoveReplacedLinkClick: aButton ]
]

{ #category : #'private - event handling' }
GtTreePagerLinkReplacedElement >> onAnimationFinished [
	timeAnimation := nil.
	self geometry: self newGeometry.
	timeAnimationState = #paused ifTrue: [ ^ self ].

	self visibility: BlVisibility gone.
	self hasLinkModel ifFalse: [ ^ self ].
	self linkModel replacedLink: nil
]

{ #category : #'private - event handling' }
GtTreePagerLinkReplacedElement >> onClickEvent: anEvent [
	self visibility isVisible ifFalse: [ ^ self ].
	self hasLinkModel ifFalse: [ ^ self ].
	self linkModel replacedLink ifNil: [ ^ self ].
	anEvent consumed: true.

	self linkModel restoreReplacedLink.
	
	timeAnimationState := nil.
	self visibility: BlVisibility gone.
]

{ #category : #'private - event handling' }
GtTreePagerLinkReplacedElement >> onHovered [
	self hasLinkModel ifFalse: [ ^ self ].
	self linkModel replacedLink ifNil: [ ^ self ].

	timeAnimationState := #paused.
	self stopAnimation
]

{ #category : #'api - link model' }
GtTreePagerLinkReplacedElement >> onLinkModelChanged [
	super onLinkModelChanged.
	self stopAnimation.
	self updateElement
]

{ #category : #'private - event handling' }
GtTreePagerLinkReplacedElement >> onRemoveReplacedLinkClick: aButton [
	self hasLinkModel ifFalse: [ ^ self ].
	self linkModel replacedLink: nil.
	
	timeAnimationState := nil.
	self stopAnimation.
	self visibility: BlVisibility gone.
]

{ #category : #'private - event handling' }
GtTreePagerLinkReplacedElement >> onRestoreReplacedLinkClick: aButton [
	self hasLinkModel ifFalse: [ ^ self ].
	self linkModel restoreReplacedLink.
	self linkModel replacedLink: nil.

	timeAnimationState := nil.
	self stopAnimation.
	self visibility: BlVisibility gone
]

{ #category : #'private - event handling' }
GtTreePagerLinkReplacedElement >> onUnhovered [
	self hasLinkModel ifFalse: [ ^ self ].
	self linkModel replacedLink ifNil: [ ^ self ].

	timeAnimationState := nil.
	self startAnimation.
]

{ #category : #animation }
GtTreePagerLinkReplacedElement >> startAnimation [
	timeAnimation ifNotNil: [ ^ self ].
	timeAnimation ifNotNil: [ ^ self ].

	GtTreePagerAnimationFeatures
		ifEnabled: [ timeAnimation := self newAnimation.
			self addAnimation: timeAnimation ]
		ifDisabled: [  ]
]

{ #category : #animation }
GtTreePagerLinkReplacedElement >> stopAnimation [
	timeAnimation ifNotNil: [ :anAnimation | anAnimation stopIfRunning ].
	timeAnimation := nil
]

{ #category : #'private - updating' }
GtTreePagerLinkReplacedElement >> updateElement [
	self hasLinkModel ifFalse: [ ^ self ].

	self linkModel replacedLink
		ifNil: [ 
			self visibility: BlVisibility gone ]
		ifNotNil: [ 
			self visibility: BlVisibility visible.
			self startAnimation ]
]
