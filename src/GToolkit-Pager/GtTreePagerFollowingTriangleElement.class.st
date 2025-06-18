Class {
	#name : #GtTreePagerFollowingTriangleElement,
	#superclass : #GtTreePagerPaneBasicElement,
	#instVars : [
		'collapsedToolsElement'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #initialization }
GtTreePagerFollowingTriangleElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtTreePagerFollowingTriangleElement >> initialize [
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
GtTreePagerFollowingTriangleElement >> onClickEvent: anEvent [
	| aToolModel |
	self visibility isVisible ifFalse: [ ^ self ].
	self paneModel ifNil: [ ^ self ].
	anEvent consumed: true.

	aToolModel := self paneModel expand
]

{ #category : #'api - pane model' }
GtTreePagerFollowingTriangleElement >> onPaneModelChanged [
	self visibility: BlVisibility visible
]
