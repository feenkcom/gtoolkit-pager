Class {
	#name : #GtTreePagerModelColumnHeightChanged,
	#superclass : #GtTreePagerModelSettingsAnnouncement,
	#instVars : [
		'columnHeight'
	],
	#category : #'GToolkit-TreePager-Announcements'
}

{ #category : #accessing }
GtTreePagerModelColumnHeightChanged >> columnHeight [
	^ columnHeight
]

{ #category : #accessing }
GtTreePagerModelColumnHeightChanged >> columnHeight: anObject [
	columnHeight := anObject
]
