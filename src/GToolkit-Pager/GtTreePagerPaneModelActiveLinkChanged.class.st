Class {
	#name : #GtTreePagerPaneModelActiveLinkChanged,
	#superclass : #GtTreePagerPaneModelAnnouncement,
	#instVars : [
		'oldActiveLink',
		'newActiveLink'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #accessing }
GtTreePagerPaneModelActiveLinkChanged >> newActiveLink [
	^ newActiveLink
]

{ #category : #accessing }
GtTreePagerPaneModelActiveLinkChanged >> newActiveLink: anObject [
	newActiveLink := anObject
]

{ #category : #accessing }
GtTreePagerPaneModelActiveLinkChanged >> oldActiveLink [
	^ oldActiveLink
]

{ #category : #accessing }
GtTreePagerPaneModelActiveLinkChanged >> oldActiveLink: anObject [
	oldActiveLink := anObject
]
