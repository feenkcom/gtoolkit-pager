Class {
	#name : #GtTreePagerPaneFollowingCollapsedElement,
	#superclass : #GtTreePagerPaneBasicElement,
	#instVars : [
		'rectangleElement',
		'trianglesElement'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #initialization }
GtTreePagerPaneFollowingCollapsedElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtTreePagerPaneFollowingCollapsedElement >> defaultSize [
	^ 16 @ 16
]

{ #category : #initialization }
GtTreePagerPaneFollowingCollapsedElement >> initialize [
	super initialize.

	self exact: self defaultSize.

	self initializeRectangleElement.
	self initializeTrianglesElement.

	self
		addChildren: {rectangleElement.
				trianglesElement}
]

{ #category : #initialization }
GtTreePagerPaneFollowingCollapsedElement >> initializeRectangleElement [
	rectangleElement := GtTreePagerPaneFollowingRectangleElement new matchParent
]

{ #category : #initialization }
GtTreePagerPaneFollowingCollapsedElement >> initializeTrianglesElement [
	trianglesElement := BrVerticalPane new fitContent
]

{ #category : #'private - updating' }
GtTreePagerPaneFollowingCollapsedElement >> newTriangleElementForPaneModel: aPaneModel [
	| anElement |
	anElement := GtTreePagerPaneFollowingTriangleElement new
			beSmallSize;
			paneModel: aPaneModel.

	^ anElement
]

{ #category : #'api - pane model' }
GtTreePagerPaneFollowingCollapsedElement >> onPaneModelChanged [
	rectangleElement paneModel: self paneModel.
	self updateElement
]

{ #category : #'private - updating' }
GtTreePagerPaneFollowingCollapsedElement >> updateElement [
	self paneModel followingPanes size isZero
		ifTrue: [ self exact: self defaultSize ]
		ifFalse: [ self fitContent ].

	self updateRectangleElement.
	self updateTrianglesElement
]

{ #category : #'private - updating' }
GtTreePagerPaneFollowingCollapsedElement >> updateRectangleElement [
	self paneModel followingPanes size isZero
		ifTrue: [ rectangleElement matchParent ]
		ifFalse: [ rectangleElement
				hExact: 8;
				vMatchParent ]
]

{ #category : #'private - updating' }
GtTreePagerPaneFollowingCollapsedElement >> updateTrianglesElement [
	| someElements |
	someElements := (self paneModel followingPanes
			sorted: [ :a :b | 
				a isCollapsed
					ifTrue: [ true ]
					ifFalse: [ b isCollapsed ifTrue: [ false ] ifFalse: [ true ] ] ])
			collect: [ :eachPane | self newTriangleElementForPaneModel: eachPane ]
			as: Array.

	trianglesElement
		removeChildren;
		addChildren: someElements
]
