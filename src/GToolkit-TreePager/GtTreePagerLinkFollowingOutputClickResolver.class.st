"
I resolve a click action on an output (triangle) element.
For a different {{gtMethod:GtTreePagerLinkModel>>#state | label=link states}}, i perform different actions.
"
Class {
	#name : #GtTreePagerLinkFollowingOutputClickResolver,
	#superclass : #Object,
	#traits : 'TGtTreePagerLinkStateVisitor',
	#classTraits : 'TGtTreePagerLinkStateVisitor classTrait',
	#instVars : [
		'element',
		'linkModel'
	],
	#category : #'GToolkit-TreePager-Support'
}

{ #category : #accessing }
GtTreePagerLinkFollowingOutputClickResolver >> element [
	^ element
]

{ #category : #accessing }
GtTreePagerLinkFollowingOutputClickResolver >> element: anObject [
	element := anObject
]

{ #category : #accessing }
GtTreePagerLinkFollowingOutputClickResolver >> linkModel [
	^ linkModel
]

{ #category : #accessing }
GtTreePagerLinkFollowingOutputClickResolver >> linkModel: anObject [
	linkModel := anObject
]

{ #category : #resolving }
GtTreePagerLinkFollowingOutputClickResolver >> resolve [
	self visitLinkState: self linkModel state
]

{ #category : #visiting }
GtTreePagerLinkFollowingOutputClickResolver >> visitGtTreePagerLinkActiveSelectedState: aState [
	self linkModel expand
]

{ #category : #visiting }
GtTreePagerLinkFollowingOutputClickResolver >> visitGtTreePagerLinkActiveSpawnedState: aState [
	self linkModel inactivate
]

{ #category : #visiting }
GtTreePagerLinkFollowingOutputClickResolver >> visitGtTreePagerLinkInactiveCollapsedState: aState [
	self linkModel expand
]

{ #category : #visiting }
GtTreePagerLinkFollowingOutputClickResolver >> visitGtTreePagerLinkInactiveHiddenState: aState [
	self linkModel expand
]

{ #category : #visiting }
GtTreePagerLinkFollowingOutputClickResolver >> visitGtTreePagerLinkInactiveSpawnedState: aState [
	self linkModel activate
]
