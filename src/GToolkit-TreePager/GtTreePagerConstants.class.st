Class {
	#name : #GtTreePagerConstants,
	#superclass : #Object,
	#category : #'GToolkit-TreePager-Settings'
}

{ #category : #constants }
GtTreePagerConstants class >> cellSpacing [
	"Space used between pane elements"

	^ self horizontalCellSpacing @ self verticalCellSpacing
]

{ #category : #constants }
GtTreePagerConstants class >> cornerButtonSize [
	^ 20 @ 20
]

{ #category : #constants }
GtTreePagerConstants class >> edgeCornerRadius [
	^ 2
]

{ #category : #constants }
GtTreePagerConstants class >> edgeFixedDistance [
	^ 8
]

{ #category : #constants }
GtTreePagerConstants class >> horizontalCellSpacing [
	"Space used between pane elements"

	^ 10
]

{ #category : #constants }
GtTreePagerConstants class >> leftShift [
	"^ self triangleWidth - (self rectangleLength // 2)"
	^ 0
]

{ #category : #constants }
GtTreePagerConstants class >> outputLenght [
	^ 1
]

{ #category : #constants }
GtTreePagerConstants class >> previewCellSpacing [
	^ 2
]

{ #category : #constants }
GtTreePagerConstants class >> rectangleLength [
	^ 16
]

{ #category : #constants }
GtTreePagerConstants class >> rectangleLengthWithoutSpacing [
	^ self rectangleLength - (self previewCellSpacing * 2)
]

{ #category : #constants }
GtTreePagerConstants class >> replacedLinkRestoration [
	"The time for which a replaced link remains accessible to a user for its restoration"

	^ 12 seconds
]

{ #category : #constants }
GtTreePagerConstants class >> triangleHeight [
	^ 32
]

{ #category : #constants }
GtTreePagerConstants class >> triangleWidth [
	^ 12
]

{ #category : #constants }
GtTreePagerConstants class >> verticalCellSpacing [
	"Space used between pane elements"

	^ 20
]
