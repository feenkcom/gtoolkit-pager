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
	"Space used between pane elements.
	Note: In order to make pane toolbar corner buttons accessible from all mouse directions,
	we simulate empty space around panes using paddings in:
	- GtTreePagerPaneElement>>#initialize, and
	- GtTreePagerElement>>#initialize."

	^ 4
]

{ #category : #constants }
GtTreePagerConstants class >> leftShift [
	"^ self triangleWidth - (self rectangleLength // 2)"
	^ 0
]

{ #category : #constants }
GtTreePagerConstants class >> outputLenght [
	"I define lenght of ougoing links from collapsed link elements"

	^ 1
]

{ #category : #constants }
GtTreePagerConstants class >> previewCellSpacing [
	^ 2
]

{ #category : #constants }
GtTreePagerConstants class >> previewHeight [
	"Height of the pane previews container."

	^ 16
]

{ #category : #constants }
GtTreePagerConstants class >> previewScrollbarHeight [
	"Height of the pane previews scrollbar."

	^ 4
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
	"Space used between pane elements
	Note: In order to make pane toolbar corner buttons accessible from all mouse directions,
	we simulate empty space around panes using paddings in:
	- GtTreePagerPaneElement>>#initialize, and
	- GtTreePagerElement>>#initialize."

	^ 4
]
