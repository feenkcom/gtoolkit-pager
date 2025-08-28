Trait {
	#name : #TGtTreePagerLinkModel,
	#category : #'GToolkit-TreePager-Model'
}

{ #category : #'api - pane model' }
TGtTreePagerLinkModel >> activeLink [
	"TODO: I think it can be removed"

	<return: #TGtTreePagerLinkModel or: nil>
	^ self explicitRequirement
]

{ #category : #'api - previous links' }
TGtTreePagerLinkModel >> allPreviousLinksDo: aBlock [
	"Iterate previous links hierarchy"
]

{ #category : #'api - replaced link' }
TGtTreePagerLinkModel >> allReplacedLinkModelsDo: aBlock [
	"Iterate all replaced link models of my replaced link, 
	including replaced links models from those replaced links."

	<return: #TGtTreePagerLinkModel or: nil>
	self replacedLink ifNotNil: [ :aReplacedLinkModel |
		aBlock value: aReplacedLinkModel.
		aReplacedLinkModel allReplacedLinkModelsDo: aBlock.
		aReplacedLinkModel allLinkModelsBreadthFirstDo: [ :aLinkModel |
			aBlock value: aLinkModel.
			aLinkModel allReplacedLinkModelsDo: aBlock ] ]
]

{ #category : #'api - phlow' }
TGtTreePagerLinkModel >> canRecreateToolElement [
	<return: #Boolean>
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

{ #category : #copying }
TGtTreePagerLinkModel >> postSimilarLinkCopy [
	
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

{ #category : #'api - replaced link' }
TGtTreePagerLinkModel >> replacedLink [
	"Return a replaced link"

	<return: #TGtTreePagerLinkModel or: nil>
	^ self explicitRequirement
]

{ #category : #copying }
TGtTreePagerLinkModel >> similarLinkCopy [
	<return: #TGtTreePagerPaneModel>
	^ self shallowCopy postSimilarLinkCopy
]

{ #category : #'api - pane model' }
TGtTreePagerLinkModel >> topPreviousPane [
	"Note: it is usually a pager model"

	^ self explicitRequirement
]
