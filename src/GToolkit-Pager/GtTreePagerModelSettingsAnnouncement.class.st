Class {
	#name : #GtTreePagerModelSettingsAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'settings'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #accessing }
GtTreePagerModelSettingsAnnouncement >> settings [
	^ settings
]

{ #category : #accessing }
GtTreePagerModelSettingsAnnouncement >> settings: anObject [
	settings := anObject
]
