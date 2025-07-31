Class {
	#name : #GtTreePagerLinkInactiveSelectedState,
	#superclass : #GtTreePagerLinkState,
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #visiting }
GtTreePagerLinkInactiveSelectedState >> acceptVisitor: aVisitor [
	^ aVisitor visitGtTreePagerLinkInactiveHiddenState: self
]

{ #category : #'api - state' }
GtTreePagerLinkInactiveSelectedState >> activate [
	"Return an active state"

	^ GtTreePagerLinkState spawned
]

{ #category : #'api - state' }
GtTreePagerLinkInactiveSelectedState >> expand [
	"Return an expanded state"

	^ GtTreePagerLinkState inactive
]

{ #category : #'api - state' }
GtTreePagerLinkInactiveSelectedState >> hide [
	^ self
]

{ #category : #'api - state' }
GtTreePagerLinkInactiveSelectedState >> isHidden [
	^ true
]
