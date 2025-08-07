Class {
	#name : #GtTreePagerModelSettingsAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'settings'
	],
	#category : #'GToolkit-TreePager-Announcements'
}

{ #category : #accessing }
GtTreePagerModelSettingsAnnouncement >> settings [
	^ settings
]

{ #category : #accessing }
GtTreePagerModelSettingsAnnouncement >> settings: anObject [
	settings := anObject
]
