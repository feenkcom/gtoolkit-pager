Class {
	#name : #GtMultiPagerColumnsBuilder,
	#superclass : #Object,
	#instVars : [
		'columns',
		'paneModel'
	],
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #building }
GtMultiPagerColumnsBuilder >> build [
	columns := OrderedCollection new.
	self buildColumnFrom: {self paneModel}.
	^ columns
]

{ #category : #building }
GtMultiPagerColumnsBuilder >> buildColumnFrom: aCollectionOfToolModels [
	| aPane nextToolModels |
	aCollectionOfToolModels ifEmpty: [ ^ self ].
	self assert: [ aCollectionOfToolModels allSatisfy: #isExpanded ].

	aPane := GtMultiPagerColumnModel new paneModels: aCollectionOfToolModels.
	columns add: aPane.

	nextToolModels := aCollectionOfToolModels
			flatCollect: [ :each | each followingExpandedPaneModels ].

	self buildColumnFrom: nextToolModels
]

{ #category : #accessing }
GtMultiPagerColumnsBuilder >> paneModel [
	^ paneModel
]

{ #category : #accessing }
GtMultiPagerColumnsBuilder >> paneModel: anObject [
	paneModel := anObject
]
