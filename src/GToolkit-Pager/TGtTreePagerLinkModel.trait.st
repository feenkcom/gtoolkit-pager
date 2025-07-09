Trait {
	#name : #TGtTreePagerLinkModel,
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'api - pane model' }
TGtTreePagerLinkModel >> activeLink [
	"TODO: I think it can be removed"

	<return: #TGtTreePagerLinkModel or: nil>
	^ self explicitRequirement
]

{ #category : #'api - pane model' }
TGtTreePagerLinkModel >> children [
	<return: #Collection of: #TGtTreePagerLinkModel>
	^ self explicitRequirement
]

{ #category : #'api - pane model' }
TGtTreePagerLinkModel >> depthIndex [
	"Return a depth of a given pane model"

	<return: #Integer>
	^ self explicitRequirement
]

{ #category : #'api - pane model' }
TGtTreePagerLinkModel >> followingLinks [
	<return: #Collection of: #TGtTreePagerLinkModel>
	^ self explicitRequirement
]

{ #category : #'api - pane model' }
TGtTreePagerLinkModel >> previousLink [
	<return: #TGtTreePagerLinkModel or: nil>
	^ self explicitRequirement
]

{ #category : #'api - pane model' }
TGtTreePagerLinkModel >> previousPane [
	"Return a previous pane model"

	<return: #GtTreePagerPaneModel or: #TGtTreePagerLinkModel>
	^ self explicitRequirement
]
