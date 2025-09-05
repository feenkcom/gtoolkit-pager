Class {
	#name : #GtTreePagerLinkActiveSpawnedState,
	#superclass : #GtTreePagerLinkState,
	#category : #'GToolkit-TreePager-Model Rest'
}

{ #category : #visiting }
GtTreePagerLinkActiveSpawnedState >> acceptVisitor: aVisitor [
	^ aVisitor visitGtTreePagerLinkActiveSpawnedState: self
]

{ #category : #'api - state' }
GtTreePagerLinkActiveSpawnedState >> collapse [
	"Return a collapsed state"

	^ GtTreePagerLinkState collapsed
]

{ #category : #'api - state' }
GtTreePagerLinkActiveSpawnedState >> inactivate [
	"Return an inactive state"

	^ GtTreePagerLinkState inactive
]

{ #category : #'api - state' }
GtTreePagerLinkActiveSpawnedState >> isActive [
	^ true
]

{ #category : #'api - state' }
GtTreePagerLinkActiveSpawnedState >> isSpawned [
	"Return true if link pane model is spawned (expanded and displayed)"

	<return: #Boolean>
	^ true
]

{ #category : #'api - state' }
GtTreePagerLinkActiveSpawnedState >> select [
	"Return a selected state"

	^ GtTreePagerLinkState selected
]
