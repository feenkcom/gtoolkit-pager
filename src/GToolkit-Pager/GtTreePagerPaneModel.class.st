Class {
	#name : #GtTreePagerPaneModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer + TGtTreePagerPaneModelEnumerable + TGtTreePagerLinkModelState + TGtTreePagerPaneModel',
	#classTraits : 'TGtAnnouncer classTrait + TGtTreePagerPaneModelEnumerable classTrait + TGtTreePagerLinkModelState classTrait + TGtTreePagerPaneModel classTrait',
	#instVars : [
		'title',
		'icon',
		'announcer',
		'columnModel',
		'phlowTool',
		'followingLinks',
		'previousLink'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'api - previous panes' }
GtTreePagerPaneModel >> activeLink [
	^ followingLinks activeLink
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> activeLink: aLinkModel [
	followingLinks activeLink: aLinkModel
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> addFollowingLink: aLinkModel [
	self isSpawned ifFalse: [ 
		self previousLink ifNotNil: #expand ].

	followingLinks addLink: aLinkModel
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> allFollowingPanes [
	^ Array
		streamContents: [ :aStream | self allPaneModelsBreadthFirstDo: [ :eachPane | aStream nextPut: eachPane ] ]
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> allFollowingPanesCount [
	| anIndex |
	anIndex := 0.
	self allPaneModelsDepthFirstDo: [ :aPane | anIndex := anIndex + 1 ].
	^ anIndex
]

{ #category : #'api - previous links' }
GtTreePagerPaneModel >> allPreviousPanesDo: aBlock [
	self previousPane
		ifNotNil: [ :aPreviousPane | 
			aBlock value: aPreviousPane.
			aPreviousPane allPreviousPanesDo: aBlock ]
]

{ #category : #announcer }
GtTreePagerPaneModel >> announcer [
	<return: #Announcer>
	^ announcer
]

{ #category : #converting }
GtTreePagerPaneModel >> asElement [
	<return: #BlElement>
	^ self phlowTool asElement
]

{ #category : #accessing }
GtTreePagerPaneModel >> children [
	<return: #Collection of: #TGtTreePagerLinkModel>
	^ self followingLinks
]

{ #category : #'api - expandable' }
GtTreePagerPaneModel >> collapse [
	self collapse: true
]

{ #category : #'api - expandable' }
GtTreePagerPaneModel >> collapse: aBoolean [
	self previousLink ifNotNil: [ :aLinkModel | 
		aLinkModel collapse: aBoolean ]
]

{ #category : #accessing }
GtTreePagerPaneModel >> collapsedChainCount [
	self isCollapsed ifFalse: [ ^ 0 ].
	self hasFollowingLinks ifFalse: [ ^ 1 ].
	(self followingLinks allSatisfy: #isCollapsed) ifFalse: [ ^ 1 ].

	^ (self followingLinks detectMin: [ :each | each collapsedChainCount ])
		collapsedChainCount
]

{ #category : #'api - previous panes' }
GtTreePagerPaneModel >> depthIndex [
	"Return my depth in the pane tree structure.
	Root panes returns `1` values."

	^ self previousLink 
		ifNotNil: [ :aLink | aLink depthIndex + 1 ] 
		ifNil: [ 1 ]
]

{ #category : #'api - enumeration' }
GtTreePagerPaneModel >> enumerableLinkModels [
	<return: #Collection of: #TGtTreePagerLinkModel>
	^ self followingLinks
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

{ #category : #'api - following links' }
GtTreePagerPaneModel >> followingCollapsedLinkModels [
	^ Array
		streamContents: [ :aStream | 
			self followingLinks
				do: [ :eachLink | 
					eachLink isCollapsed
						ifTrue: [ aStream nextPut: eachLink.
							aStream nextPutAll: eachLink followingCollapsedLinkModels ] ] ]
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> followingCollapsedPaneModels [
	^ self followingCollapsedLinkModels collect: #paneModel
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> followingLinks [
	^ followingLinks links
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> followingLinks: aCollection [
	followingLinks links: aCollection
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> followingPanes [
	^ self followingLinks collect: #paneModel
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> followingPanes: aCollection [
	self followingLinks: (aCollection collect: [ :each | GtTreePagerLinkModel new paneModel: each ])
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> followingSpawnedLinkModels [
	^ Array
		streamContents: [ :aStream | 
			self followingLinks
				do: [ :eachLink | 
					eachLink isSpawned
						ifTrue: [ aStream nextPut: eachLink ]
						ifFalse: [ aStream nextPutAll: eachLink followingSpawnedLinkModels ] ] ]
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> followingSpawnedPaneModels [
	^ self followingSpawnedLinkModels collect: #paneModel
]

{ #category : #printing }
GtTreePagerPaneModel >> gtDisplayOn: stream [
	stream nextPutAll: 'Pane: '.
	stream nextPutAll: self title asString.
	self isCollapsed ifFalse: [ ^ self ].

	stream nextPutAll: ' ('.
	self isCollapsed ifTrue: [ stream nextPutAll: 'collapsed' ].
	stream nextPut: $)
]

{ #category : #views }
GtTreePagerPaneModel >> gtFollowingPanesFor: aView [
	<gtView>
	self followingPanes ifNil: [ ^ aView empty ].
	^ aView columnedTree
		title: 'Panes';
		items: [ {self} ];
		children: #followingLinks;
		expandUpTo: 1;
		column: 'Title' text: [ :each | each title ];
		column: 'Active'
			text: [ :each | 
				each isActive
					ifTrue: [ 'yes' ]
					ifFalse: [ 'no' asRopedText foreground: BlTheme default button disabledTextColor ] ]
			width: 70;
		column: 'Spawned'
			text: [ :each | 
				each isSpawned
					ifTrue: [ 'yes' ]
					ifFalse: [ 'no' asRopedText foreground: BlTheme default button disabledTextColor ] ]
			width: 70;
		column: 'Hidden'
			text: [ :each | 
				each isHidden
					ifTrue: [ 'yes' ]
					ifFalse: [ 'no' asRopedText foreground: BlTheme default button disabledTextColor ] ]
			width: 70;
		column: 'Collapsed'
			text: [ :each | 
				each isCollapsed
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
		stencil: [ BrFrame new
				matchParent;
				padding: (BlInsets all: 10);
				addChild: (GtTreePagerPaneElement new paneModel: self) ]
]

{ #category : #testing }
GtTreePagerPaneModel >> hasFollowingLinks [
	^ self followingLinks isNotEmpty
]

{ #category : #'api - visibility' }
GtTreePagerPaneModel >> hide [
	self previousLink ifNotNil: #hide
]

{ #category : #accessing }
GtTreePagerPaneModel >> icon [
	^ icon ifNil: [ self toolBuilder icon ]
]

{ #category : #accessing }
GtTreePagerPaneModel >> icon: anObject [
	icon := anObject
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> inactivateLink [
	followingLinks inactivateLink
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> inactivateLink: aLinkModel [
	followingLinks inactivateLink: aLinkModel
]

{ #category : #initialization }
GtTreePagerPaneModel >> initialize [
	super initialize.
	announcer := Announcer new.
	followingLinks := GtTreePagerPaneLinks new paneModel: self.
]

{ #category : #'api - notifying' }
GtTreePagerPaneModel >> linkModel: aLinkModel stateChangedFrom: anOldLinkState to: aNewActiveState [
	followingLinks
		linkModel: aLinkModel
		stateChangedFrom: anOldLinkState
		to: aNewActiveState
]

{ #category : #'private - notifying' }
GtTreePagerPaneModel >> notifyActiveLinkChangedFrom: anOldActiveLink to: aNewActiveLink [
	anOldActiveLink
		ifNotNil: [ anOldActiveLink announcer
				announce: (GtTreePagerPaneModelPreviousActiveLinkChanged new paneModel: anOldActiveLink) ].

	aNewActiveLink
		ifNotNil: [ aNewActiveLink announcer
				announce: (GtTreePagerPaneModelPreviousActiveLinkChanged new paneModel: aNewActiveLink) ].

	self announcer
		announce: (GtTreePagerPaneModelActiveLinkChanged new
				paneModel: self;
				oldActiveLink: anOldActiveLink;
				newActiveLink: aNewActiveLink)
]

{ #category : #'private - notifying' }
GtTreePagerPaneModel >> notifyFollowingLinksChanged: anOldFollowingLinks [
	| anAnnouncement |
	anAnnouncement := GtTreePagerPaneModelFollowingLinksChanged new
			paneModel: self;
			newFollowingLinks: self followingLinks;
			oldFollowingLinks: anOldFollowingLinks.
	self announcer announce: anAnnouncement.
	self allPreviousPanesDo: [ :aPreviousPane | aPreviousPane announcer announce: anAnnouncement ]
]

{ #category : #'api - phlow' }
GtTreePagerPaneModel >> object: anObject [
	self phlowTool: anObject gtDefaultInspectorTool
]

{ #category : #accessing }
GtTreePagerPaneModel >> paneModel: aColumnModel [
	self
		deprecated: 'Please use columnModel: instead.'
		transformWith: '`@receiver paneModel: `@statements1' -> '`@receiver columnModel: `@statements1'.

	self columnModel: aColumnModel
]

{ #category : #accessing }
GtTreePagerPaneModel >> phlowTool [
	^ phlowTool
]

{ #category : #'api - phlow' }
GtTreePagerPaneModel >> phlowTool: aGtPhlowTool [
	phlowTool := aGtPhlowTool
]

{ #category : #'api - previous panes' }
GtTreePagerPaneModel >> previousExpandedPane [
	<return: #GtTreePagerPaneModel or: nil>
	^ self previousPane
		ifNotNil: [ :aPreviousTool | 
			aPreviousTool isExpanded
				ifTrue: [ aPreviousTool ]
				ifFalse: [ aPreviousTool previousExpandedPane ] ]
]

{ #category : #'api - previous panes' }
GtTreePagerPaneModel >> previousLink [
	^ previousLink
]

{ #category : #'api - previous panes' }
GtTreePagerPaneModel >> previousLink: aLinkModel [
	previousLink := aLinkModel
]

{ #category : #'api - previous panes' }
GtTreePagerPaneModel >> previousPane [
	^ previousLink ifNotNil: #previousPane
]

{ #category : #printing }
GtTreePagerPaneModel >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: self title asString.
	self isCollapsed ifTrue: [ aStream nextPutAll: ', collapsed' ].
	aStream nextPut: $)
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> removeFollowingLink: aLinkModel [
	followingLinks removeLink: aLinkModel
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> removeFollowingPane: aPaneModel [
	self followingLinks
		detect: [ :eachLink | eachLink paneModel = aPaneModel ]
		ifFound: [ :aLinkModel | self removeFollowingLink: aLinkModel ]
		ifNone: [  ]
]

{ #category : #'api - previous panes' }
GtTreePagerPaneModel >> removeFromPreviousPane [
	self previousPane
		ifNotNil: [ :aPreviousPane | aPreviousPane removeFollowingPane: self ]
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> removeLink [
	self activeLink ifNotNil: [ :aLinkModel | self removeFollowingLink: aLinkModel ]
]

{ #category : #'private - updating' }
GtTreePagerPaneModel >> replaceFollowingLink: anOldLinkModel by: aNewLinkModel [
	| anIndex aNewCollection |
	anIndex := self followingLinks
			detectIndex: [ :each | each == anOldLinkModel ]
			ifNone: [ NotFound signalFor: anOldLinkModel in: self followingLinks ].

	aNewLinkModel previousPane: self.
	aNewCollection := self followingLinks copy
			at: anIndex put: aNewLinkModel;
			yourself.
	self followingLinks: aNewCollection
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> selectPane: aNewPaneModel [
	| anOldLinkModel aNewLinkModel |
	anOldLinkModel := self activeLink.
	aNewLinkModel := GtTreePagerLinkModel new paneModel: aNewPaneModel.

	anOldLinkModel
		ifNil: [ 
			self addFollowingLink: aNewLinkModel ]
		ifNotNil: [ 
			aNewLinkModel state: anOldLinkModel state.
			self replaceFollowingLink: anOldLinkModel by: aNewLinkModel ]
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> spawnPane: aNewPaneModel [
	| anOldLinkModel aNewLinkModel |
	anOldLinkModel := self activeLink.
	aNewLinkModel := GtTreePagerLinkModel new paneModel: aNewPaneModel.
	aNewLinkModel expand.

	anOldLinkModel
		ifNil: [ self addFollowingLink: aNewLinkModel ]
		ifNotNil: [ self replaceFollowingLink: anOldLinkModel by: aNewLinkModel ]
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> spawnSiblingPane: aNewPaneModel [
	| aNewLinkModel |
	aNewLinkModel := GtTreePagerLinkModel new paneModel: aNewPaneModel.
	aNewLinkModel expand.

	self addFollowingLink: aNewLinkModel
]

{ #category : #'api - state' }
GtTreePagerPaneModel >> state [
	<return: #GtTreePagerLinkState>
	^ self previousLink
		ifNotNil: [ :aLink | aLink state ]
		ifNil: [ GtTreePagerLinkState spawned ]
]

{ #category : #'api - phlow' }
GtTreePagerPaneModel >> stencil: aBlStencil [
	self phlowTool: (GtPhlowExplicitTool new stencil: aBlStencil)
]

{ #category : #accessing }
GtTreePagerPaneModel >> title [
	^ title ifNil: [ self phlowTool title ]
]

{ #category : #accessing }
GtTreePagerPaneModel >> title: anObject [
	title := anObject
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> withAllFollowingPanes [
	^ Array
		streamContents: [ :aStream | 
			aStream nextPut: self.
			self allPaneModelsBreadthFirstDo: [ :eachPane | aStream nextPut: eachPane ] ]
]
