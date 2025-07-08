Class {
	#name : #GtTreePagerLinkState,
	#superclass : #Object,
	#classVars : [
		'Collapsed',
		'Inactive',
		'Selected',
		'Spawned'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'api - accessing' }
GtTreePagerLinkState class >> collapsed [
	^ Collapsed ifNil: [ Collapsed := GtTreePagerLinkInactiveCollapsedState new ]
]

{ #category : #'api - accessing' }
GtTreePagerLinkState class >> inactive [
	^ Inactive ifNil: [ Inactive := GtTreePagerLinkInactiveSpawnedState new ]
]

{ #category : #'api - accessing' }
GtTreePagerLinkState class >> selected [
	^ Selected ifNil: [ Selected := GtTreePagerLinkActiveSelectedState new ]
]

{ #category : #'api - accessing' }
GtTreePagerLinkState class >> spawned [
	^ Spawned ifNil: [ Spawned := GtTreePagerLinkActiveSpawnedState new ]
]

{ #category : #visiting }
GtTreePagerLinkState >> acceptVisitor: aVisitor [
	^ aVisitor visitGtTreePagerLinkState: self
]

{ #category : #'api - state' }
GtTreePagerLinkState >> activate [
	"Return an active state"

	^ self
]

{ #category : #'api - state' }
GtTreePagerLinkState >> collapse [
	"Return a collapsed state"

	^ self
]

{ #category : #'api - state' }
GtTreePagerLinkState >> expand [
	"Return an expanded state"

	^ self
]

{ #category : #'api - state' }
GtTreePagerLinkState >> inactivate [
	"Return an inactive state"

	^ self
]

{ #category : #'api - state' }
GtTreePagerLinkState >> isActive [
	^ false
]

{ #category : #'api - state' }
GtTreePagerLinkState >> isCollapsed [
	^ false
]

{ #category : #'api - state' }
GtTreePagerLinkState >> isDisplayed [
	"Return true if link pane model is displayed (expanded and spawned)"

	^ false
]

{ #category : #'api - state' }
GtTreePagerLinkState >> isExpanded [
	^ self isCollapsed not
]

{ #category : #'api - state' }
GtTreePagerLinkState >> isHidden [
	^ false
]
