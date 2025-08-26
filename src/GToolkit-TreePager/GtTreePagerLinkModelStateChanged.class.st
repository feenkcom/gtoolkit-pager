Class {
	#name : #GtTreePagerLinkModelStateChanged,
	#superclass : #GtTreePagerLinkModelAnnouncement,
	#instVars : [
		'newState',
		'oldState',
		'reason'
	],
	#category : #'GToolkit-TreePager-Announcements'
}

{ #category : #accessing }
GtTreePagerLinkModelStateChanged >> newState [
	^ newState
]

{ #category : #accessing }
GtTreePagerLinkModelStateChanged >> newState: anObject [
	newState := anObject
]

{ #category : #accessing }
GtTreePagerLinkModelStateChanged >> oldState [
	^ oldState
]

{ #category : #accessing }
GtTreePagerLinkModelStateChanged >> oldState: anOldState [
	oldState := anOldState
]

{ #category : #accessing }
GtTreePagerLinkModelStateChanged >> reason [
	^ reason ifNil: [ GtTreePagerUnknownReason default ]
]

{ #category : #accessing }
GtTreePagerLinkModelStateChanged >> reason: aReason [
	reason := aReason
]
