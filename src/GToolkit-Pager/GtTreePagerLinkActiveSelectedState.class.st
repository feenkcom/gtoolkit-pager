Class {
	#name : #GtTreePagerLinkActiveSelectedState,
	#superclass : #GtTreePagerLinkState,
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #visiting }
GtTreePagerLinkActiveSelectedState >> acceptVisitor: aVisitor [
	^ aVisitor visitGtTreePagerLinkActiveSelectedState: self
]

{ #category : #'api - state' }
GtTreePagerLinkActiveSelectedState >> expand [
	"Return an expanded state"

	^ GtTreePagerLinkState spawned
]

{ #category : #'api - state' }
GtTreePagerLinkActiveSelectedState >> inactivate [
	"Return an inactive state"

	^ GtTreePagerLinkState inactive
]

{ #category : #'api - state' }
GtTreePagerLinkActiveSelectedState >> isActive [
	^ true
]
