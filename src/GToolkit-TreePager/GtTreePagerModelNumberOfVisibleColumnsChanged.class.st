Class {
	#name : #GtTreePagerModelNumberOfVisibleColumnsChanged,
	#superclass : #GtTreePagerModelSettingsAnnouncement,
	#instVars : [
		'amount'
	],
	#category : #'GToolkit-TreePager-Announcements'
}

{ #category : #accessing }
GtTreePagerModelNumberOfVisibleColumnsChanged >> amount [
	^ amount
]

{ #category : #accessing }
GtTreePagerModelNumberOfVisibleColumnsChanged >> amount: anObject [
	amount := anObject
]
