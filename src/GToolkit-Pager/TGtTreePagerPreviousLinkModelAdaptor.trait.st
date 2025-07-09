Trait {
	#name : #TGtTreePagerPreviousLinkModelAdaptor,
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'api - pane model' }
TGtTreePagerPreviousLinkModelAdaptor >> activeLink [
	"TODO: I think it can be removed"

	<return: #TGtTreePagerLinkModel or: nil>
	^ self explicitRequirement
]

{ #category : #'api - pane model' }
TGtTreePagerPreviousLinkModelAdaptor >> allPreviousPanesDo: aFullBlockClosure [
	"Iterate previous panes hierarchy"

	self explicitRequirement
]

{ #category : #'api - pane model' }
TGtTreePagerPreviousLinkModelAdaptor >> depthIndex [
	"Return a depth of a given pane model"

	<return: #Integer>
	^ self explicitRequirement
]

{ #category : #'api - pane model' }
TGtTreePagerPreviousLinkModelAdaptor >> previousPane [
	"Return a previous pane model"

	<return: #GtTreePagerPaneModel or: #TGtTreePagerPreviousLinkModelAdaptor>
	^ self explicitRequirement
]
