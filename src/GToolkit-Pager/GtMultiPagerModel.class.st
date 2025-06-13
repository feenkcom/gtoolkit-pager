Class {
	#name : #GtMultiPagerModel,
	#superclass : #Object,
	#instVars : [
		'panes'
	],
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #'api - panes' }
GtMultiPagerModel >> addPane: aPane [
	self panes: (self panes copyWith: aPane)
]

{ #category : #'api - panes' }
GtMultiPagerModel >> children [
	^ self panes
]

{ #category : #'private - updating' }
GtMultiPagerModel >> ensurePaneModelAfter: aPaneModel [
	| anIndex |
	anIndex := self panes
			identityIndexOf: aPaneModel
			ifAbsent: [ NotFound signal: aPaneModel in: self panes ].

	^ anIndex + 1 > self panes size
		ifTrue: [ | anotherPane |
			anotherPane := GtMultiPagerPaneModel new.
			self addPane: anotherPane.
			anotherPane ]
		ifFalse: [ self panes at: anIndex + 1 ]
]

{ #category : #'api - panes' }
GtMultiPagerModel >> fromToolModel: aToolModel [
	| somePanes |
	somePanes := GtMultiPagerPanesBuilder new
			toolModel: aToolModel;
			build.

	self panes: somePanes
]

{ #category : #views }
GtMultiPagerModel >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 10;
		stencil: [ GtMultiPagerElement new pagerModel: self ]
]

{ #category : #views }
GtMultiPagerModel >> gtPanesFor: aView [
	<gtView>
	panes ifNil: [ ^ aView empty ].
	^ aView columnedTree
		title: 'Panes';
		items: [ panes ];
		children: #children;
		expandUpTo: 1;
		column: 'Value' text: [ :each | each gtDisplayString ]
]

{ #category : #initialization }
GtMultiPagerModel >> initialize [
	super initialize.

	panes := Array empty
]

{ #category : #'api - hooks' }
GtMultiPagerModel >> onFollowingToolModel: aToolModel expandedAfterPaneModel: aPaneModel [
	| anotherPaneModel |
	self assert: [ aToolModel isExpanded ].
	anotherPaneModel := self ensurePaneModelAfter: aPaneModel.
	self assert: [ (anotherPaneModel toolModels includes: aToolModel) not ].

	anotherPaneModel onFollowingExpandedToolModel: aToolModel
]

{ #category : #'api - hooks' }
GtMultiPagerModel >> onPaneModelToolsChanged: aPaneModel [
	aPaneModel toolModels ifNotEmpty: [ ^ self ].

	self removePane: aPaneModel
]

{ #category : #'api - panes' }
GtMultiPagerModel >> panes [
	^ panes
]

{ #category : #'api - panes' }
GtMultiPagerModel >> panes: aCollection [
	panes = aCollection ifTrue: [ ^ self ].
	
	aCollection do: [ :eachPane | eachPane pagerModel: self ].
	panes := aCollection
]

{ #category : #'api - panes' }
GtMultiPagerModel >> removePane: aPane [
	self panes: (self panes copyWithout: aPane)
]
