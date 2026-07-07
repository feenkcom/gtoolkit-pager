Class {
	#name : #GtTreePagerModelChanged,
	#superclass : #BlEvent,
	#instVars : [
		'pagerModel'
	],
	#category : #'GToolkit-TreePager-Events'
}

{ #category : #accessing }
GtTreePagerModelChanged >> pagerModel [
	^ pagerModel
]

{ #category : #accessing }
GtTreePagerModelChanged >> pagerModel: anObject [
	pagerModel := anObject
]

{ #category : #sending }
GtTreePagerModelChanged >> sendTo: anObject [
	^ anObject treePagerModelChanged: self
]
