Class {
	#name : #GtTreePagerLinkFollowingOutputElementUpdater,
	#superclass : #Object,
	#traits : 'TGtTreePagerLinkStateVisitor',
	#classTraits : 'TGtTreePagerLinkStateVisitor classTrait',
	#instVars : [
		'linkModel',
		'linkElement'
	],
	#category : #'GToolkit-TreePager-Support'
}

{ #category : #accessing }
GtTreePagerLinkFollowingOutputElementUpdater >> linkElement [
	^ linkElement
]

{ #category : #accessing }
GtTreePagerLinkFollowingOutputElementUpdater >> linkElement: anObject [
	linkElement := anObject
]

{ #category : #accessing }
GtTreePagerLinkFollowingOutputElementUpdater >> linkModel [
	^ linkModel
]

{ #category : #accessing }
GtTreePagerLinkFollowingOutputElementUpdater >> linkModel: anObject [
	linkModel := anObject
]

{ #category : #updating }
GtTreePagerLinkFollowingOutputElementUpdater >> update [
	self linkModel ifNil: [ ^ self ].
	
	self visitLinkState: self linkModel state
]

{ #category : #private }
GtTreePagerLinkFollowingOutputElementUpdater >> updateNonSpawnedLink [
	self linkElement stopAnimation.
	self linkElement
		geometry: (BlPolygonGeometry
				vertices: {0 @ 0.
						GtTreePagerConstants rectangleLength @ 0.
						(GtTreePagerConstants rectangleLength // 2)
							@ (GtTreePagerConstants rectangleLength // 2)}).
	self linkElement
		exact: GtTreePagerConstants rectangleLength
				@ (GtTreePagerConstants rectangleLength // 2)
]

{ #category : #private }
GtTreePagerLinkFollowingOutputElementUpdater >> updateSpawnedLink [
	self linkElement stopAnimation.
	self linkElement
		geometry: (BlPolygonGeometry
				vertices: {0 @ 0.
						GtTreePagerConstants triangleWidth
							@ (GtTreePagerConstants triangleHeight // 2).
						0 @ GtTreePagerConstants triangleHeight}).
	self linkElement
		exact: GtTreePagerConstants triangleWidth @ GtTreePagerConstants triangleHeight
]

{ #category : #visiting }
GtTreePagerLinkFollowingOutputElementUpdater >> visitGtTreePagerLinkActiveSpawnedState: aState [
	self updateSpawnedLink
]

{ #category : #visiting }
GtTreePagerLinkFollowingOutputElementUpdater >> visitGtTreePagerLinkInactiveRemovedState: aState [
	self linkElement geometry: self linkElement newAboutToBeRemovedGeometry.
	self linkElement
		exact: GtTreePagerConstants triangleWidth @ GtTreePagerConstants triangleWidth.
	self linkElement startAnimation
]

{ #category : #visiting }
GtTreePagerLinkFollowingOutputElementUpdater >> visitGtTreePagerLinkInactiveSpawnedState: aState [
	self updateSpawnedLink
]

{ #category : #visiting }
GtTreePagerLinkFollowingOutputElementUpdater >> visitGtTreePagerLinkState: aState [
	self updateNonSpawnedLink
]
