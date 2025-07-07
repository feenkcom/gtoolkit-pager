Class {
	#name : #GtTreePagerLinkState,
	#superclass : #Object,
	#classVars : [
		'Selected',
		'Spawned'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'api - accessing' }
GtTreePagerLinkState class >> selected [
	^ Selected ifNil: [ Selected := GtTreePagerLinkSelectedState new ]
]

{ #category : #'api - accessing' }
GtTreePagerLinkState class >> spawned [
	^ Spawned ifNil: [ Spawned := GtTreePagerLinkSpawnedState new ]
]
