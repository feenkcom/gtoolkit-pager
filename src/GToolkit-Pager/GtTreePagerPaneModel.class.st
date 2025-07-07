Class {
	#name : #GtTreePagerPaneModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer + TGtTreePagerPaneModelEnumerable',
	#classTraits : 'TGtAnnouncer classTrait + TGtTreePagerPaneModelEnumerable classTrait',
	#instVars : [
		'isCollapsed',
		'title',
		'icon',
		'announcer',
		'columnModel',
		'previousPane',
		'activeLink',
		'phlowTool',
		'followingLinks'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'api - previous panes' }
GtTreePagerPaneModel >> activeLink [
	^ activeLink
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> activeLink: aLinkModel [
	| anOldActiveLink |
	self assert: [ self followingLinks includes: aLinkModel ].

	anOldActiveLink := activeLink.
	activeLink := aLinkModel.

	self notifyActiveLinkChangedFrom: anOldActiveLink to: activeLink
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> addFollowingLink: aLinkModel [
	self followingLinks: (self followingLinks copyWith: aLinkModel)
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> addFollowingPane: aPaneModel [
	self addFollowingLink: (GtTreePagerLinkModel new paneModel: aPaneModel)
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> allFollowingPanes [
	^ Array
		streamContents: [ :aStream | self allPanesBreadthFirstDo: [ :eachPane | aStream nextPut: eachPane ] ]
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> allFollowingPanesCount [
	| anIndex |
	anIndex := 0.
	self allPaneModelsDepthFirstDo: [ :aPane | anIndex := anIndex + 1 ].
	^ anIndex
]

{ #category : #'api - previous panes' }
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
	self hasFollowingLinks ifFalse: [ ^ 1 ].
	(self followingLinks allSatisfy: #isCollapsed) ifFalse: [ ^ 1 ].

	^ (self followingLinks detectMin: [ :each | each collapsedChainCount ])
		collapsedChainCount
]

{ #category : #'api - previous panes' }
GtTreePagerPaneModel >> depthIndex [
	"Return my depth in the pane tree structure.
	Root panes returns `1` values."

	^ self previousPane 
		ifNotNil: [ :aPane | aPane depthIndex + 1 ] 
		ifNil: [ 1 ]
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
GtTreePagerPaneModel >> followingExpandedLinkModels [
	^ Array
		streamContents: [ :aStream | 
			self followingLinks
				do: [ :eachLink | 
					eachLink isExpanded
						ifTrue: [ aStream nextPut: eachLink ]
						ifFalse: [ aStream nextPutAll: eachLink followingExpandedLinkModels ] ] ]
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> followingExpandedPaneModels [
	^ self followingExpandedLinkModels collect: #paneModel
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> followingLinks [
	^ followingLinks
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> followingLinks: aCollection [
	| anOldFollowingLinks |
	self assert: [ aCollection allSatisfy: [ :each | 
		each isKindOf: GtTreePagerLinkModel ] ].

	followingLinks = aCollection ifTrue: [ ^ self ].

	aCollection do: [ :each | each previousPane: self ].
	anOldFollowingLinks := followingLinks.
	followingLinks := aCollection.
	self updateActiveLink.

	self notifyFollowingLinksChanged: anOldFollowingLinks
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> followingPanes [
	^ self followingLinks collect: #paneModel
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> followingPanes: aCollection [
	self followingLinks: (aCollection collect: [ :each | GtTreePagerLinkModel new paneModel: each ])
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
GtTreePagerPaneModel >> hasFollowingLinks [
	^ self followingLinks isNotEmpty
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
	| anOldActiveLink |
	anOldActiveLink := activeLink.
	activeLink := nil.

	self notifyActiveLinkChangedFrom: anOldActiveLink to: activeLink
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> inactivateLink: aLinkModel [
	activeLink = aLinkModel ifFalse: [ ^ self ].

	self inactivateLink
]

{ #category : #initialization }
GtTreePagerPaneModel >> initialize [
	super initialize.
	announcer := Announcer new.
	followingLinks := Array empty.
	isCollapsed := false.
	activeLink := nil.
]

{ #category : #'api - expandable' }
GtTreePagerPaneModel >> isCollapsed [
	^ isCollapsed ifNil: [ false ]
]

{ #category : #'api - expandable' }
GtTreePagerPaneModel >> isExpanded [
	^ self isCollapsed not
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
GtTreePagerPaneModel >> notifyExpansionChanged [
	| anAnnouncement |
	anAnnouncement := GtTreePagerPaneModelExpansionChanged new
			paneModel: self;
			isCollapsed: self isCollapsed.
	self announcer announce: anAnnouncement.
	self allPreviousPanesDo: [ :aPreviousPane | aPreviousPane announcer announce: anAnnouncement ]
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
GtTreePagerPaneModel >> previousPane [
	^ previousPane
]

{ #category : #'api - previous panes' }
GtTreePagerPaneModel >> previousPane: aPaneModel [
	previousPane := aPaneModel
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
GtTreePagerPaneModel >> removeFollowingPane: aPaneModel [
	self followingPanes: (self followingPanes copyWithout: aPaneModel)
]

{ #category : #'api - previous panes' }
GtTreePagerPaneModel >> removeFromPreviousPane [
	self previousPane
		ifNotNil: [ :aPreviousPane | aPreviousPane removeFollowingPane: self ]
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> removeLink [
	self activeLink ifNotNil: [ :aLinkModel | self removeFollowingPane: aLinkModel ]
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
GtTreePagerPaneModel >> selectFollowingPane: aNewPaneModel [
	| anOldLinkModel aNewLinkModel |
	anOldLinkModel := self activeLink.
	aNewLinkModel := GtTreePagerLinkModel new paneModel: aNewPaneModel.

	anOldLinkModel
		ifNil: [ self addFollowingPane: (aNewLinkModel collapse) ]
		ifNotNil: [ aNewLinkModel collapse: anOldLinkModel isCollapsed.
			self replaceFollowingLink: anOldLinkModel by: aNewLinkModel ]
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> spawnFollowingPane: aNewPaneModel [
	| anOldLinkModel aNewLinkModel |
	anOldLinkModel := self activeLink.
	aNewLinkModel := GtTreePagerLinkModel new paneModel: aNewPaneModel.

	anOldLinkModel
		ifNil: [ self addFollowingLink: aNewLinkModel ]
		ifNotNil: [ self replaceFollowingLink: anOldLinkModel by: aNewLinkModel ]
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

{ #category : #'api - previous panes' }
GtTreePagerPaneModel >> topPreviousPane [
	"Note: it is usually a pager model"

	| aTopModel |
	aTopModel := nil.
	self allPreviousPanesDo: [ :aPreviousPane | aTopModel := aPreviousPane ].
	^ aTopModel
]

{ #category : #'private - updating' }
GtTreePagerPaneModel >> updateActiveLink [
	followingLinks
		ifEmpty: [ self inactivateLink.
			^ self ].

	(activeLink notNil and: [ followingLinks includes: activeLink ])
		ifFalse: [ self activeLink: followingLinks last ]
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> withAllFollowingPanes [
	^ Array
		streamContents: [ :aStream | 
			aStream nextPut: self.
			self allPanesBreadthFirstDo: [ :eachPane | aStream nextPut: eachPane ] ]
]
