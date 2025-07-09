Class {
	#name : #GtTreePagerHorizontalTreeFlowBuilder,
	#superclass : #Object,
	#traits : 'TGtTreePagerLinkStateVisitor',
	#classTraits : 'TGtTreePagerLinkStateVisitor classTrait',
	#instVars : [
		'paneModelBlock',
		'row',
		'depth',
		'currentPaneModel',
		'sameDepthQueue',
		'nextDepthQueue',
		'currentNode',
		'linkModels'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #building }
GtTreePagerHorizontalTreeFlowBuilder >> build [
	self assert: [ paneModelBlock isNotNil ].
	self assert: [ linkModels isNotNil ].

	row := 1.
	depth := 1.
	sameDepthQueue := LinkedList new.
	sameDepthQueue addAll: (self nodesFromLinkModels: self linkModels).
	nextDepthQueue := LinkedList new.

	[ sameDepthQueue isEmpty ] whileFalse: [ self processQueue ]
]

{ #category : #private }
GtTreePagerHorizontalTreeFlowBuilder >> buildCollapsedCurrentNode [
	(self nodesFromLinkModels: currentNode linkModel followingLinks reversed)
		do: [ :eachNode | sameDepthQueue addFirst: eachNode ]
]

{ #category : #private }
GtTreePagerHorizontalTreeFlowBuilder >> buildSpawnedCurrentNode [
	"row := row max: currentNode row."

	paneModelBlock
		value: currentNode linkModel
		value: row
		value: depth
		value: 1.

	nextDepthQueue
		addAll: (self nodesFromLinkModels: currentNode linkModel followingLinks).
	row := row + 1
]

{ #category : #accessing }
GtTreePagerHorizontalTreeFlowBuilder >> forEachPaneModelDo: aBlock [
	self paneModelBlock: aBlock
]

{ #category : #accessing }
GtTreePagerHorizontalTreeFlowBuilder >> linkModels [
	^ linkModels
]

{ #category : #accessing }
GtTreePagerHorizontalTreeFlowBuilder >> linkModels: aCollectionOfPaneModels [
	linkModels := aCollectionOfPaneModels
]

{ #category : #private }
GtTreePagerHorizontalTreeFlowBuilder >> nodesFromLinkModels: aCollectionOfPaneModels [
	^ aCollectionOfPaneModels
		collectWithIndex: [ :eachLinkModel :anIndex | 
			GtTreePagerHorizontalTreeFlowNode new
				linkModel: eachLinkModel;
				row: row + anIndex - 1 ]
]

{ #category : #accessing }
GtTreePagerHorizontalTreeFlowBuilder >> paneModel: aPaneModel [
	self paneModels: {aPaneModel}
]

{ #category : #accessing }
GtTreePagerHorizontalTreeFlowBuilder >> paneModelBlock [
	^ paneModelBlock
]

{ #category : #accessing }
GtTreePagerHorizontalTreeFlowBuilder >> paneModelBlock: anObject [
	paneModelBlock := anObject
]

{ #category : #private }
GtTreePagerHorizontalTreeFlowBuilder >> processNode: aNode [
	currentNode := aNode.
	self visitCurrentNode
]

{ #category : #building }
GtTreePagerHorizontalTreeFlowBuilder >> processQueue [
	self processNode: sameDepthQueue removeFirst.

	sameDepthQueue
		ifEmpty: [ sameDepthQueue addAll: nextDepthQueue.
			nextDepthQueue removeAll.
			depth := depth + 1.
			row := 1 ]
]

{ #category : #private }
GtTreePagerHorizontalTreeFlowBuilder >> visitCurrentNode [
	currentNode linkModel state acceptVisitor: self
]

{ #category : #visiting }
GtTreePagerHorizontalTreeFlowBuilder >> visitGtTreePagerLinkActiveSpawnedState: aState [
	self buildSpawnedCurrentNode
]

{ #category : #visiting }
GtTreePagerHorizontalTreeFlowBuilder >> visitGtTreePagerLinkInactiveCollapsedState: aState [
	self buildCollapsedCurrentNode
]

{ #category : #visiting }
GtTreePagerHorizontalTreeFlowBuilder >> visitGtTreePagerLinkInactiveSpawnedState: aState [
	self buildSpawnedCurrentNode
]
