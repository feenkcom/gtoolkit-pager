Class {
	#name : #GtTreePagerLinkActiveCollapsedState,
	#superclass : #GtTreePagerLinkState,
	#category : #'GToolkit-TreePager-Model Rest'
}

{ #category : #visiting }
GtTreePagerLinkActiveCollapsedState >> acceptVisitor: aVisitor [
	^ aVisitor visitGtTreePagerLinkActiveCollapsedState: self
]

{ #category : #'api - state' }
GtTreePagerLinkActiveCollapsedState >> expand [
	"Return an expanded state"

	^ GtTreePagerLinkState spawned
]

{ #category : #'api - state' }
GtTreePagerLinkActiveCollapsedState >> inactivate [
	"Return an inactive state"

	^ GtTreePagerLinkState collapsed
]

{ #category : #'api - state' }
GtTreePagerLinkActiveCollapsedState >> isActive [
	^ true
]

{ #category : #'api - state' }
GtTreePagerLinkActiveCollapsedState >> isCollapsed [
	^ true
]

{ #category : #'api - state' }
GtTreePagerLinkActiveCollapsedState >> select [
	"Return a selected state"

	^ GtTreePagerLinkState selected
]
