Class {
	#name : #GtMultiPagerSpawnToolEvent,
	#superclass : #BlEvent,
	#instVars : [
		'toolModel'
	],
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #accessing }
GtMultiPagerSpawnToolEvent >> toolModel [
	^ toolModel
]

{ #category : #accessing }
GtMultiPagerSpawnToolEvent >> toolModel: anObject [
	toolModel := anObject
]
