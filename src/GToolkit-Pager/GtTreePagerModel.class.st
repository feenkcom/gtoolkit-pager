Class {
	#name : #GtTreePagerModel,
	#superclass : #Object,
	#instVars : [
		'columns'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'api - panes' }
GtTreePagerModel >> addPane: aPane [
	self columns: (self columns copyWith: aPane)
]

{ #category : #'api - panes' }
GtTreePagerModel >> children [
	^ self panes
]

{ #category : #'api - panes' }
GtTreePagerModel >> columns [
	^ columns
]

{ #category : #'api - panes' }
GtTreePagerModel >> columns: aCollection [
	columns = aCollection ifTrue: [ ^ self ].
	
	aCollection do: [ :eachPane | eachPane pagerModel: self ].
	columns := aCollection
]

{ #category : #'private - updating' }
GtTreePagerModel >> ensureColumnModelAfter: aColumnModel [
	| anIndex |
	anIndex := self columns
			identityIndexOf: aColumnModel
			ifAbsent: [ NotFound signal: aColumnModel in: self panes ].

	^ anIndex + 1 > self columns size
		ifTrue: [ | anotherPane |
			anotherPane := GtTreePagerColumnModel new.
			self addPane: anotherPane.
			anotherPane ]
		ifFalse: [ self columns at: anIndex + 1 ]
]

{ #category : #'api - panes' }
GtTreePagerModel >> fromPaneModel: aPaneModel [
	| someColumns |
	someColumns := GtTreePagerColumnsBuilder new
			paneModel: aPaneModel;
			build.

	self columns: someColumns
]

{ #category : #views }
GtTreePagerModel >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 10;
		stencil: [ GtTreePagerElement new pagerModel: self ]
]

{ #category : #views }
GtTreePagerModel >> gtPanesFor: aView [
	<gtView>
	columns ifNil: [ ^ aView empty ].
	^ aView columnedTree
		title: 'Panes';
		items: [ columns ];
		children: #children;
		expandUpTo: 1;
		column: 'Value' text: [ :each | each gtDisplayString ]
]

{ #category : #initialization }
GtTreePagerModel >> initialize [
	super initialize.

	columns := Array empty
]

{ #category : #'api - hooks' }
GtTreePagerModel >> onColumnModelToolsChanged: aPaneModel [
	aPaneModel paneModels
		ifEmpty: [ self removeColumnAndAfterColumns: aPaneModel ]
		ifNotEmpty: [ self onFollowingPaneModelsChangedAfterColumnModel: aPaneModel ]
]

{ #category : #'api - hooks' }
GtTreePagerModel >> onFollowingPaneModel: aPaneModel expandedAfterColumnModel: aColumnModel [
	| anotherPaneModel |
	self assert: [ aPaneModel isExpanded ].
	anotherPaneModel := self ensureColumnModelAfter: aColumnModel.
	self assert: [ (anotherPaneModel paneModels includes: aPaneModel) not ].

	anotherPaneModel onFollowingExpandedPaneModel: aPaneModel
]

{ #category : #'api - hooks' }
GtTreePagerModel >> onFollowingPaneModelsChangedAfterColumnModel: aColumnModel [
	| anotherColumnModel somePaneModels |
	somePaneModels := aColumnModel followingExpandedPaneModels.
	somePaneModels
		ifEmpty: [ self removeColumnModelsAfter: aColumnModel.
			^ self ].

	anotherColumnModel := self ensureColumnModelAfter: aColumnModel.
	anotherColumnModel paneModels: somePaneModels
]

{ #category : #'api - panes' }
GtTreePagerModel >> panes [
	self
		deprecated: 'Please use #columns instead.'
		transformWith: '`@receiver panes' -> '`@receiver columns'.
	^ self columns
]

{ #category : #'api - panes' }
GtTreePagerModel >> panes: aCollection [
	self
		deprecated: 'Please use columns: instead.'
		transformWith: '`@receiver panes: `@statements1' -> '`@receiver columns: `@statements1'.

	self columns: aCollection
]

{ #category : #'api - panes' }
GtTreePagerModel >> removeColumn: aColumn [
	self columns: (self columns copyWithout: aColumn)
]

{ #category : #'private - updating' }
GtTreePagerModel >> removeColumnAndAfterColumns: aColumnModel [
	| anIndex |
	anIndex := self columns
			identityIndexOf: aColumnModel
			ifAbsent: [ NotFound signalFor: aColumnModel in: self panes ].

	anIndex = 1
		ifTrue: [ self panes: (self panes copyFrom: 1 to: anIndex) ]
		ifFalse: [ self columns: (self columns copyFrom: 1 to: anIndex - 1) ]
]

{ #category : #'private - updating' }
GtTreePagerModel >> removeColumnModelsAfter: aColumnModel [
	| anIndex |
	anIndex := self columns
			identityIndexOf: aColumnModel
			ifAbsent: [ NotFound signalFor: aColumnModel in: self panes ].

	anIndex + 1 > self columns size ifTrue: [ ^ self ].

	self columns: (self columns copyFrom: 1 to: anIndex)
]

{ #category : #'api - panes' }
GtTreePagerModel >> removePane: aColumnModel [
	self
		deprecated: 'Please use removeColumn: instead.'
		transformWith: '`@receiver removePane: `@statements1'
				-> '`@receiver removeColumn: `@statements1'.
	self removeColumn: aColumnModel
]
