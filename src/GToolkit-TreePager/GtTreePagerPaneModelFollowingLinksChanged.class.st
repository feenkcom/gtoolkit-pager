Class {
	#name : #GtTreePagerPaneModelFollowingLinksChanged,
	#superclass : #GtTreePagerPaneModelAnnouncement,
	#instVars : [
		'newFollowingLinks',
		'oldFollowingLinks',
		'reason'
	],
	#category : #'GToolkit-TreePager-Announcements'
}

{ #category : #enumerating }
GtTreePagerPaneModelFollowingLinksChanged >> addedFollowingLinks [
	^ self newFollowingLinks difference: self oldFollowingLinks
]

{ #category : #enumerating }
GtTreePagerPaneModelFollowingLinksChanged >> addedFollowingPanes [
	^ self addedFollowingLinks collect: #paneModel
]

{ #category : #accessing }
GtTreePagerPaneModelFollowingLinksChanged >> newFollowingLinks [
	^ newFollowingLinks
]

{ #category : #accessing }
GtTreePagerPaneModelFollowingLinksChanged >> newFollowingLinks: aCollection [
	newFollowingLinks := aCollection
]

{ #category : #accessing }
GtTreePagerPaneModelFollowingLinksChanged >> newFollowingPanes [
	^ self newFollowingLinks collect: #paneModel
]

{ #category : #accessing }
GtTreePagerPaneModelFollowingLinksChanged >> oldFollowingLinks [
	^ oldFollowingLinks ifNil: [ Array empty ]
]

{ #category : #accessing }
GtTreePagerPaneModelFollowingLinksChanged >> oldFollowingLinks: aCollection [
	oldFollowingLinks := aCollection
]

{ #category : #accessing }
GtTreePagerPaneModelFollowingLinksChanged >> oldFollowingPanes [
	^ self oldFollowingLinks collect: #paneModel
]

{ #category : #accessing }
GtTreePagerPaneModelFollowingLinksChanged >> reason [
	^ reason ifNil: [ GtTreePagerUnknownReason default ]
]

{ #category : #accessing }
GtTreePagerPaneModelFollowingLinksChanged >> reason: anObject [
	reason := anObject
]

{ #category : #enumerating }
GtTreePagerPaneModelFollowingLinksChanged >> removedFollowingLinks [
	^ self oldFollowingLinks difference: self newFollowingLinks
]

{ #category : #enumerating }
GtTreePagerPaneModelFollowingLinksChanged >> removedFollowingPanes [
	^ self removedFollowingLinks collect: #paneModel
]
