Trait {
	#name : #TGtTreePagerPaneModel,
	#category : #'GToolkit-TreePager-Model'
}

{ #category : #'api - previous links' }
TGtTreePagerPaneModel >> allPreviousPanesDo: aFullBlockClosure [
	"Iterate previous panes hierarchy"

	self explicitRequirement
]

{ #category : #'api - following links' }
TGtTreePagerPaneModel >> children [
	<return: #Collection of: #TGtTreePagerLinkModel>
	^ self explicitRequirement
]

{ #category : #'api - following links' }
TGtTreePagerPaneModel >> removeLink [
	"Deselect an existing link model"

	self explicitRequirement
]

{ #category : #'api - following links' }
TGtTreePagerPaneModel >> selectPane: aPaneModel [
	"Select a new pane model"

	self explicitRequirement
]

{ #category : #copying }
TGtTreePagerPaneModel >> similarPaneCopy [
	<return: #TGtTreePagerPaneModel>
	^ self explicitRequirement
]

{ #category : #'api - following links' }
TGtTreePagerPaneModel >> spawnPane: aPaneModel [
	"Spawn a new pane model"

	self explicitRequirement
]

{ #category : #'api - previous links' }
TGtTreePagerPaneModel >> topPreviousPane [
	"Note: it is usually a pager model"

	| aTopModel |
	aTopModel := nil.
	self allPreviousPanesDo: [ :aPreviousPane | aTopModel := aPreviousPane ].
	^ aTopModel
]
