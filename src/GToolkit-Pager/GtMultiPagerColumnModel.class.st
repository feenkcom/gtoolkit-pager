Class {
	#name : #GtMultiPagerColumnModel,
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
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #'api - hooks' }
GtMultiPagerColumnModel >> aboutToLeaveExpandedPaneModels: somePaneModels [
	self assert: [ somePaneModels allSatisfy: #isExpanded ].
	self pagerModel
		ifNotNil: [ :aPager | 
			somePaneModels
				do: [ :eachToolModel | aPager onFollowingPaneModel: eachToolModel expandedAfterColumnModel: self ] ]
]

{ #category : #'api - hooks' }
GtMultiPagerColumnModel >> aboutToTakeOverPaneModel: aPaneModel [
	| newPaneModels |
	newPaneModels := aPaneModel followingExpandedPaneModels.
	self replacePaneModel: aPaneModel withPaneModels: newPaneModels
]

{ #category : #'api - pane model' }
GtMultiPagerColumnModel >> addPaneModel: aToolModel [
	aToolModel columnModel: self.
	self paneModels: (self paneModels copyWith: aToolModel)
]

{ #category : #announcer }
GtMultiPagerColumnModel >> announcer [
	^ announcer
]

{ #category : #accessing }
GtMultiPagerColumnModel >> children [
	^ self toolModels
]

{ #category : #'api - pane model' }
GtMultiPagerColumnModel >> followingExpandedPaneModels [
	^ self paneModels flatCollect: #followingExpandedPaneModels as: Array
]

{ #category : #printing }
GtMultiPagerColumnModel >> gtDisplayOn: stream [
	stream nextPutAll: 'Column: '.
	self paneModels
		do: [ :eachTool | stream nextPutAll: eachTool title asString ]
		separatedBy: [ stream nextPutAll: ', ' ]
]

{ #category : #views }
GtMultiPagerColumnModel >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 10;
		stencil: [ GtMultiPagerColumnElement new paneModel: self ]
]

{ #category : #views }
GtMultiPagerColumnModel >> gtPanesFor: aView [
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
GtMultiPagerColumnModel >> icon [
	^ icon
]

{ #category : #accessing }
GtMultiPagerColumnModel >> icon: anObject [
	icon := anObject
]

{ #category : #initialization }
GtMultiPagerColumnModel >> initialize [
	super initialize.
	announcer := Announcer new.
	title := 'Pane'.
	icon := nil.
	paneModels := Array empty
]

{ #category : #'private - notifying' }
GtMultiPagerColumnModel >> notifyPaneModelsChanged [
	self pagerModel
		ifNotNil: [ :aPagerModel | aPagerModel onColumnModelToolsChanged: self ].

	self announcer
		announce: (GtMultiPagerPaneModelToolsChanged new
				paneModel: self;
				toolModels: self paneModels)
]

{ #category : #'api - hooks' }
GtMultiPagerColumnModel >> onFollowingExpandedPaneModel: aPaneModel [
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
GtMultiPagerColumnModel >> onFollowingPaneModelExpansionChanged: aPaneModel [
	aPaneModel isCollapsed ifTrue: [ ^ self ].
	self assert: [ aPaneModel columnModel isNil ].

	self pagerModel
		ifNotNil: [ :aPager | aPager onFollowingPaneModel: aPaneModel expandedAfterColumnModel: self ]
]

{ #category : #'api - hooks' }
GtMultiPagerColumnModel >> onFollowingPaneModelsChanged: aPaneModel [
	"Let's push following pane models to a next column."

	self pagerModel
		ifNotNil: [ :aPager | aPager onFollowingPaneModelsChangedAfterColumnModel: self ]
]

{ #category : #'api - hooks' }
GtMultiPagerColumnModel >> onPaneModelExpansionChanged: aPaneModel [
	| newPaneModels |
	aPaneModel isExpanded ifTrue: [ ^ self ].

	newPaneModels := aPaneModel followingExpandedPaneModels.
	self replacePaneModel: aPaneModel withPaneModels: newPaneModels
]

{ #category : #accessing }
GtMultiPagerColumnModel >> pagerModel [
	^ pagerModel
]

{ #category : #accessing }
GtMultiPagerColumnModel >> pagerModel: anObject [
	pagerModel := anObject
]

{ #category : #'api - pane model' }
GtMultiPagerColumnModel >> paneModel: aPaneModel [
	self addPaneModel: aPaneModel
]

{ #category : #'api - pane model' }
GtMultiPagerColumnModel >> paneModels [
	^ paneModels
]

{ #category : #'api - pane model' }
GtMultiPagerColumnModel >> paneModels: aCollection [
	paneModels = aCollection ifTrue: [ ^ self ].

	aCollection do: [ :each | each columnModel: self ].
	paneModels := aCollection.

	self notifyPaneModelsChanged
]

{ #category : #'private - updating' }
GtMultiPagerColumnModel >> replacePaneModel: aPaneModel withPaneModels: newPaneModels [
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
GtMultiPagerColumnModel >> replacePaneModels: currentPaneModels withPaneModel: aPaneModel [
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
GtMultiPagerColumnModel >> title [
	^ title
		ifNil: [ self toolModels
				ifNotEmpty: [ :aCollection | aCollection anyOne title ]
				ifEmpty: [ nil ] ]
]

{ #category : #accessing }
GtMultiPagerColumnModel >> title: anObject [
	title := anObject
]

{ #category : #'api - pane model' }
GtMultiPagerColumnModel >> toolModel: aPaneModel [
	self
		deprecated: 'Please use paneModel: instead.'
		transformWith: '`@receiver toolModel: `@statements1' -> '`@receiver paneModel: `@statements1'.
	self paneModel: aPaneModel
]

{ #category : #'api - pane model' }
GtMultiPagerColumnModel >> toolModels [
	self
		deprecated: 'Please use paneModels instead.'
		transformWith: '`@receiver toolModels' -> '`@receiver paneModels'.

	^ self paneModels
]

{ #category : #'api - pane model' }
GtMultiPagerColumnModel >> toolModels: aCollection [
	self
		deprecated: 'Please use paneModels: instead.'
		transformWith: '`@receiver toolModels: `@statements1' -> '`@receiver paneModels: `@statements1'.

	self paneModels: aCollection
]

{ #category : #'api - pane model' }
GtMultiPagerColumnModel >> toolStencil: aStencil [
	self toolModel: (GtMultiPagerExplicitToolBuilder new stencil: aStencil asStencil)
]
