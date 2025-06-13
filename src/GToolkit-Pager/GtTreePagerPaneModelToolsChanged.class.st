Class {
	#name : #GtTreePagerPaneModelToolsChanged,
	#superclass : #GtTreePagerPaneModelAnnouncement,
	#instVars : [
		'toolModels'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #accessing }
GtTreePagerPaneModelToolsChanged >> toolModels [
	^ toolModels
]

{ #category : #accessing }
GtTreePagerPaneModelToolsChanged >> toolModels: anObject [
	toolModels := anObject
]
