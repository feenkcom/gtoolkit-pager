Class {
	#name : #GtTreePagerLinkInactiveHiddenState,
	#superclass : #GtTreePagerLinkState,
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #visiting }
GtTreePagerLinkInactiveHiddenState >> acceptVisitor: aVisitor [
	^ aVisitor visitGtTreePagerLinkInactiveHiddenState: self
]

{ #category : #'api - state' }
GtTreePagerLinkInactiveHiddenState >> activate [
	"Return an active state"

	^ GtTreePagerLinkState spawned
]

{ #category : #'api - state' }
GtTreePagerLinkInactiveHiddenState >> expand [
	"Return an expanded state"

	^ GtTreePagerLinkState inactive
]

{ #category : #'api - state' }
GtTreePagerLinkInactiveHiddenState >> hide [
	^ self
]

{ #category : #'api - state' }
GtTreePagerLinkInactiveHiddenState >> isHidden [
	^ true
]
