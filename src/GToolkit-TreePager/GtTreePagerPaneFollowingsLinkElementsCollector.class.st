Class {
	#name : #GtTreePagerPaneFollowingsLinkElementsCollector,
	#superclass : #Object,
	#traits : 'TGtTreePagerLinkStateVisitor',
	#classTraits : 'TGtTreePagerLinkStateVisitor classTrait',
	#instVars : [
		'linkModels',
		'existingElements',
		'elementsStream',
		'paneModel',
		'currentLinkModel'
	],
	#category : #'GToolkit-TreePager-Support'
}

{ #category : #private }
GtTreePagerPaneFollowingsLinkElementsCollector >> addTriangleElement [
	elementsStream
		nextPut: (GtTreePagerLinkFollowingContainerElement triangle linkModel: currentLinkModel)
]

{ #category : #building }
GtTreePagerPaneFollowingsLinkElementsCollector >> collect [
	^ Array
		streamContents: [ :aStream | 
			elementsStream := aStream.
			linkModels do: [ :eachLinkModel | self collectLinkElements: eachLinkModel ].
			elementsStream := nil ]
]

{ #category : #private }
GtTreePagerPaneFollowingsLinkElementsCollector >> collectLinkElements: aLinkModel [
	| previousLinkModel |
	previousLinkModel := currentLinkModel.
	currentLinkModel := aLinkModel.
	self visitLinkState: aLinkModel state.
	currentLinkModel := previousLinkModel
]

{ #category : #accessing }
GtTreePagerPaneFollowingsLinkElementsCollector >> existingElements [
	^ existingElements
]

{ #category : #accessing }
GtTreePagerPaneFollowingsLinkElementsCollector >> existingElements: anObject [
	existingElements := anObject
]

{ #category : #accessing }
GtTreePagerPaneFollowingsLinkElementsCollector >> linkModels [
	^ linkModels
]

{ #category : #accessing }
GtTreePagerPaneFollowingsLinkElementsCollector >> linkModels: anObject [
	linkModels := anObject
]

{ #category : #accessing }
GtTreePagerPaneFollowingsLinkElementsCollector >> paneModel [
	^ paneModel
]

{ #category : #accessing }
GtTreePagerPaneFollowingsLinkElementsCollector >> paneModel: anObject [
	paneModel := anObject
]

{ #category : #visiting }
GtTreePagerPaneFollowingsLinkElementsCollector >> visitGtTreePagerLinkInactiveCollapsedState: aState [
	(self paneModel followingLinks includes: currentLinkModel)
		ifTrue: [ self addTriangleElement ].

	elementsStream
		nextPut: (GtTreePagerLinkFollowingContainerElement collapsed linkModel: currentLinkModel)
]

{ #category : #visiting }
GtTreePagerPaneFollowingsLinkElementsCollector >> visitGtTreePagerLinkState: aState [
	self addTriangleElement
]
