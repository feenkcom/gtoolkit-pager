Class {
	#name : #GtMultiPagerToolModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'toolBuilder',
		'followingTools',
		'previousTool',
		'isCollapsed',
		'title',
		'icon',
		'paneModel',
		'announcer',
		'isFastened'
	],
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #'api - following tools' }
GtMultiPagerToolModel >> addFollowingTool: aToolModel [
	self followingTools: (self followingTools copyWith: aToolModel)
]

{ #category : #announcer }
GtMultiPagerToolModel >> announcer [
	<return: #Announcer>
	^ announcer
]

{ #category : #converting }
GtMultiPagerToolModel >> asElement [
	<return: #BlElement>
	^ self toolBuilder asElement
]

{ #category : #accessing }
GtMultiPagerToolModel >> children [
	^ self followingTools
]

{ #category : #'api - expandable' }
GtMultiPagerToolModel >> collapse [
	self collapse: true
]

{ #category : #'api - expandable' }
GtMultiPagerToolModel >> collapse: aBoolean [
	isCollapsed = aBoolean ifTrue: [ ^ self ].

	isCollapsed := aBoolean.
	self notifyExpansionChanged
]

{ #category : #accessing }
GtMultiPagerToolModel >> collapsedChainCount [
	self isCollapsed ifFalse: [ ^ 0 ].
	self hasFollowingTool ifFalse: [ ^ 1 ].
	(self followingTools allSatisfy: #isCollapsed) ifFalse: [ ^ 1 ].

	^ (self followingTools detectMin: [ :each | each collapsedChainCount ])
		collapsedChainCount
]

{ #category : #'api - expandable' }
GtMultiPagerToolModel >> expand [
	self expand: true
]

{ #category : #'api - expandable' }
GtMultiPagerToolModel >> expand: aBoolean [
	self collapse: aBoolean not
]

{ #category : #'api - fastening' }
GtMultiPagerToolModel >> fasten [
	self fasten: true
]

{ #category : #'api - fastening' }
GtMultiPagerToolModel >> fasten: aBoolean [
	isFastened = aBoolean ifTrue: [ ^ self ].

	isFastened := aBoolean
]

{ #category : #'api - following tools' }
GtMultiPagerToolModel >> followingExpandedToolModels [
	^ Array
		streamContents: [ :aStream | 
			self followingTools
				do: [ :eachTool | 
					eachTool isExpanded
						ifTrue: [ aStream nextPut: eachTool ]
						ifFalse: [ aStream nextPutAll: eachTool followingExpandedToolModels ] ] ]
]

{ #category : #'api - following tools' }
GtMultiPagerToolModel >> followingTools [
	^ followingTools
]

{ #category : #'api - following tools' }
GtMultiPagerToolModel >> followingTools: aCollection [
	followingTools = aCollection ifTrue: [ ^ self ].

	aCollection do: [ :each | each previousTool: self ].
	followingTools := aCollection.
	
	self notifyFollowingToolsChanged
]

{ #category : #printing }
GtMultiPagerToolModel >> gtDisplayOn: stream [
	stream nextPutAll: 'Pane: '.
	stream nextPutAll: self title asString.
	(self isCollapsed or: [ self isFastened ]) ifFalse: [ ^ self ].

	stream nextPutAll: ' ('.
	self isCollapsed ifTrue: [ stream nextPutAll: 'collapsed' ].
	self isFastened
		ifTrue: [ self isCollapsed
				ifTrue: [ stream nextPutAll: ', ' ]
				ifFalse: [ stream nextPutAll: 'fastened' ] ].
	stream nextPut: $)
]

{ #category : #views }
GtMultiPagerToolModel >> gtFollowingToolsFor: aView [
	<gtView>
	self followingTools ifNil: [ ^ aView empty ].
	^ aView columnedTree
		title: 'Tools';
		items: [ {self} ];
		children: #followingTools;
		expandUpTo: 1;
		column: 'Title' text: [ :each | each title ];
		column: 'Expanded'
			text: [ :each | 
				each isExpanded
					ifTrue: [ 'yes' ]
					ifFalse: [ 'no' asRopedText foreground: BlTheme default button disabledTextColor ] ]
			width: 70
]

{ #category : #views }
GtMultiPagerToolModel >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 10;
		stencil: [ GtMultiPagerToolElement new toolModel: self ]
]

{ #category : #testing }
GtMultiPagerToolModel >> hasFollowingTool [
	^ self followingTools isNotEmpty
]

{ #category : #accessing }
GtMultiPagerToolModel >> icon [
	^ icon ifNil: [ self toolBuilder icon ]
]

{ #category : #accessing }
GtMultiPagerToolModel >> icon: anObject [
	icon := anObject
]

{ #category : #initialization }
GtMultiPagerToolModel >> initialize [
	super initialize.
	announcer := Announcer new.
	followingTools := Array empty.
	isCollapsed := false.
	isFastened := false.
]

{ #category : #'api - expandable' }
GtMultiPagerToolModel >> isCollapsed [
	^ isCollapsed ifNil: [ false ]
]

{ #category : #'api - expandable' }
GtMultiPagerToolModel >> isExpanded [
	^ self isCollapsed not
]

{ #category : #'api - fastening' }
GtMultiPagerToolModel >> isFastened [
	^ isFastened
]

{ #category : #'api - fastening' }
GtMultiPagerToolModel >> isUnfastened [
	^ self isFastened not
]

{ #category : #'api - expandable' }
GtMultiPagerToolModel >> notifyExpansionChanged [
	self paneModel
		ifNotNil: [ :aPaneModel | aPaneModel onToolModelExpansionChanged: self ]
		ifNil: [ self previousExpandedToolModel
				ifNotNil: [ :aPreviousTool | 
					aPreviousTool paneModel
						ifNotNil: [ :aPaneModel | aPaneModel onFollowingToolModelExpansionChanged: self ] ] ].

	self announcer
		announce: (GtMultiPagerToolModelExpansionChanged new
				toolModel: self;
				isCollapsed: self isCollapsed)
]

{ #category : #'private - notifying' }
GtMultiPagerToolModel >> notifyFollowingToolsChanged [
	self paneModel
		ifNotNil: [ :aPaneModel | aPaneModel onFollowingToolModelsChanged: self ]
]

{ #category : #accessing }
GtMultiPagerToolModel >> paneModel [
	^ paneModel
]

{ #category : #accessing }
GtMultiPagerToolModel >> paneModel: aPaneModel [
	paneModel := aPaneModel
]

{ #category : #accessing }
GtMultiPagerToolModel >> previousExpandedToolModel [
	<return: #GtMultiPagerToolModel or: nil>
	^ self previousTool
		ifNotNil: [ :aPreviousTool | 
			aPreviousTool isExpanded
				ifTrue: [ aPreviousTool ]
				ifFalse: [ aPreviousTool previousExpandedToolModel ] ]
]

{ #category : #accessing }
GtMultiPagerToolModel >> previousTool [
	^ previousTool
]

{ #category : #accessing }
GtMultiPagerToolModel >> previousTool: aToolModel [
	previousTool := aToolModel
]

{ #category : #'private - updating' }
GtMultiPagerToolModel >> replaceFollowingTool: anOldToolModel by: aNewToolModel [
	| anIndex |
	anIndex := self followingTools
			detectIndex: [ :each | each == anOldToolModel ]
			ifNone: [ NotFound signalFor: anOldToolModel in: self followingTools ].

	aNewToolModel previousTool: self.
	anOldToolModel previousTool: nil.
	self followingTools at: anIndex put: aNewToolModel.
	
	self notifyFollowingToolsChanged
]

{ #category : #'api - following tools' }
GtMultiPagerToolModel >> replaceFollowingToolBy: aToolModel [
	| anOldToolModel |
	anOldToolModel := self followingTools reversed
			detect: #isUnfastened
			ifFound: #yourself
			ifNone: [ nil ].

	anOldToolModel
		ifNil: [ self addFollowingTool: aToolModel ]
		ifNotNil: [ self replaceFollowingTool: anOldToolModel by: aToolModel ]
]

{ #category : #accessing }
GtMultiPagerToolModel >> title [
	^ title ifNil: [ self toolBuilder title ]
]

{ #category : #accessing }
GtMultiPagerToolModel >> title: anObject [
	title := anObject
]

{ #category : #accessing }
GtMultiPagerToolModel >> toolBuilder [
	^ toolBuilder
]

{ #category : #accessing }
GtMultiPagerToolModel >> toolBuilder: anObject [
	toolBuilder := anObject
]

{ #category : #'api - fastening' }
GtMultiPagerToolModel >> unfasten [
	self fasten: false
]
