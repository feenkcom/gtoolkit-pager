Class {
	#name : #GtTreePagerModelSelectionStateHandlerChanged,
	#superclass : #GtTreePagerModelSettingsAnnouncement,
	#instVars : [
		'selectionStateHandler'
	],
	#category : #'GToolkit-TreePager-Announcements'
}

{ #category : #accessing }
GtTreePagerModelSelectionStateHandlerChanged >> selectionStateHandler [
	^ selectionStateHandler
]

{ #category : #accessing }
GtTreePagerModelSelectionStateHandlerChanged >> selectionStateHandler: anObject [
	selectionStateHandler := anObject
]
