Class {
	#name : #GtTreePagerHorizontalTreeFlowBuilder,
	#superclass : #Object,
	#instVars : [
		'paneModels',
		'paneModelBlock',
		'row',
		'depth',
		'currentPaneModel',
		'sameDepthQueue',
		'nextDepthQueue'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #building }
GtTreePagerHorizontalTreeFlowBuilder >> build [
	self assert: [ paneModelBlock isNotNil ].
	self assert: [ paneModels isNotNil ].

	row := 1.
	depth := 1.
	sameDepthQueue := LinkedList new.
	sameDepthQueue addAll: (self nodesFromPaneModels: self paneModels).
	nextDepthQueue := LinkedList new.

	[ sameDepthQueue isEmpty ] whileFalse: [ self processQueue ]
]

{ #category : #accessing }
GtTreePagerHorizontalTreeFlowBuilder >> forEachPaneModelDo: aBlock [
	self paneModelBlock: aBlock
]

{ #category : #private }
GtTreePagerHorizontalTreeFlowBuilder >> nodesFromPaneModels: aCollectionOfPaneModels [
	^ aCollectionOfPaneModels
		collectWithIndex: [ :eachPaneModel :anIndex | 
			GtTreePagerHorizontalTreeFlowNode new
				paneModel: eachPaneModel;
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

{ #category : #accessing }
GtTreePagerHorizontalTreeFlowBuilder >> paneModels [
	^ paneModels
]

{ #category : #accessing }
GtTreePagerHorizontalTreeFlowBuilder >> paneModels: aCollectionOfPaneModels [
	paneModels := aCollectionOfPaneModels
]

{ #category : #private }
GtTreePagerHorizontalTreeFlowBuilder >> processNode: aNode [
	row := row max: aNode row.
	paneModelBlock
		value: aNode paneModel
		value: (aNode paneModel isExpanded ifTrue: [ row ] ifFalse: [ nil ])
		value: (aNode paneModel isExpanded ifTrue: [ depth ] ifFalse: [ nil ]).

	aNode paneModel isExpanded
		ifTrue: [ nextDepthQueue
				addAll: (self nodesFromPaneModels: aNode paneModel followingPanes).
			row := row + 1 ]
		ifFalse: [ (self nodesFromPaneModels: aNode paneModel followingPanes reversed)
				do: [ :eachNode | sameDepthQueue addFirst: eachNode ] ]
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
