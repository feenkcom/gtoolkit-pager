Class {
	#name : #GtTreePagerLinkActiveSpawnedState,
	#superclass : #GtTreePagerLinkState,
	#category : #'GToolkit-Pager-Tree Pager'
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
GtTreePagerLinkActiveSpawnedState >> isDisplayed [
	"Return true if link pane model is displayed (expanded and spawned)"

	^ true
]
