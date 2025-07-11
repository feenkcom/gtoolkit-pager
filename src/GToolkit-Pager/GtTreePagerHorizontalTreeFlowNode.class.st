Class {
	#name : #GtTreePagerHorizontalTreeFlowNode,
	#superclass : #Object,
	#instVars : [
		'row',
		'linkModel'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #printing }
GtTreePagerHorizontalTreeFlowNode >> gtDisplayOn: stream [
	stream nextPutAll: 'Node: '.
	stream nextPutAll: (self linkModel ifNotNil: #title) asString
]

{ #category : #accessing }
GtTreePagerHorizontalTreeFlowNode >> linkModel [
	^ linkModel
]

{ #category : #accessing }
GtTreePagerHorizontalTreeFlowNode >> linkModel: aPaneModel [
	linkModel := aPaneModel
]

{ #category : #printing }
GtTreePagerHorizontalTreeFlowNode >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: (self linkModel ifNotNil: #title) asString.
	aStream nextPut: $)
]

{ #category : #accessing }
GtTreePagerHorizontalTreeFlowNode >> row [
	^ row
]

{ #category : #accessing }
GtTreePagerHorizontalTreeFlowNode >> row: anObject [
	row := anObject
]
