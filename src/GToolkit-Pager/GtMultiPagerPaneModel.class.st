Class {
	#name : #GtMultiPagerPaneModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'title',
		'icon',
		'toolModels',
		'announcer',
		'pagerModel'
	],
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #'api - hooks' }
GtMultiPagerPaneModel >> aboutToLeaveExpandedToolModels: someToolModels [
	self assert: [ someToolModels allSatisfy: #isExpanded ].
	self pagerModel
		ifNotNil: [ :aPager | 
			someToolModels
				do: [ :eachToolModel | aPager onFollowingToolModel: eachToolModel expandedAfterPaneModel: self ] ]
]

{ #category : #'api - hooks' }
GtMultiPagerPaneModel >> aboutToTakeOverToolModel: aToolModel [
	| newToolModels |
	newToolModels := aToolModel followingExpandedToolModels.
	self replaceToolModel: aToolModel withToolModels: newToolModels
]

{ #category : #'api - tool model' }
GtMultiPagerPaneModel >> addToolModel: aToolModel [
	aToolModel paneModel: self.
	self toolModels: (self toolModels copyWith: aToolModel)
]

{ #category : #announcer }
GtMultiPagerPaneModel >> announcer [
	^ announcer
]

{ #category : #accessing }
GtMultiPagerPaneModel >> children [
	^ self toolModels
]

{ #category : #'api - tool model' }
GtMultiPagerPaneModel >> followingExpandedToolModels [
	^ self toolModels flatCollect: #followingExpandedToolModels as: Array
]

{ #category : #printing }
GtMultiPagerPaneModel >> gtDisplayOn: stream [
	stream nextPutAll: 'Pane model: '.
	self toolModels
		do: [ :eachTool | stream nextPutAll: eachTool title asString ]
		separatedBy: [ stream nextPutAll: ', ' ]
]

{ #category : #views }
GtMultiPagerPaneModel >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 10;
		stencil: [ GtMultiPagerPaneElement new paneModel: self ]
]

{ #category : #views }
GtMultiPagerPaneModel >> gtPanesFor: aView [
	<gtView>
	toolModels ifNil: [ ^ aView empty ].

	^ aView columnedTree
		title: 'Tools';
		items: [ self toolModels ];
		children: #children;
		expandUpTo: 1;
		column: 'Value' text: [ :each | each gtDisplayString ]
]

{ #category : #accessing }
GtMultiPagerPaneModel >> icon [
	^ icon
]

{ #category : #accessing }
GtMultiPagerPaneModel >> icon: anObject [
	icon := anObject
]

{ #category : #initialization }
GtMultiPagerPaneModel >> initialize [
	super initialize.
	announcer := Announcer new.
	title := 'Pane'.
	icon := nil.
	toolModels := Array empty
]

{ #category : #'private - notifying' }
GtMultiPagerPaneModel >> notifyToolModelsChanged [
	self pagerModel ifNotNil: [ :aPagerModel | aPagerModel onPaneModelToolsChanged: self ].

	self announcer
		announce: (GtMultiPagerPaneModelToolsChanged new
				paneModel: self;
				toolModels: self toolModels)
]

{ #category : #'api - hooks' }
GtMultiPagerPaneModel >> onFollowingExpandedToolModel: aToolModel [
	"The following tool should be displayed here.
	Let's first find its following expanded tool models."

	| currentToolModels |
	self assert: [ aToolModel isExpanded ].
	self assert: [ aToolModel paneModel isNil ].

	currentToolModels := aToolModel followingExpandedToolModels.
	currentToolModels
		ifEmpty: [ self addToolModel: aToolModel ]
		ifNotEmpty: [ self replaceToolModels: currentToolModels withToolModel: aToolModel ]
]

{ #category : #'api - hooks' }
GtMultiPagerPaneModel >> onFollowingToolModelExpansionChanged: aToolModel [
	aToolModel isCollapsed ifTrue: [ ^ self ].
	self assert: [ aToolModel paneModel isNil ].

	self pagerModel
		ifNotNil: [ :aPager | aPager onFollowingToolModel: aToolModel expandedAfterPaneModel: self ]
]

{ #category : #'api - hooks' }
GtMultiPagerPaneModel >> onFollowingToolModelsChanged: aToolModel [
	"Let's push following tool models to a next pane."

	self pagerModel
		ifNotNil: [ :aPager | aPager onFollowingToolModelsChangedAfterPaneModel: self ]
]

{ #category : #'api - hooks' }
GtMultiPagerPaneModel >> onToolModelExpansionChanged: aToolModel [
	| newToolModels |
	aToolModel isExpanded ifTrue: [ ^ self ].

	newToolModels := aToolModel followingExpandedToolModels.
	self replaceToolModel: aToolModel withToolModels: newToolModels
]

{ #category : #accessing }
GtMultiPagerPaneModel >> pagerModel [
	^ pagerModel
]

{ #category : #accessing }
GtMultiPagerPaneModel >> pagerModel: anObject [
	pagerModel := anObject
]

{ #category : #'private - updating' }
GtMultiPagerPaneModel >> replaceToolModel: aToolModel withToolModels: newToolModels [
	| newCollection isFound |
	isFound := false.
	newCollection := Array
			new: 1
			streamContents: [ :aStream | 
				self toolModels
					do: [ :eachTool | 
						eachTool == aToolModel
							ifFalse: [ aStream nextPut: eachTool ]
							ifTrue: [ self
									assert: isFound not
									description: [ 'Tool model can exist in one collection only once.' ].
								isFound := true.
								aStream nextPutAll: newToolModels ] ] ].

	self
		assert: isFound
		description: [ 'Can replace only tool model that exists in my collection' ].

	newToolModels
		do: [ :eachTool | 
			eachTool paneModel
				ifNotNil: [ :eachPane | eachPane aboutToTakeOverToolModel: eachTool ] ].

	aToolModel paneModel: nil.
	self toolModels: newCollection
]

{ #category : #'private - updating' }
GtMultiPagerPaneModel >> replaceToolModels: currentToolModels withToolModel: aToolModel [
	| newCollection isFound |
	isFound := false.
	newCollection := Array
			new: 1
			streamContents: [ :aStream | 
				self toolModels
					do: [ :eachTool | 
						(currentToolModels identityIncludes: eachTool)
							ifFalse: [ aStream nextPut: eachTool ]
							ifTrue: [ isFound
									ifFalse: [ isFound := true.
										aStream nextPut: aToolModel ] ] ] ].

	self
		assert: isFound
		description: [ 'Can replace only tool models that exist in my collection' ].

	currentToolModels do: [ :eachTool | eachTool paneModel: nil ].
	self aboutToLeaveExpandedToolModels: currentToolModels.
	self toolModels: newCollection
]

{ #category : #accessing }
GtMultiPagerPaneModel >> title [
	^ title
		ifNil: [ self toolModels
				ifNotEmpty: [ :aCollection | aCollection anyOne title ]
				ifEmpty: [ nil ] ]
]

{ #category : #accessing }
GtMultiPagerPaneModel >> title: anObject [
	title := anObject
]

{ #category : #'api - tool model' }
GtMultiPagerPaneModel >> toolModel: aToolModel [
	self addToolModel: aToolModel
]

{ #category : #'api - tool model' }
GtMultiPagerPaneModel >> toolModels [
	^ toolModels
]

{ #category : #'api - tool model' }
GtMultiPagerPaneModel >> toolModels: aCollection [
	toolModels = aCollection ifTrue: [ ^ self ].

	aCollection do: [ :each | each paneModel: self ].
	toolModels := aCollection.
	
	self notifyToolModelsChanged
]

{ #category : #'api - tool model' }
GtMultiPagerPaneModel >> toolStencil: aStencil [
	self toolModel: (GtMultiPagerExplicitToolBuilder new stencil: aStencil asStencil)
]
