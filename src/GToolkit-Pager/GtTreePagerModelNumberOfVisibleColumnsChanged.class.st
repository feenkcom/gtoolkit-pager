Class {
	#name : #GtTreePagerModelNumberOfVisibleColumnsChanged,
	#superclass : #GtTreePagerModelSettingsAnnouncement,
	#instVars : [
		'amount'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #accessing }
GtTreePagerModelNumberOfVisibleColumnsChanged >> amount [
	^ amount
]

{ #category : #accessing }
GtTreePagerModelNumberOfVisibleColumnsChanged >> amount: anObject [
	amount := anObject
]
