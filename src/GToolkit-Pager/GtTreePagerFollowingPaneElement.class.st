Class {
	#name : #GtTreePagerFollowingPaneElement,
	#superclass : #GtTreePagerPaneBasicElement,
	#instVars : [
		'collapsedToolsElement'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #initialization }
GtTreePagerFollowingPaneElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtTreePagerFollowingPaneElement >> initialize [
	super initialize.

	self
		exact: 16 @ 32;
		geometry: (BlPolygonGeometry
				vertices: {0 @ 0.
						16 @ 16.
						0 @ 32});
		aptitude: BrGlamorousFadedButtonExteriourAptitude;
		visibility: BlVisibility visible;
		constraintsDo: [ :c | 
			c linear horizontal alignRight.
			c linear vertical alignCenter ];
		margin: (BlInsets all: 2);
		when: BlClickEvent do: [ :anEvent | self onClickEvent: anEvent ]
]

{ #category : #'private - event management' }
GtTreePagerFollowingPaneElement >> onClickEvent: anEvent [
	| aToolModel |
	self visibility isVisible ifFalse: [ ^ self ].
	anEvent consumed: true.

	aToolModel := self viewModel firstExpandedToolModel.
	aToolModel ifNil: [ ^ self ].
	self fireEvent: (GtTreePagerSpawnToolEvent new toolModel: aToolModel)
]

{ #category : #accessing }
GtTreePagerFollowingPaneElement >> onPaneModelChanged [
	self visibility: BlVisibility visible
]
