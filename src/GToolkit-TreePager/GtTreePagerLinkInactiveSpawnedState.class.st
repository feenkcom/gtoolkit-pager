Class {
	#name : #GtTreePagerLinkInactiveSpawnedState,
	#superclass : #GtTreePagerLinkState,
	#category : #'GToolkit-TreePager-Model'
}

{ #category : #visiting }
GtTreePagerLinkInactiveSpawnedState >> acceptVisitor: aVisitor [
	^ aVisitor visitGtTreePagerLinkInactiveSpawnedState: self
]

{ #category : #'api - state' }
GtTreePagerLinkInactiveSpawnedState >> activate [
	"Return an active state"

	^ GtTreePagerLinkState spawned
]

{ #category : #'api - state' }
GtTreePagerLinkInactiveSpawnedState >> collapse [
	"Return a collapsed state"

	^ GtTreePagerLinkState collapsed
]

{ #category : #'api - state' }
GtTreePagerLinkInactiveSpawnedState >> isSpawned [
	"Return true if link pane model is spawned (expanded and displayed)"

	<return: #Boolean>
	^ true
]
