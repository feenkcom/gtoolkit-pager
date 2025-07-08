Class {
	#name : #GtTreePagerLinkModelStateChanged,
	#superclass : #GtTreePagerLinkModelAnnouncement,
	#instVars : [
		'newState',
		'oldState'
	],
	#category : #'GToolkit-Pager-Tree Pager'
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
