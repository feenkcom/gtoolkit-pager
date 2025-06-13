Class {
	#name : #GtMultiPagerFollowingPaneElement,
	#superclass : #GtMultiPagerPaneBasicElement,
	#instVars : [
		'collapsedToolsElement'
	],
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #initialization }
GtMultiPagerFollowingPaneElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtMultiPagerFollowingPaneElement >> initialize [
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
GtMultiPagerFollowingPaneElement >> initializeCollapsedToolsElement [
	collapsedToolsElement := GtMultiPagerCollapsedPanesElement new
			visibility: BlVisibility gone;
			constraintsDo: [ :c | 
				c linear horizontal alignCenter.
				c linear vertical alignCenter ]
]

{ #category : #'private - event management' }
GtMultiPagerFollowingPaneElement >> onClickEvent: anEvent [
	| aToolModel |
	self visibility isVisible ifFalse: [ ^ self ].
	anEvent consumed: true.

	aToolModel := self viewModel firstExpandedToolModel.
	aToolModel ifNil: [ ^ self ].
	self fireEvent: (GtMultiPagerSpawnToolEvent new toolModel: aToolModel)
]

{ #category : #accessing }
GtMultiPagerFollowingPaneElement >> onToolModelChanged [
	collapsedToolsElement toolModel: self toolModel.

	self toolModel isCollapsed
		ifTrue: [ collapsedToolsElement visibility: BlVisibility visible ]
		ifFalse: [ collapsedToolsElement visibility: BlVisibility gone ].

	self visibility: BlVisibility visible
]
