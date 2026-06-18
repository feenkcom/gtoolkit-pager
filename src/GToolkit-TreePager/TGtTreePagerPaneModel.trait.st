Trait {
	#name : #TGtTreePagerPaneModel,
	#category : #'GToolkit-TreePager-Model Rest'
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

{ #category : #'api - previous links' }
TGtTreePagerPaneModel >> pagerSettings [
	"Note: it is usually a pager model"

	<return: #GtTreePagerModelSettings or: nil>
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

{ #category : #'api - accessing' }
TGtTreePagerPaneModel >> selectionStateDo: aSelectionStateBlock ifAbsent: anAbsentBlock [
	"If there is an explicitly defined selection state, 
	- evaluate aSelectionStateBlock with one parameter [ :aSelectionState | ], 
	  - aSelectionState is kind of GtPhlowToolSelectionState object, 
	- on undefined selection state evaluate anAbsentBlock without any parameter."

	^ anAbsentBlock value
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

{ #category : #'api - accessing' }
TGtTreePagerPaneModel >> timestamp [
	"Return a timestamp that indicates time of a pane creation, ideally time it was added to a pager."

	<return: #DateAndTime>
	^ self explicitRequirement
]

{ #category : #'api - previous links' }
TGtTreePagerPaneModel >> topPreviousPane [
	"Note: it is usually a pager model"

	| aTopModel |
	aTopModel := nil.
	self allPreviousPanesDo: [ :aPreviousPane | aTopModel := aPreviousPane ].
	^ aTopModel
]
