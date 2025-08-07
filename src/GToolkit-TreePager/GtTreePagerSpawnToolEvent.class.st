Class {
	#name : #GtTreePagerSpawnToolEvent,
	#superclass : #BlEvent,
	#instVars : [
		'toolModel'
	],
	#category : #'GToolkit-TreePager-Events'
}

{ #category : #accessing }
GtTreePagerSpawnToolEvent >> toolModel [
	^ toolModel
]

{ #category : #accessing }
GtTreePagerSpawnToolEvent >> toolModel: anObject [
	toolModel := anObject
]
