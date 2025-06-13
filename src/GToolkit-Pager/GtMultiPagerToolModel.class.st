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
		'announcer'
	],
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #accessing }
GtMultiPagerToolModel >> addFollowingTool: aToolModel [
	aToolModel previousTool: self.
	self followingTools add: aToolModel.
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

{ #category : #accessing }
GtMultiPagerToolModel >> followingExpandedToolModels [
	^ Array
		streamContents: [ :aStream | 
			self followingTools
				do: [ :eachTool | 
					eachTool isExpanded
						ifTrue: [ aStream nextPut: eachTool ]
						ifFalse: [ aStream nextPutAll: eachTool followingExpandedToolModels ] ] ]
]

{ #category : #accessing }
GtMultiPagerToolModel >> followingTools [
	^ followingTools
]

{ #category : #accessing }
GtMultiPagerToolModel >> followingTools: anObject [
	followingTools := OrderedCollection withAll: anObject
]

{ #category : #printing }
GtMultiPagerToolModel >> gtDisplayOn: stream [
	stream nextPutAll: 'Tool model: '.
	stream nextPutAll: self title asString.
	self isCollapsed ifTrue: [ stream nextPutAll: ' (collapsed)' ]
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
	followingTools := OrderedCollection new.
	isCollapsed := false
]

{ #category : #'api - expandable' }
GtMultiPagerToolModel >> isCollapsed [
	^ isCollapsed ifNil: [ false ]
]

{ #category : #'api - expandable' }
GtMultiPagerToolModel >> isExpanded [
	^ self isCollapsed not
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
