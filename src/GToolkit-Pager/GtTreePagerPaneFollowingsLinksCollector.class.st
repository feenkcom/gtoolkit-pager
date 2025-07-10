Class {
	#name : #GtTreePagerPaneFollowingsLinksCollector,
	#superclass : #Object,
	#traits : 'TGtTreePagerLinkStateVisitor',
	#classTraits : 'TGtTreePagerLinkStateVisitor classTrait',
	#instVars : [
		'paneModel',
		'linksStream',
		'currentDepth',
		'currentLinkModel'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #building }
GtTreePagerPaneFollowingsLinksCollector >> collect [
	^ Array
		streamContents: [ :aStream | 
			linksStream := aStream.
			self paneModel followingLinks
				do: [ :eachLinkModel | self collectLinksToDisplay: eachLinkModel depth: 1 ].
			linksStream := nil ]
]

{ #category : #private }
GtTreePagerPaneFollowingsLinksCollector >> collectLinksToDisplay: aLinkModel depth: aDepth [
	| previousDepth previousLinkModel |
	previousDepth := currentDepth.
	previousLinkModel := currentLinkModel.
	currentDepth := aDepth.
	currentLinkModel := aLinkModel.
	self visitLinkState: aLinkModel state.

	currentDepth := previousDepth.
	currentLinkModel := previousLinkModel
]

{ #category : #accessing }
GtTreePagerPaneFollowingsLinksCollector >> paneModel [
	^ paneModel
]

{ #category : #accessing }
GtTreePagerPaneFollowingsLinksCollector >> paneModel: aPaneModel [
	paneModel := aPaneModel
]

{ #category : #visiting }
GtTreePagerPaneFollowingsLinksCollector >> visitGtTreePagerLinkInactiveCollapsedState: aState [
	linksStream nextPut: currentLinkModel.

	currentLinkModel followingLinks
		do: [ :eachLinkModel | self collectLinksToDisplay: eachLinkModel depth: currentDepth + 1 ]
]

{ #category : #visiting }
GtTreePagerPaneFollowingsLinksCollector >> visitGtTreePagerLinkState: aState [
	currentDepth = 1 ifTrue: [ linksStream nextPut: currentLinkModel ]
]
