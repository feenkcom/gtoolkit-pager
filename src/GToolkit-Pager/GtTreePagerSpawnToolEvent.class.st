Class {
	#name : #GtTreePagerSpawnToolEvent,
	#superclass : #BlEvent,
	#instVars : [
		'toolModel'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #accessing }
GtTreePagerSpawnToolEvent >> toolModel [
	^ toolModel
]

{ #category : #accessing }
GtTreePagerSpawnToolEvent >> toolModel: anObject [
	toolModel := anObject
]
