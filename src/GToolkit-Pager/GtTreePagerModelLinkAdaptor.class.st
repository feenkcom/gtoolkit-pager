Class {
	#name : #GtTreePagerModelLinkAdaptor,
	#superclass : #Object,
	#traits : 'TGtTreePagerLinkModel + TGtTreePagerLinkModelState + TGtAnnouncer',
	#classTraits : 'TGtTreePagerLinkModel classTrait + TGtTreePagerLinkModelState classTrait + TGtAnnouncer classTrait',
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

{ #category : #'as yet unclassified' }
GtTreePagerModelLinkAdaptor >> allPreviousPanesDo: aFullBlockClosure [
	"Iterate previous panes hierarchy."

	self pagerModel allPreviousPanesDo: aFullBlockClosure
]

{ #category : #announcer }
GtTreePagerModelLinkAdaptor >> announcer [
	^ self paneModel announcer
]

{ #category : #'api - pane model' }
GtTreePagerModelLinkAdaptor >> children [
	<return: #Collection of: #TGtTreePagerLinkModel>
	^ self paneModel children
]

{ #category : #'api - pane model' }
GtTreePagerModelLinkAdaptor >> depthIndex [
	"Return a depth of a given pane model"

	<return: #Integer>
	^ 0
]

{ #category : #'api - pane model' }
GtTreePagerModelLinkAdaptor >> followingLinks [
	<return: #Collection of: #TGtTreePagerLinkModel>
	^ self paneModel followingLinks
]

{ #category : #printing }
GtTreePagerModelLinkAdaptor >> gtDisplayOn: stream [
	stream nextPutAll: 'Link: '.
	stream nextPutAll: self title asString.
	self isCollapsed ifFalse: [ ^ self ].

	stream nextPutAll: ' ('.
	self isCollapsed ifTrue: [ stream nextPutAll: 'collapsed' ].
	stream nextPut: $)
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
	
	aPaneModel previousLink: self.
	paneModel := aPaneModel
]

{ #category : #'api - pane model' }
GtTreePagerModelLinkAdaptor >> previousLink [
	<return: #TGtTreePagerLinkModel or: nil>
	^ nil
]

{ #category : #'api - pane model' }
GtTreePagerModelLinkAdaptor >> previousPane [
	"I am the root of my pane model"

	<return: #GtTreePagerPaneModel or: #TGtTreePagerLinkModel>
	^ self pagerModel
]

{ #category : #printing }
GtTreePagerModelLinkAdaptor >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: self title asString.
	self isCollapsed ifTrue: [ aStream nextPutAll: ', collapsed' ].
	aStream nextPut: $)
]

{ #category : #'api - state' }
GtTreePagerModelLinkAdaptor >> state [
	"My pane model is always spawned (and thefore displayed)"

	<return: #GtTreePagerLinkState>
	^ GtTreePagerLinkState spawned
]

{ #category : #accessing }
GtTreePagerModelLinkAdaptor >> title [
	^ self paneModel title
]
