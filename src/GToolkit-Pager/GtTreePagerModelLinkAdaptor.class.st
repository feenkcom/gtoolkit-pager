Class {
	#name : #GtTreePagerModelLinkAdaptor,
	#superclass : #Object,
	#traits : 'TGtTreePagerPreviousLinkModelAdaptor + TGtTreePagerLinkModelState',
	#classTraits : 'TGtTreePagerPreviousLinkModelAdaptor classTrait + TGtTreePagerLinkModelState classTrait',
	#instVars : [
		'pagerModel',
		'paneModel'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'api - pane model' }
GtTreePagerModelLinkAdaptor >> activeLink [
	"TODO: I think it can be removed"

	<return: #TGtTreePagerLinkModel or: nil>
	^ nil
]

{ #category : #'api - pane model' }
GtTreePagerModelLinkAdaptor >> allPreviousPanesDo: aFullBlockClosure [
	"Iterate previous panes hierarchy.
	I am the root of my pane model, therefore do nothing."

	
]

{ #category : #'api - pane model' }
GtTreePagerModelLinkAdaptor >> depthIndex [
	"Return a depth of a given pane model"

	<return: #Integer>
	^ 0
]

{ #category : #accessing }
GtTreePagerModelLinkAdaptor >> pagerModel [
	^ pagerModel
]

{ #category : #accessing }
GtTreePagerModelLinkAdaptor >> pagerModel: aPagerModel [
	self assert: [ aPagerModel isKindOf: GtTreePagerModel ].
	self assert: [ paneModel isNotNil ].
	pagerModel := aPagerModel
]

{ #category : #accessing }
GtTreePagerModelLinkAdaptor >> paneModel [
	^ paneModel
]

{ #category : #accessing }
GtTreePagerModelLinkAdaptor >> paneModel: aPaneModel [
	self assert: [ aPaneModel isKindOf: GtTreePagerPaneModel ].
	
	paneModel := aPaneModel
]

{ #category : #'api - pane model' }
GtTreePagerModelLinkAdaptor >> previousPane [
	"I am the root of my pane model"

	<return: #GtTreePagerPaneModel or: #TGtTreePagerPreviousLinkModelAdaptor>
	^ self
]

{ #category : #'api - state' }
GtTreePagerModelLinkAdaptor >> state [
	"My pane model is always spawned (and thefore displayed)"

	<return: #GtTreePagerLinkState>
	^ GtTreePagerLinkState spawned
]
