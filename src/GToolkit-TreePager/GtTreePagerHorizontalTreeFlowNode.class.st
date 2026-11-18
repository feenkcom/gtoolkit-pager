Class {
	#name : #GtTreePagerHorizontalTreeFlowNode,
	#superclass : #Object,
	#instVars : [
		'row',
		'linkModel'
	],
	#category : #'GToolkit-TreePager-Support'
}

{ #category : #printing }
GtTreePagerHorizontalTreeFlowNode >> gtDisplayOn: stream [
	stream nextPutAll: 'Node: '.
	stream nextPutAll: (self linkModel ifNotNil: [ :v | v title ]) asString
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
	aStream nextPutAll: (self linkModel ifNotNil: [ :v | v title ]) asString.
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
