Class {
	#name : #GtTreePagerLinkFollowingRotatedCollapsedElement,
	#superclass : #GtTreePagerLinkBasicElement,
	#instVars : [
		'rectangleElement',
		'rightOutputsElement',
		'bottomOutputsElement'
	],
	#category : #'GToolkit-TreePager-UI'
}

{ #category : #initialization }
GtTreePagerLinkFollowingRotatedCollapsedElement >> defaultLayout [
	^ BlFrameLayout new
]

{ #category : #'accessing - ui' }
GtTreePagerLinkFollowingRotatedCollapsedElement >> incomingLinkElements [
	^ Array empty
]

{ #category : #initialization }
GtTreePagerLinkFollowingRotatedCollapsedElement >> initialize [
	super initialize.

	self hExact: GtTreePagerConstants rectangleLengthWithoutSpacing.
	self vMatchParent.

	self initializeRectangleElement.
	self initializeRightOutputsElement.
	self initializeBottomOutputsElement.
	
	self
		addChildren: {rightOutputsElement.
				bottomOutputsElement.
				rectangleElement}.

	self initializeOutgoingLinkElementsStyling
]

{ #category : #initialization }
GtTreePagerLinkFollowingRotatedCollapsedElement >> initializeBottomOutputsElement [
	bottomOutputsElement := BrVerticalPane new
			id: #'link--bottom-outputs';
			fitContent;
			constraintsDo: [ :c | 
				c frame horizontal alignRight.
				c frame vertical alignCenter ]
]

{ #category : #initialization }
GtTreePagerLinkFollowingRotatedCollapsedElement >> initializeOutgoingLinkElementsStyling [
	self
		addAptitude: (BrLazyStyleCommonAptitude new
				hovered: [ :aStyle | 
					aStyle
						do: [ :aWidget | 
							aWidget outgoingLinkElements
								do: [ :anElement | anElement states addState: BlElementState hovered ] ]
						after: [ :aWidget | 
							aWidget outgoingLinkElements
								do: [ :anElement | anElement states removeState: BlElementState hovered ] ] ])
]

{ #category : #initialization }
GtTreePagerLinkFollowingRotatedCollapsedElement >> initializeRectangleElement [
	rectangleElement := GtTreePagerLinkFollowingRectangleElement new
]

{ #category : #initialization }
GtTreePagerLinkFollowingRotatedCollapsedElement >> initializeRightOutputsElement [
	rightOutputsElement := BrHorizontalPane new
			id: #'link--right-outputs';
			fitContent;
			constraintsDo: [ :c | 
				c frame horizontal alignCenter.
				c frame vertical alignTop ]
]

{ #category : #'private - updating' }
GtTreePagerLinkFollowingRotatedCollapsedElement >> newOutputElementForLinkModel: aLinkModel [
	^ GtTreePagerLinkCollapsedOutgoingLinkElement new linkModel: aLinkModel
]

{ #category : #'private - event handling' }
GtTreePagerLinkFollowingRotatedCollapsedElement >> onGtTreePagerPaneModelFollowingLinksChanged: anAnnouncement [
]

{ #category : #'api - link model' }
GtTreePagerLinkFollowingRotatedCollapsedElement >> onLinkModelChanged [
	rectangleElement linkModel: self linkModel.
	self updateElement
]

{ #category : #'accessing - ui' }
GtTreePagerLinkFollowingRotatedCollapsedElement >> outgoingLinkElements [
	^ (rightOutputsElement children flatCollect: #outgoingLinkElements)
		, (bottomOutputsElement children flatCollect: #outgoingLinkElements)
]

{ #category : #'api - link model' }
GtTreePagerLinkFollowingRotatedCollapsedElement >> subscribeToLinkModel [
	super subscribeToLinkModel.

	self linkModel announcer weak
		when: GtTreePagerPaneModelFollowingLinksChanged
		send: #onGtTreePagerPaneModelFollowingLinksChanged:
		to: self
]

{ #category : #'api - link model' }
GtTreePagerLinkFollowingRotatedCollapsedElement >> unsubscribeFromLinkModel [
	super unsubscribeFromLinkModel.

	self linkModel announcer unsubscribe: self
]

{ #category : #'private - updating' }
GtTreePagerLinkFollowingRotatedCollapsedElement >> updateElement [
	self updateRectangleElement.
	self updateOutputElements
]

{ #category : #'private - updating' }
GtTreePagerLinkFollowingRotatedCollapsedElement >> updateOutputElements [
	| someElements |
	someElements := self linkModel followingLinks
			collect: [ :eachLink | self newOutputElementForLinkModel: eachLink ]
			as: Array.

	rightOutputsElement
		removeChildren;
		addChildren: (someElements select: [ :each | each linkModel isSpawned ]).

	bottomOutputsElement
		removeChildren;
		addChildren: (someElements select: [ :each | each linkModel isSpawned not ])
]

{ #category : #'private - updating' }
GtTreePagerLinkFollowingRotatedCollapsedElement >> updateRectangleElement [
	
]
