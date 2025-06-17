Class {
	#name : #GtTreePagerPaneModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer + TGtTreePagerPaneModelEnumerable',
	#classTraits : 'TGtAnnouncer classTrait + TGtTreePagerPaneModelEnumerable classTrait',
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
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'api - following tools' }
GtTreePagerPaneModel >> addFollowingPane: aPaneModel [
	self followingPanes: (self followingPanes copyWith: aPaneModel)
]

{ #category : #announcer }
GtTreePagerPaneModel >> announcer [
	<return: #Announcer>
	^ announcer
]

{ #category : #converting }
GtTreePagerPaneModel >> asElement [
	<return: #BlElement>
	^ self toolBuilder asElement
]

{ #category : #accessing }
GtTreePagerPaneModel >> children [
	^ self followingPanes
]

{ #category : #'api - expandable' }
GtTreePagerPaneModel >> collapse [
	self collapse: true
]

{ #category : #'api - expandable' }
GtTreePagerPaneModel >> collapse: aBoolean [
	isCollapsed = aBoolean ifTrue: [ ^ self ].

	isCollapsed := aBoolean.
	self notifyExpansionChanged
]

{ #category : #accessing }
GtTreePagerPaneModel >> collapsedChainCount [
	self isCollapsed ifFalse: [ ^ 0 ].
	self hasFollowingPanes ifFalse: [ ^ 1 ].
	(self followingPanes allSatisfy: #isCollapsed) ifFalse: [ ^ 1 ].

	^ (self followingPanes detectMin: [ :each | each collapsedChainCount ])
		collapsedChainCount
]

{ #category : #'api - enumeration' }
GtTreePagerPaneModel >> enumerablePaneModels [
	<return: #Collection of: #GtTreePagerPaneModel>
	^ self followingPanes
]

{ #category : #'api - expandable' }
GtTreePagerPaneModel >> expand [
	self expand: true
]

{ #category : #'api - expandable' }
GtTreePagerPaneModel >> expand: aBoolean [
	self collapse: aBoolean not
]

{ #category : #'api - fastening' }
GtTreePagerPaneModel >> fasten [
	self fasten: true
]

{ #category : #'api - fastening' }
GtTreePagerPaneModel >> fasten: aBoolean [
	isFastened = aBoolean ifTrue: [ ^ self ].

	isFastened := aBoolean
]

{ #category : #'api - following tools' }
GtTreePagerPaneModel >> followingExpandedPaneModels [
	^ Array
		streamContents: [ :aStream | 
			self followingPanes
				do: [ :eachTool | 
					eachTool isExpanded
						ifTrue: [ aStream nextPut: eachTool ]
						ifFalse: [ aStream nextPutAll: eachTool followingExpandedPaneModels ] ] ]
]

{ #category : #'api - following tools' }
GtTreePagerPaneModel >> followingPanes [
	^ followingPanes
]

{ #category : #'api - following tools' }
GtTreePagerPaneModel >> followingPanes: aCollection [
	followingPanes = aCollection ifTrue: [ ^ self ].

	aCollection do: [ :each | each previousPane: self ].
	followingPanes := aCollection.
	
	self notifyFollowingPanesChanged
]

{ #category : #printing }
GtTreePagerPaneModel >> gtDisplayOn: stream [
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
GtTreePagerPaneModel >> gtFollowingPanesFor: aView [
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
GtTreePagerPaneModel >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 10;
		stencil: [ GtTreePagerPaneElement new paneModel: self ]
]

{ #category : #testing }
GtTreePagerPaneModel >> hasFollowingPanes [
	^ self followingPanes isNotEmpty
]

{ #category : #accessing }
GtTreePagerPaneModel >> icon [
	^ icon ifNil: [ self toolBuilder icon ]
]

{ #category : #accessing }
GtTreePagerPaneModel >> icon: anObject [
	icon := anObject
]

{ #category : #initialization }
GtTreePagerPaneModel >> initialize [
	super initialize.
	announcer := Announcer new.
	followingPanes := Array empty.
	isCollapsed := false.
	isFastened := false.
]

{ #category : #'api - expandable' }
GtTreePagerPaneModel >> isCollapsed [
	^ isCollapsed ifNil: [ false ]
]

{ #category : #'api - expandable' }
GtTreePagerPaneModel >> isExpanded [
	^ self isCollapsed not
]

{ #category : #'api - fastening' }
GtTreePagerPaneModel >> isFastened [
	^ isFastened
]

{ #category : #'api - fastening' }
GtTreePagerPaneModel >> isUnfastened [
	^ self isFastened not
]

{ #category : #'api - expandable' }
GtTreePagerPaneModel >> notifyExpansionChanged [
	self announcer
		announce: (GtTreePagerPaneModelExpansionChanged new
				paneModel: self;
				isCollapsed: self isCollapsed)
]

{ #category : #'private - notifying' }
GtTreePagerPaneModel >> notifyFollowingPanesChanged [
	
]

{ #category : #accessing }
GtTreePagerPaneModel >> paneModel: aColumnModel [
	self
		deprecated: 'Please use columnModel: instead.'
		transformWith: '`@receiver paneModel: `@statements1' -> '`@receiver columnModel: `@statements1'.

	self columnModel: aColumnModel
]

{ #category : #accessing }
GtTreePagerPaneModel >> previousExpandedToolModel [
	<return: #GtTreePagerPaneModel or: nil>
	^ self previousPane
		ifNotNil: [ :aPreviousTool | 
			aPreviousTool isExpanded
				ifTrue: [ aPreviousTool ]
				ifFalse: [ aPreviousTool previousExpandedToolModel ] ]
]

{ #category : #accessing }
GtTreePagerPaneModel >> previousPane [
	^ previousPane
]

{ #category : #accessing }
GtTreePagerPaneModel >> previousPane: aPaneModel [
	previousPane := aPaneModel
]

{ #category : #printing }
GtTreePagerPaneModel >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: self title asString.
	self isCollapsed ifTrue: [ aStream nextPutAll: ', collapsed' ].
	self isFastened ifTrue: [ aStream nextPutAll: ', fastened' ].
	aStream nextPut: $)
]

{ #category : #'private - updating' }
GtTreePagerPaneModel >> replaceFollowingPane: anOldPaneModel by: aNewPaneModel [
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
GtTreePagerPaneModel >> replaceFollowingPaneBy: aPaneModel [
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
GtTreePagerPaneModel >> title [
	^ title ifNil: [ self toolBuilder title ]
]

{ #category : #accessing }
GtTreePagerPaneModel >> title: anObject [
	title := anObject
]

{ #category : #accessing }
GtTreePagerPaneModel >> toolBuilder [
	^ toolBuilder
]

{ #category : #accessing }
GtTreePagerPaneModel >> toolBuilder: anObject [
	toolBuilder := anObject
]

{ #category : #'api - fastening' }
GtTreePagerPaneModel >> unfasten [
	self fasten: false
]
