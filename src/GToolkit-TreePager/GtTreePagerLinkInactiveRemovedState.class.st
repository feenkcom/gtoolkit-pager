"
I am {{gtClass:GtTreePagerLinkModel}}'s state.
I indicate that the model should be removed, e.g., after a restore timeout.
The real link removal should be triggered in a UI.
"
Class {
	#name : #GtTreePagerLinkInactiveRemovedState,
	#superclass : #GtTreePagerLinkState,
	#category : #'GToolkit-TreePager-Model'
}

{ #category : #visiting }
GtTreePagerLinkInactiveRemovedState >> acceptVisitor: aVisitor [
	^ aVisitor visitGtTreePagerLinkInactiveRemovedState: self
]

{ #category : #'api - state' }
GtTreePagerLinkInactiveRemovedState >> activate [
	"Return an active state"

	^ GtTreePagerLinkState spawned
]

{ #category : #'api - state' }
GtTreePagerLinkInactiveRemovedState >> expand [
	"Return an expanded state"

	^ GtTreePagerLinkState inactive
]

{ #category : #'api - state' }
GtTreePagerLinkInactiveRemovedState >> isRemoved [
	^ true
]

{ #category : #'api - state' }
GtTreePagerLinkInactiveRemovedState >> select [
	"Return a selected state"

	^ GtTreePagerLinkState hidden
]
