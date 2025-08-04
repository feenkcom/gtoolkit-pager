Class {
	#name : #GtTreePagerNonSpawnedHorizontalTreeFlowBuilder,
	#superclass : #Object,
	#traits : 'TGtTreePagerLinkStateVisitor',
	#classTraits : 'TGtTreePagerLinkStateVisitor classTrait',
	#instVars : [
		'row',
		'depth',
		'currentPaneModel',
		'sameDepthQueue',
		'nextDepthQueue',
		'currentNode',
		'linkModels',
		'nonSpawnedLinkModelBlock'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #building }
GtTreePagerNonSpawnedHorizontalTreeFlowBuilder >> build [
	self assert: [ nonSpawnedLinkModelBlock isNotNil ].
	self assert: [ linkModels isNotNil ].

	row := 1.
	depth := 1.
	sameDepthQueue := LinkedList new.
	sameDepthQueue addAll: (self nodesFromLinkModels: self linkModels).
	nextDepthQueue := LinkedList new.

	[ sameDepthQueue isEmpty ] whileFalse: [ self processQueue ]
]

{ #category : #private }
GtTreePagerNonSpawnedHorizontalTreeFlowBuilder >> buildCollapsedCurrentNode [
	(self nodesFromLinkModels: currentNode linkModel followingLinks reversed)
		do: [ :eachNode | sameDepthQueue addFirst: eachNode ]
]

{ #category : #private }
GtTreePagerNonSpawnedHorizontalTreeFlowBuilder >> buildNonSpawnedCurrentNode [
	"row := row max: currentNode row."

	nonSpawnedLinkModelBlock
		value: currentNode linkModel
		value: row
		value: depth
		value: 1.

	nextDepthQueue
		addAll: (self nodesFromLinkModels: currentNode linkModel followingLinks).
	row := row + 1
]

{ #category : #accessing }
GtTreePagerNonSpawnedHorizontalTreeFlowBuilder >> linkModels [
	^ linkModels
]

{ #category : #accessing }
GtTreePagerNonSpawnedHorizontalTreeFlowBuilder >> linkModels: aCollectionOfPaneModels [
	linkModels := aCollectionOfPaneModels
]

{ #category : #private }
GtTreePagerNonSpawnedHorizontalTreeFlowBuilder >> nodesFromLinkModels: aCollectionOfPaneModels [
	^ aCollectionOfPaneModels
		collectWithIndex: [ :eachLinkModel :anIndex | 
			GtTreePagerHorizontalTreeFlowNode new
				linkModel: eachLinkModel;
				row: row + anIndex - 1 ]
]

{ #category : #accessing }
GtTreePagerNonSpawnedHorizontalTreeFlowBuilder >> nonSpawnedLinkModelBlock [
	^ nonSpawnedLinkModelBlock
]

{ #category : #accessing }
GtTreePagerNonSpawnedHorizontalTreeFlowBuilder >> nonSpawnedLinkModelBlock: anObject [
	nonSpawnedLinkModelBlock := anObject
]

{ #category : #accessing }
GtTreePagerNonSpawnedHorizontalTreeFlowBuilder >> paneModel: aPaneModel [
	self paneModels: {aPaneModel}
]

{ #category : #private }
GtTreePagerNonSpawnedHorizontalTreeFlowBuilder >> processNode: aNode [
	currentNode := aNode.
	self visitCurrentNode.
	currentNode := nil.
]

{ #category : #building }
GtTreePagerNonSpawnedHorizontalTreeFlowBuilder >> processQueue [
	self processNode: sameDepthQueue removeFirst.

	sameDepthQueue
		ifEmpty: [ sameDepthQueue addAll: nextDepthQueue.
			nextDepthQueue removeAll.
			depth := depth + 1.
			row := 1 ]
]

{ #category : #private }
GtTreePagerNonSpawnedHorizontalTreeFlowBuilder >> visitCurrentNode [
	currentNode linkModel state acceptVisitor: self
]

{ #category : #visiting }
GtTreePagerNonSpawnedHorizontalTreeFlowBuilder >> visitGtTreePagerLinkActiveSelectedState: aState [
	self buildNonSpawnedCurrentNode.
	self visitGtTreePagerLinkState: aState.
]

{ #category : #visiting }
GtTreePagerNonSpawnedHorizontalTreeFlowBuilder >> visitGtTreePagerLinkInactiveCollapsedState: aState [
	self buildNonSpawnedCurrentNode.
	self visitGtTreePagerLinkState: aState
]

{ #category : #visiting }
GtTreePagerNonSpawnedHorizontalTreeFlowBuilder >> visitGtTreePagerLinkInactiveHiddenState: aState [
	self buildNonSpawnedCurrentNode.
	self visitGtTreePagerLinkState: aState
]
