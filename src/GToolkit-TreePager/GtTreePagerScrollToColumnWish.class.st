Class {
	#name : #GtTreePagerScrollToColumnWish,
	#superclass : #BrWish,
	#instVars : [
		'column'
	],
	#category : #'GToolkit-TreePager-Events'
}

{ #category : #accessing }
GtTreePagerScrollToColumnWish >> column [
	^ column
]

{ #category : #accessing }
GtTreePagerScrollToColumnWish >> column: anObject [
	column := anObject
]
