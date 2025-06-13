Class {
	#name : #GtMultiPagerPanesBuilder,
	#superclass : #Object,
	#instVars : [
		'toolModel',
		'panes'
	],
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #building }
GtMultiPagerPanesBuilder >> build [
	panes := OrderedCollection new.
	self buildPaneFrom: {self toolModel}.
	^ panes
]

{ #category : #building }
GtMultiPagerPanesBuilder >> buildPaneFrom: aCollectionOfToolModels [
	| aPane nextToolModels |
	aCollectionOfToolModels ifEmpty: [ ^ self ].
	self assert: [ aCollectionOfToolModels allSatisfy: #isExpanded ].

	aPane := GtMultiPagerPaneModel new toolModels: aCollectionOfToolModels.
	panes add: aPane.

	nextToolModels := aCollectionOfToolModels
			flatCollect: [ :each | each followingExpandedToolModels ].

	self buildPaneFrom: nextToolModels
]

{ #category : #accessing }
GtMultiPagerPanesBuilder >> toolModel [
	^ toolModel
]

{ #category : #accessing }
GtMultiPagerPanesBuilder >> toolModel: anObject [
	toolModel := anObject
]
