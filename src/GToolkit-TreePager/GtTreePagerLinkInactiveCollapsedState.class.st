Class {
	#name : #GtTreePagerLinkInactiveCollapsedState,
	#superclass : #GtTreePagerLinkState,
	#category : #'GToolkit-TreePager-Model Rest'
}

{ #category : #visiting }
GtTreePagerLinkInactiveCollapsedState >> acceptVisitor: aVisitor [
	^ aVisitor visitGtTreePagerLinkInactiveCollapsedState: self
]

{ #category : #'api - state' }
GtTreePagerLinkInactiveCollapsedState >> activate [
	"Return an active state"

	^ GtTreePagerLinkState spawned
]

{ #category : #'api - state' }
GtTreePagerLinkInactiveCollapsedState >> expand [
	"Return an expanded state"

	^ GtTreePagerLinkState inactive
]

{ #category : #'api - state' }
GtTreePagerLinkInactiveCollapsedState >> isCollapsed [
	^ true
]

{ #category : #'api - state' }
GtTreePagerLinkInactiveCollapsedState >> select [
	"Return a selected state"

	^ GtTreePagerLinkState hidden
]
