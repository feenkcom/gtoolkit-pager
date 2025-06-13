Class {
	#name : #GtMultiPagerPaneModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'toolBuilder',
		'isCollapsed',
		'title',
		'icon',
		'announcer',
		'isFastened',
		'columnModel',
		'followingPanes',
		'previousPane'
	],
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #'api - following tools' }
GtMultiPagerPaneModel >> addFollowingPane: aPaneModel [
	self followingPanes: (self followingPanes copyWith: aPaneModel)
]

{ #category : #announcer }
GtMultiPagerPaneModel >> announcer [
	<return: #Announcer>
	^ announcer
]

{ #category : #converting }
GtMultiPagerPaneModel >> asElement [
	<return: #BlElement>
	^ self toolBuilder asElement
]

{ #category : #accessing }
GtMultiPagerPaneModel >> children [
	^ self followingPanes
]

{ #category : #'api - expandable' }
GtMultiPagerPaneModel >> collapse [
	self collapse: true
]

{ #category : #'api - expandable' }
GtMultiPagerPaneModel >> collapse: aBoolean [
	isCollapsed = aBoolean ifTrue: [ ^ self ].

	isCollapsed := aBoolean.
	self notifyExpansionChanged
]

{ #category : #accessing }
GtMultiPagerPaneModel >> collapsedChainCount [
	self isCollapsed ifFalse: [ ^ 0 ].
	self hasFollowingPanes ifFalse: [ ^ 1 ].
	(self followingPanes allSatisfy: #isCollapsed) ifFalse: [ ^ 1 ].

	^ (self followingPanes detectMin: [ :each | each collapsedChainCount ])
		collapsedChainCount
]

{ #category : #accessing }
GtMultiPagerPaneModel >> columnModel [
	^ columnModel
]

{ #category : #accessing }
GtMultiPagerPaneModel >> columnModel: aColumnModel [
	columnModel := aColumnModel
]

{ #category : #'api - expandable' }
GtMultiPagerPaneModel >> expand [
	self expand: true
]

{ #category : #'api - expandable' }
GtMultiPagerPaneModel >> expand: aBoolean [
	self collapse: aBoolean not
]

{ #category : #'api - fastening' }
GtMultiPagerPaneModel >> fasten [
	self fasten: true
]

{ #category : #'api - fastening' }
GtMultiPagerPaneModel >> fasten: aBoolean [
	isFastened = aBoolean ifTrue: [ ^ self ].

	isFastened := aBoolean
]

{ #category : #'api - following tools' }
GtMultiPagerPaneModel >> followingExpandedPaneModels [
	^ Array
		streamContents: [ :aStream | 
			self followingPanes
				do: [ :eachTool | 
					eachTool isExpanded
						ifTrue: [ aStream nextPut: eachTool ]
						ifFalse: [ aStream nextPutAll: eachTool followingExpandedPaneModels ] ] ]
]

{ #category : #'api - following tools' }
GtMultiPagerPaneModel >> followingPanes [
	^ followingPanes
]

{ #category : #'api - following tools' }
GtMultiPagerPaneModel >> followingPanes: aCollection [
	followingPanes = aCollection ifTrue: [ ^ self ].

	aCollection do: [ :each | each previousPane: self ].
	followingPanes := aCollection.
	
	self notifyFollowingPanesChanged
]

{ #category : #printing }
GtMultiPagerPaneModel >> gtDisplayOn: stream [
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
GtMultiPagerPaneModel >> gtFollowingPanesFor: aView [
	<gtView>
	self followingPanes ifNil: [ ^ aView empty ].
	^ aView columnedTree
		title: 'Panes';
		items: [ {self} ];
		children: #followingPanes;
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
GtMultiPagerPaneModel >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 10;
		stencil: [ GtMultiPagerPaneElement new toolModel: self ]
]

{ #category : #testing }
GtMultiPagerPaneModel >> hasFollowingPanes [
	^ self followingPanes isNotEmpty
]

{ #category : #accessing }
GtMultiPagerPaneModel >> icon [
	^ icon ifNil: [ self toolBuilder icon ]
]

{ #category : #accessing }
GtMultiPagerPaneModel >> icon: anObject [
	icon := anObject
]

{ #category : #initialization }
GtMultiPagerPaneModel >> initialize [
	super initialize.
	announcer := Announcer new.
	followingPanes := Array empty.
	isCollapsed := false.
	isFastened := false.
]

{ #category : #'api - expandable' }
GtMultiPagerPaneModel >> isCollapsed [
	^ isCollapsed ifNil: [ false ]
]

{ #category : #'api - expandable' }
GtMultiPagerPaneModel >> isExpanded [
	^ self isCollapsed not
]

{ #category : #'api - fastening' }
GtMultiPagerPaneModel >> isFastened [
	^ isFastened
]

{ #category : #'api - fastening' }
GtMultiPagerPaneModel >> isUnfastened [
	^ self isFastened not
]

{ #category : #'api - expandable' }
GtMultiPagerPaneModel >> notifyExpansionChanged [
	self columnModel
		ifNotNil: [ :aPaneModel | aPaneModel onPaneModelExpansionChanged: self ]
		ifNil: [ self previousExpandedToolModel
				ifNotNil: [ :aPreviousTool | 
					aPreviousTool columnModel
						ifNotNil: [ :aPaneModel | aPaneModel onFollowingPaneModelExpansionChanged: self ] ] ].

	self announcer
		announce: (GtMultiPagerToolModelExpansionChanged new
				toolModel: self;
				isCollapsed: self isCollapsed)
]

{ #category : #'private - notifying' }
GtMultiPagerPaneModel >> notifyFollowingPanesChanged [
	self columnModel
		ifNotNil: [ :aPaneModel | aPaneModel onFollowingPaneModelsChanged: self ]
]

{ #category : #accessing }
GtMultiPagerPaneModel >> paneModel [
	self
		deprecated: 'Please use columnModel instead.'
		transformWith: '`@receiver paneModel' -> '`@receiver columnModel'.

	^ self columnModel
]

{ #category : #accessing }
GtMultiPagerPaneModel >> paneModel: aColumnModel [
	self
		deprecated: 'Please use columnModel: instead.'
		transformWith: '`@receiver paneModel: `@statements1' -> '`@receiver columnModel: `@statements1'.

	self columnModel: aColumnModel
]

{ #category : #accessing }
GtMultiPagerPaneModel >> previousExpandedToolModel [
	<return: #GtMultiPagerPaneModel or: nil>
	^ self previousPane
		ifNotNil: [ :aPreviousTool | 
			aPreviousTool isExpanded
				ifTrue: [ aPreviousTool ]
				ifFalse: [ aPreviousTool previousExpandedToolModel ] ]
]

{ #category : #accessing }
GtMultiPagerPaneModel >> previousPane [
	^ previousPane
]

{ #category : #accessing }
GtMultiPagerPaneModel >> previousPane: aPaneModel [
	previousPane := aPaneModel
]

{ #category : #'private - updating' }
GtMultiPagerPaneModel >> replaceFollowingPane: anOldPaneModel by: aNewPaneModel [
	| anIndex |
	anIndex := self followingPanes
			detectIndex: [ :each | each == anOldPaneModel ]
			ifNone: [ NotFound signalFor: anOldPaneModel in: self followingPanes ].

	aNewPaneModel previousPane: self.
	anOldPaneModel previousPane: nil.
	self followingPanes at: anIndex put: aNewPaneModel.
	
	self notifyFollowingPanesChanged
]

{ #category : #'api - following tools' }
GtMultiPagerPaneModel >> replaceFollowingPaneBy: aPaneModel [
	| anOldPaneModel |
	anOldPaneModel := self followingPanes reversed
			detect: #isUnfastened
			ifFound: #yourself
			ifNone: [ nil ].

	anOldPaneModel
		ifNil: [ self addFollowingPane: aPaneModel ]
		ifNotNil: [ self replaceFollowingPane: anOldPaneModel by: aPaneModel ]
]

{ #category : #accessing }
GtMultiPagerPaneModel >> title [
	^ title ifNil: [ self toolBuilder title ]
]

{ #category : #accessing }
GtMultiPagerPaneModel >> title: anObject [
	title := anObject
]

{ #category : #accessing }
GtMultiPagerPaneModel >> toolBuilder [
	^ toolBuilder
]

{ #category : #accessing }
GtMultiPagerPaneModel >> toolBuilder: anObject [
	toolBuilder := anObject
]

{ #category : #'api - fastening' }
GtMultiPagerPaneModel >> unfasten [
	self fasten: false
]
