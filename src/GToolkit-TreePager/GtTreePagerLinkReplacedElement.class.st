Class {
	#name : #GtTreePagerLinkReplacedElement,
	#superclass : #GtTreePagerLinkBasicElement,
	#category : #'GToolkit-TreePager-UI'
}

{ #category : #'private - updating' }
GtTreePagerLinkReplacedElement >> hide [
	^ self visibility: BlVisibility hidden
]

{ #category : #initialization }
GtTreePagerLinkReplacedElement >> initialize [
	super initialize.

	self
		exact: GtTreePagerConstants rectangleLengthWithoutSpacing
				@ GtTreePagerConstants rectangleLengthWithoutSpacing;
		geometry: self newGeometry;
		when: BlClickEvent do: [ :anEvent | self onClickEvent: anEvent ].

	self
		addAptitude: (BrLazyStyleCommonAptitude new
				default: [ :aStyle | 
					aStyle background: self theme default backdropEmphasisBackground ];
				hovered: [ :aStyle | 
					aStyle background: self theme button focusedFadedBackgroundColor ]).

	self
		addAptitude: (BrGlamorousWithExplicitContextMenuAptitude
				menu: [ self newReplacedLinkContextMenu ]).

	self
		addAptitude: (GtTreePagerGeometryCountdownAptitude new
				withContextMenuEventHandlers;
				finishedAction: [ self onRemovalCountdownFinished ])
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
			icon: BrGlamorousVectorIcons bin
			label: 'Remove'
			preview: [ aReplacedLink title ]
			action: [ :aButton | self onRemoveReplacedLinkClick: aButton ]
]

{ #category : #'private - event handling' }
GtTreePagerLinkReplacedElement >> onClickEvent: anEvent [
	self visibility isVisible ifFalse: [ ^ self ].
	self hasLinkModel ifFalse: [ ^ self ].
	self linkModel replacedLink ifNil: [ ^ self ].

	anEvent consumed: true.

	self dispatchEvent: BrCountdownDisableAndStopWish withoutFinishedAction.
	
	self linkModel restoreReplacedLink.

	self hide
]

{ #category : #'api - link model' }
GtTreePagerLinkReplacedElement >> onLinkModelChanged [
	super onLinkModelChanged.
	self updateElement.
]

{ #category : #initialization }
GtTreePagerLinkReplacedElement >> onRemovalCountdownFinished [
	self hide.

	self hasLinkModel ifFalse: [ ^ self ].
	self linkModel removeReplacedLink
]

{ #category : #'private - event handling' }
GtTreePagerLinkReplacedElement >> onRemoveReplacedLinkClick: aButton [
	self hasLinkModel ifFalse: [ ^ self ].
	
	self dispatchEvent: BrCountdownDisableAndStopWish withoutFinishedAction.
	self linkModel removeReplacedLink.
	self hide
]

{ #category : #'private - event handling' }
GtTreePagerLinkReplacedElement >> onRestoreReplacedLinkClick: aButton [
	self hasLinkModel ifFalse: [ ^ self ].
	
	"Let's ensure we do not remove the replaced link."
	self dispatchEvent: BrCountdownDisableAndStopWish withoutFinishedAction.

	self linkModel restoreReplacedLink.
	self hide
]

{ #category : #'private - updating' }
GtTreePagerLinkReplacedElement >> show [
	self visibility: BlVisibility visible
]

{ #category : #'private - updating' }
GtTreePagerLinkReplacedElement >> updateElement [
	self hasLinkModel ifFalse: [ ^ self ].

	"Disable animation"
	self dispatchEvent: BrCountdownDisableAndStopWish withoutFinishedAction.
	
	self linkModel replacedLink
		ifNil: [ 
			self hide ]
		ifNotNil: [ 
			self show.
			self dispatchEvent: BrCountdownEnableAndStartWish withFinishedAction ]
]
