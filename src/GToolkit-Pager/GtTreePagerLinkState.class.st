Class {
	#name : #GtTreePagerLinkState,
	#superclass : #Object,
	#classVars : [
		'Collapsed',
		'Hidden',
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
GtTreePagerLinkState class >> hidden [
	^ Hidden ifNil: [ Hidden := GtTreePagerLinkInactiveHiddenState new ]
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
GtTreePagerLinkState >> hide [
	"Return a hidden state"

	^ GtTreePagerLinkState hidden
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
GtTreePagerLinkState >> isExpanded [
	^ self isCollapsed not
]

{ #category : #'api - state' }
GtTreePagerLinkState >> isHidden [
	^ false
]

{ #category : #'api - state' }
GtTreePagerLinkState >> isSpawned [
	"Return true if link pane model is spawned (expanded and displayed)"

	<return: #Boolean>
	^ false
]

{ #category : #'api - state' }
GtTreePagerLinkState >> select [
	"Return a selected state"

	^ GtTreePagerLinkState selected
]
