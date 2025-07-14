Class {
	#name : #GtTreePagerModelColumnHeightChanged,
	#superclass : #GtTreePagerModelSettingsAnnouncement,
	#instVars : [
		'columnHeight'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #accessing }
GtTreePagerModelColumnHeightChanged >> columnHeight [
	^ columnHeight
]

{ #category : #accessing }
GtTreePagerModelColumnHeightChanged >> columnHeight: anObject [
	columnHeight := anObject
]
