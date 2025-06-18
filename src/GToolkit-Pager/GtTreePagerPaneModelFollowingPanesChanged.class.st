Class {
	#name : #GtTreePagerPaneModelFollowingPanesChanged,
	#superclass : #GtTreePagerPaneModelAnnouncement,
	#instVars : [
		'newFollowingPanes',
		'oldFollowingPanes'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #enumerating }
GtTreePagerPaneModelFollowingPanesChanged >> addedFollowingPanes [
	^ self newFollowingPanes difference: self oldFollowingPanes
]

{ #category : #accessing }
GtTreePagerPaneModelFollowingPanesChanged >> newFollowingPanes [
	^ newFollowingPanes
]

{ #category : #accessing }
GtTreePagerPaneModelFollowingPanesChanged >> newFollowingPanes: aCollection [
	newFollowingPanes := aCollection
]

{ #category : #accessing }
GtTreePagerPaneModelFollowingPanesChanged >> oldFollowingPanes [
	^ oldFollowingPanes ifNil: [ Array empty ]
]

{ #category : #accessing }
GtTreePagerPaneModelFollowingPanesChanged >> oldFollowingPanes: anObject [
	oldFollowingPanes := anObject
]

{ #category : #enumerating }
GtTreePagerPaneModelFollowingPanesChanged >> removedFollowingPanes [
	^ self oldFollowingPanes difference: self newFollowingPanes
]
