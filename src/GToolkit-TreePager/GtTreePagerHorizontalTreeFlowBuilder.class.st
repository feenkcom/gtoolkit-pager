Class {
	#name : #GtTreePagerHorizontalTreeFlowBuilder,
	#superclass : #Object,
	#traits : 'TGtTreePagerLinkStateVisitor',
	#classTraits : 'TGtTreePagerLinkStateVisitor classTrait',
	#instVars : [
		'row',
		'depth',
		'sameDepthQueue',
		'nextDepthQueue',
		'currentNode',
		'linkModels',
		'nonSpawnedLinkModelBlock',
		'spawnedLinkModelBlock',
		'replacedLinkModelBlock'
	],
	#category : #'GToolkit-TreePager-Support'
}

{ #category : #building }
GtTreePagerHorizontalTreeFlowBuilder >> build [
	self assert: [ spawnedLinkModelBlock isNotNil ].
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
GtTreePagerHorizontalTreeFlowBuilder >> buildCollapsedCurrentNode [
	(self nodesFromLinkModels: currentNode linkModel followingLinks reversed)
		do: [ :eachNode | sameDepthQueue addFirst: eachNode ]
]

{ #category : #private }
GtTreePagerHorizontalTreeFlowBuilder >> buildSpawnedCurrentNode [
	"row := row max: currentNode row."

	spawnedLinkModelBlock
		value: currentNode linkModel
		value: row
		value: depth
		value: 1.

	nextDepthQueue
		addAll: (self nodesFromLinkModels: currentNode linkModel followingLinks).
	row := row + 1
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
GtTreePagerHorizontalTreeFlowBuilder >> nonSpawnedLinkModelBlock [
	^ nonSpawnedLinkModelBlock
]

{ #category : #accessing }
GtTreePagerHorizontalTreeFlowBuilder >> nonSpawnedLinkModelBlock: anObject [
	nonSpawnedLinkModelBlock := anObject
]

{ #category : #accessing }
GtTreePagerHorizontalTreeFlowBuilder >> paneModel: aPaneModel [
	self paneModels: {aPaneModel}
]

{ #category : #private }
GtTreePagerHorizontalTreeFlowBuilder >> processNode: aNode [
	currentNode := aNode.
	self visitCurrentNode.
	self processReplacedLinks.
	currentNode := nil.
]

{ #category : #private }
GtTreePagerHorizontalTreeFlowBuilder >> processNonSpawnedCurrentNode [
	currentNode linkModel isSpawned ifTrue: [ ^ self ].
	
	nonSpawnedLinkModelBlock value: currentNode linkModel
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
GtTreePagerHorizontalTreeFlowBuilder >> processReplacedLink: aReplacedLink [
	aReplacedLink ifNil: [ ^ self ].
	replacedLinkModelBlock value: aReplacedLink.
	aReplacedLink allLinkModelsBreadthFirstDo: [ :eachLinkModel | 
		replacedLinkModelBlock value: eachLinkModel.
		self processReplacedLink: aReplacedLink replacedLink ]
]

{ #category : #private }
GtTreePagerHorizontalTreeFlowBuilder >> processReplacedLinks [
	| aReplacedLink |
	replacedLinkModelBlock ifNil: [ ^ self ].
	aReplacedLink := currentNode linkModel replacedLink.
	self processReplacedLink: aReplacedLink
]

{ #category : #accessing }
GtTreePagerHorizontalTreeFlowBuilder >> replacedLinkModelBlock [
	^ replacedLinkModelBlock
]

{ #category : #accessing }
GtTreePagerHorizontalTreeFlowBuilder >> replacedLinkModelBlock: anObject [
	replacedLinkModelBlock := anObject
]

{ #category : #accessing }
GtTreePagerHorizontalTreeFlowBuilder >> spawnedLinkModelBlock [
	^ spawnedLinkModelBlock
]

{ #category : #accessing }
GtTreePagerHorizontalTreeFlowBuilder >> spawnedLinkModelBlock: anObject [
	spawnedLinkModelBlock := anObject
]

{ #category : #private }
GtTreePagerHorizontalTreeFlowBuilder >> visitCurrentNode [
	currentNode linkModel state acceptVisitor: self
]

{ #category : #visiting }
GtTreePagerHorizontalTreeFlowBuilder >> visitGtTreePagerLinkActiveSelectedState: aState [
	self visitGtTreePagerLinkState: aState.
	currentNode linkModel allLinkModelsBreadthFirstDo: [ :eachLinkModel | 
		nonSpawnedLinkModelBlock value: eachLinkModel ]
]

{ #category : #visiting }
GtTreePagerHorizontalTreeFlowBuilder >> visitGtTreePagerLinkActiveSpawnedState: aState [
	self buildSpawnedCurrentNode.
	self visitGtTreePagerLinkState: aState
]

{ #category : #visiting }
GtTreePagerHorizontalTreeFlowBuilder >> visitGtTreePagerLinkInactiveCollapsedState: aState [
	self buildCollapsedCurrentNode.
	self visitGtTreePagerLinkState: aState
]

{ #category : #visiting }
GtTreePagerHorizontalTreeFlowBuilder >> visitGtTreePagerLinkInactiveHiddenState: aState [
	self visitGtTreePagerLinkState: aState.
	currentNode linkModel allLinkModelsBreadthFirstDo: [ :eachLinkModel | 
		nonSpawnedLinkModelBlock value: eachLinkModel ]
]

{ #category : #visiting }
GtTreePagerHorizontalTreeFlowBuilder >> visitGtTreePagerLinkInactiveRemovedState: aState [
	self visitGtTreePagerLinkState: aState.
	currentNode linkModel allLinkModelsBreadthFirstDo: [ :eachLinkModel | 
		nonSpawnedLinkModelBlock value: eachLinkModel ]
]

{ #category : #visiting }
GtTreePagerHorizontalTreeFlowBuilder >> visitGtTreePagerLinkInactiveSpawnedState: aState [
	self buildSpawnedCurrentNode.
	self visitGtTreePagerLinkState: aState
]

{ #category : #visiting }
GtTreePagerHorizontalTreeFlowBuilder >> visitGtTreePagerLinkState: aState [
	self processNonSpawnedCurrentNode
]
