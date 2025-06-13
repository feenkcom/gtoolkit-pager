Class {
	#name : #GtMultiPagerFollowingToolElement,
	#superclass : #GtMultiPagerToolBasicElement,
	#instVars : [
		'collapsedToolsElement'
	],
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #initialization }
GtMultiPagerFollowingToolElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtMultiPagerFollowingToolElement >> initialize [
	super initialize.

	self
		exact: 16 @ 32;
		geometry: (BlPolygonGeometry
				vertices: {0 @ 0.
						16 @ 16.
						0 @ 32});
		aptitude: BrGlamorousFadedButtonExteriourAptitude;
		visibility: BlVisibility hidden;
		constraintsDo: [ :c | 
			c linear horizontal alignRight.
			c linear vertical alignCenter ];
		margin: (BlInsets all: 2);
		when: BlClickEvent do: [ :anEvent | self onClickEvent: anEvent ].

	self initializeCollapsedToolsElement.
	self addChild: collapsedToolsElement as: #collapsed
]

{ #category : #initialization }
GtMultiPagerFollowingToolElement >> initializeCollapsedToolsElement [
	collapsedToolsElement := GtMultiPagerCollapsedToolsElement new
			visibility: BlVisibility gone;
			constraintsDo: [ :c | 
				c linear horizontal alignCenter.
				c linear vertical alignCenter ]
]

{ #category : #'private - event management' }
GtMultiPagerFollowingToolElement >> onClickEvent: anEvent [
	| aToolModel |
	self visibility isVisible ifFalse: [ ^ self ].
	anEvent consumed: true.

	aToolModel := self viewModel firstExpandedToolModel.
	aToolModel ifNil: [ ^ self ].
	self fireEvent: (GtMultiPagerSpawnToolEvent new toolModel: aToolModel)
]

{ #category : #accessing }
GtMultiPagerFollowingToolElement >> onToolModelChanged [
	collapsedToolsElement toolModel: self toolModel.

	self toolModel isCollapsed
		ifTrue: [ collapsedToolsElement visibility: BlVisibility visible ]
		ifFalse: [ collapsedToolsElement visibility: BlVisibility gone ].

	self visibility: BlVisibility visible
]
