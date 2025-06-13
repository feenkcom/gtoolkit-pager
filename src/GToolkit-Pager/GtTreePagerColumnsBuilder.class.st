Class {
	#name : #GtTreePagerColumnsBuilder,
	#superclass : #Object,
	#instVars : [
		'columns',
		'paneModel'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #building }
GtTreePagerColumnsBuilder >> build [
	columns := OrderedCollection new.
	self buildColumnFrom: {self paneModel}.
	^ columns
]

{ #category : #building }
GtTreePagerColumnsBuilder >> buildColumnFrom: aCollectionOfToolModels [
	| aPane nextToolModels |
	aCollectionOfToolModels ifEmpty: [ ^ self ].
	self assert: [ aCollectionOfToolModels allSatisfy: #isExpanded ].

	aPane := GtTreePagerColumnModel new paneModels: aCollectionOfToolModels.
	columns add: aPane.

	nextToolModels := aCollectionOfToolModels
			flatCollect: [ :each | each followingExpandedPaneModels ].

	self buildColumnFrom: nextToolModels
]

{ #category : #accessing }
GtTreePagerColumnsBuilder >> paneModel [
	^ paneModel
]

{ #category : #accessing }
GtTreePagerColumnsBuilder >> paneModel: anObject [
	paneModel := anObject
]
