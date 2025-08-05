Class {
	#name : #GtTreePagerConstants,
	#superclass : #Object,
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #constants }
GtTreePagerConstants class >> cellSpacing [
	^ 10
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
GtTreePagerConstants class >> leftShift [
	^ self triangleWidth - (self rectangleLength // 2)
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
GtTreePagerConstants class >> triangleHeight [
	^ 32
]

{ #category : #constants }
GtTreePagerConstants class >> triangleWidth [
	^ 12
]
