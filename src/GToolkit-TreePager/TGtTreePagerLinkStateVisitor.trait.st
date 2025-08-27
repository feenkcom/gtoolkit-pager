Trait {
	#name : #TGtTreePagerLinkStateVisitor,
	#category : #'GToolkit-TreePager-Model'
}

{ #category : #visiting }
TGtTreePagerLinkStateVisitor >> visitGtTreePagerLinkActiveSelectedState: aState [
	self visitGtTreePagerLinkState: aState
]

{ #category : #visiting }
TGtTreePagerLinkStateVisitor >> visitGtTreePagerLinkActiveSpawnedState: aState [
	self visitGtTreePagerLinkState: aState
]

{ #category : #visiting }
TGtTreePagerLinkStateVisitor >> visitGtTreePagerLinkInactiveCollapsedState: aState [
	self visitGtTreePagerLinkState: aState
]

{ #category : #visiting }
TGtTreePagerLinkStateVisitor >> visitGtTreePagerLinkInactiveHiddenState: aState [
	self visitGtTreePagerLinkState: aState
]

{ #category : #visiting }
TGtTreePagerLinkStateVisitor >> visitGtTreePagerLinkInactiveRemovedState: aState [
	self visitGtTreePagerLinkState: aState
]

{ #category : #visiting }
TGtTreePagerLinkStateVisitor >> visitGtTreePagerLinkInactiveSpawnedState: aState [
	self visitGtTreePagerLinkState: aState
]

{ #category : #visiting }
TGtTreePagerLinkStateVisitor >> visitGtTreePagerLinkState: aState [
	
]

{ #category : #visiting }
TGtTreePagerLinkStateVisitor >> visitLinkState: aState [
	^ aState acceptVisitor: self
]
