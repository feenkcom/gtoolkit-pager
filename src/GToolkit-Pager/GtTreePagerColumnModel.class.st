Class {
	#name : #GtTreePagerColumnModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'title',
		'icon',
		'announcer',
		'pagerModel',
		'paneModels'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'api - hooks' }
GtTreePagerColumnModel >> aboutToLeaveExpandedPaneModels: somePaneModels [
	self assert: [ somePaneModels allSatisfy: #isExpanded ].
	self pagerModel
		ifNotNil: [ :aPager | 
			somePaneModels
				do: [ :eachToolModel | aPager onFollowingPaneModel: eachToolModel expandedAfterColumnModel: self ] ]
]

{ #category : #'api - hooks' }
GtTreePagerColumnModel >> aboutToTakeOverPaneModel: aPaneModel [
	| newPaneModels |
	newPaneModels := aPaneModel followingExpandedPaneModels.
	self replacePaneModel: aPaneModel withPaneModels: newPaneModels
]

{ #category : #'api - pane model' }
GtTreePagerColumnModel >> addPaneModel: aToolModel [
	aToolModel columnModel: self.
	self paneModels: (self paneModels copyWith: aToolModel)
]

{ #category : #announcer }
GtTreePagerColumnModel >> announcer [
	^ announcer
]

{ #category : #accessing }
GtTreePagerColumnModel >> children [
	^ self toolModels
]

{ #category : #'api - pane model' }
GtTreePagerColumnModel >> followingExpandedPaneModels [
	^ self paneModels flatCollect: #followingExpandedPaneModels as: Array
]

{ #category : #printing }
GtTreePagerColumnModel >> gtDisplayOn: stream [
	stream nextPutAll: 'Column: '.
	self paneModels
		do: [ :eachTool | stream nextPutAll: eachTool title asString ]
		separatedBy: [ stream nextPutAll: ', ' ]
]

{ #category : #views }
GtTreePagerColumnModel >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 10;
		stencil: [ GtTreePagerColumnElement new paneModel: self ]
]

{ #category : #views }
GtTreePagerColumnModel >> gtPanesFor: aView [
	<gtView>
	paneModels ifNil: [ ^ aView empty ].

	^ aView columnedTree
		title: 'Tools';
		items: [ self toolModels ];
		children: #children;
		expandUpTo: 1;
		column: 'Value' text: [ :each | each gtDisplayString ]
]

{ #category : #accessing }
GtTreePagerColumnModel >> icon [
	^ icon
]

{ #category : #accessing }
GtTreePagerColumnModel >> icon: anObject [
	icon := anObject
]

{ #category : #initialization }
GtTreePagerColumnModel >> initialize [
	super initialize.
	announcer := Announcer new.
	title := 'Pane'.
	icon := nil.
	paneModels := Array empty
]

{ #category : #'private - notifying' }
GtTreePagerColumnModel >> notifyPaneModelsChanged [
	self pagerModel
		ifNotNil: [ :aPagerModel | aPagerModel onColumnModelToolsChanged: self ].

	self announcer
		announce: (GtTreePagerPaneModelToolsChanged new
				paneModel: self;
				toolModels: self paneModels)
]

{ #category : #'api - hooks' }
GtTreePagerColumnModel >> onFollowingExpandedPaneModel: aPaneModel [
	"The following pane should be displayed here.
	Let's first find its following expanded tool models."

	| currentPaneModels |
	self assert: [ aPaneModel isExpanded ].
	self assert: [ aPaneModel columnModel isNil ].

	currentPaneModels := aPaneModel followingExpandedPaneModels.
	currentPaneModels
		ifEmpty: [ self addPaneModel: aPaneModel ]
		ifNotEmpty: [ self replacePaneModels: currentPaneModels withPaneModel: aPaneModel ]
]

{ #category : #'api - hooks' }
GtTreePagerColumnModel >> onFollowingPaneModelExpansionChanged: aPaneModel [
	aPaneModel isCollapsed ifTrue: [ ^ self ].
	self assert: [ aPaneModel columnModel isNil ].

	self pagerModel
		ifNotNil: [ :aPager | aPager onFollowingPaneModel: aPaneModel expandedAfterColumnModel: self ]
]

{ #category : #'api - hooks' }
GtTreePagerColumnModel >> onFollowingPaneModelsChanged: aPaneModel [
	"Let's push following pane models to a next column."

	self pagerModel
		ifNotNil: [ :aPager | aPager onFollowingPaneModelsChangedAfterColumnModel: self ]
]

{ #category : #'api - hooks' }
GtTreePagerColumnModel >> onPaneModelExpansionChanged: aPaneModel [
	| newPaneModels |
	aPaneModel isExpanded ifTrue: [ ^ self ].

	newPaneModels := aPaneModel followingExpandedPaneModels.
	self replacePaneModel: aPaneModel withPaneModels: newPaneModels
]

{ #category : #accessing }
GtTreePagerColumnModel >> pagerModel [
	^ pagerModel
]

{ #category : #accessing }
GtTreePagerColumnModel >> pagerModel: anObject [
	pagerModel := anObject
]

{ #category : #'api - pane model' }
GtTreePagerColumnModel >> paneModel: aPaneModel [
	self addPaneModel: aPaneModel
]

{ #category : #'api - pane model' }
GtTreePagerColumnModel >> paneModels [
	^ paneModels
]

{ #category : #'api - pane model' }
GtTreePagerColumnModel >> paneModels: aCollection [
	paneModels = aCollection ifTrue: [ ^ self ].

	aCollection do: [ :each | each columnModel: self ].
	paneModels := aCollection.

	self notifyPaneModelsChanged
]

{ #category : #'private - updating' }
GtTreePagerColumnModel >> replacePaneModel: aPaneModel withPaneModels: newPaneModels [
	| newCollection isFound |
	isFound := false.
	newCollection := Array
			new: 1
			streamContents: [ :aStream | 
				self paneModels
					do: [ :eachTool | 
						eachTool == aPaneModel
							ifFalse: [ aStream nextPut: eachTool ]
							ifTrue: [ self
									assert: isFound not
									description: [ 'Tool model can exist in one collection only once.' ].
								isFound := true.
								aStream nextPutAll: newPaneModels ] ] ].

	self
		assert: isFound
		description: [ 'Can replace only tool model that exists in my collection' ].

	newPaneModels
		do: [ :eachTool | 
			eachTool columnModel
				ifNotNil: [ :eachPane | eachPane aboutToTakeOverPaneModel: eachTool ] ].

	aPaneModel columnModel: nil.
	self paneModels: newCollection
]

{ #category : #'private - updating' }
GtTreePagerColumnModel >> replacePaneModels: currentPaneModels withPaneModel: aPaneModel [
	| newCollection isFound |
	isFound := false.
	newCollection := Array
			new: 1
			streamContents: [ :aStream | 
				self paneModels
					do: [ :eachTool | 
						(currentPaneModels identityIncludes: eachTool)
							ifFalse: [ aStream nextPut: eachTool ]
							ifTrue: [ isFound
									ifFalse: [ isFound := true.
										aStream nextPut: aPaneModel ] ] ] ].

	self
		assert: isFound
		description: [ 'Can replace only tool models that exist in my collection' ].

	currentPaneModels do: [ :eachTool | eachTool columnModel: nil ].
	self aboutToLeaveExpandedPaneModels: currentPaneModels.
	self paneModels: newCollection
]

{ #category : #accessing }
GtTreePagerColumnModel >> title [
	^ title
		ifNil: [ self toolModels
				ifNotEmpty: [ :aCollection | aCollection anyOne title ]
				ifEmpty: [ nil ] ]
]

{ #category : #accessing }
GtTreePagerColumnModel >> title: anObject [
	title := anObject
]

{ #category : #'api - pane model' }
GtTreePagerColumnModel >> toolModel: aPaneModel [
	self
		deprecated: 'Please use paneModel: instead.'
		transformWith: '`@receiver toolModel: `@statements1' -> '`@receiver paneModel: `@statements1'.
	self paneModel: aPaneModel
]

{ #category : #'api - pane model' }
GtTreePagerColumnModel >> toolModels [
	self
		deprecated: 'Please use paneModels instead.'
		transformWith: '`@receiver toolModels' -> '`@receiver paneModels'.

	^ self paneModels
]

{ #category : #'api - pane model' }
GtTreePagerColumnModel >> toolModels: aCollection [
	self
		deprecated: 'Please use paneModels: instead.'
		transformWith: '`@receiver toolModels: `@statements1' -> '`@receiver paneModels: `@statements1'.

	self paneModels: aCollection
]

{ #category : #'api - pane model' }
GtTreePagerColumnModel >> toolStencil: aStencil [
	self toolModel: (GtTreePagerExplicitToolBuilder new stencil: aStencil asStencil)
]
