"
I am an ougoing link element from collapsed (non-spawned) link elements.
"
Class {
	#name : #GtTreePagerLinkCollapsedOutgoingLinkElement,
	#superclass : #GtTreePagerLinkBasicElement,
	#category : #'GToolkit-TreePager-UI'
}

{ #category : #initialization }
GtTreePagerLinkCollapsedOutgoingLinkElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #'accessing - ui' }
GtTreePagerLinkCollapsedOutgoingLinkElement >> incomingLinkElements [
	^ Array empty
]

{ #category : #initialization }
GtTreePagerLinkCollapsedOutgoingLinkElement >> initialize [
	super initialize.

	self
		constraintsDo: [ :c | 
			c linear horizontal alignRight.
			c linear vertical alignCenter ];
		geometry: BlRectangleGeometry new;
		background: self theme default backdropEmphasisBackground.

	self initializeOutgoingLinkElements
]

{ #category : #initialization }
GtTreePagerLinkCollapsedOutgoingLinkElement >> initializeOutgoingLinkElements [
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

{ #category : #'api - link model' }
GtTreePagerLinkCollapsedOutgoingLinkElement >> onLinkModelChanged [
	self updateElement
]

{ #category : #'accessing - ui' }
GtTreePagerLinkCollapsedOutgoingLinkElement >> outgoingLinkElements [
	^ self hasLinkModel ifTrue: [ Array with: self ] ifFalse: [ Array empty ]
]

{ #category : #'private - updating' }
GtTreePagerLinkCollapsedOutgoingLinkElement >> updateElement [
	self hasLinkModel ifFalse: [ ^ self ].

	self linkModel isSpawned
		ifTrue: [ 
			self margin: (BlInsets top: 1 bottom: 1).
			self exact: 1 @ GtTreePagerConstants outputLenght ]
		ifFalse: [ 
			self margin: (BlInsets left: 1 right: 1).
			self exact: GtTreePagerConstants outputLenght @ 1 ]
]
