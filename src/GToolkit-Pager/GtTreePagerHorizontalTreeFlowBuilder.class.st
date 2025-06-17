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

	sameDepthQueue := LinkedList new.
	sameDepthQueue addAll: (self nodesFromPaneModels: self paneModels shift: 0).
	nextDepthQueue := LinkedList new.
	row := 1.
	depth := 1.

	[ sameDepthQueue isEmpty ] whileFalse: [ self processQueue ]
]

{ #category : #accessing }
GtTreePagerHorizontalTreeFlowBuilder >> forEachPaneModelDo: aBlock [
	self paneModelBlock: aBlock
]

{ #category : #private }
GtTreePagerHorizontalTreeFlowBuilder >> nodesFromPaneModels: aCollectionOfPaneModels shift: anInteger [
	^ aCollectionOfPaneModels
		collect: [ :eachPaneModel | 
			GtTreePagerHorizontalTreeFlowNode new
				paneModel: eachPaneModel;
				shift: anInteger ]
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
	paneModelBlock
		value: aNode paneModel
		value: (aNode paneModel isExpanded ifTrue: [ row + aNode shift ] ifFalse: [ nil ])
		value: (aNode paneModel isExpanded ifTrue: [ depth ] ifFalse: [ nil ]).

	aNode paneModel isExpanded
		ifTrue: [ nextDepthQueue
				addAll: (self nodesFromPaneModels: aNode paneModel followingPanes shift: row - 1).
			row := row + 1 ]
		ifFalse: [ (self
				nodesFromPaneModels: aNode paneModel followingPanes reversed
				shift: row - 1) do: [ :eachNode | sameDepthQueue addFirst: eachNode ] ]
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
