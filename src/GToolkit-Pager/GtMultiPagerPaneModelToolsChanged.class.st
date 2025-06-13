Class {
	#name : #GtMultiPagerPaneModelToolsChanged,
	#superclass : #GtMultiPagerPaneModelAnnouncement,
	#instVars : [
		'toolModels'
	],
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #accessing }
GtMultiPagerPaneModelToolsChanged >> toolModels [
	^ toolModels
]

{ #category : #accessing }
GtMultiPagerPaneModelToolsChanged >> toolModels: anObject [
	toolModels := anObject
]
