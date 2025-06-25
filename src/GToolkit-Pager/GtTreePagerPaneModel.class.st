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
		'followingPanes',
		'previousPane',
		'activeLink',
		'phlowTool'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'api - previous panes' }
GtTreePagerPaneModel >> activeLink [
	^ activeLink
]

{ #category : #'api - following panes' }
GtTreePagerPaneModel >> activeLink: aPaneModel [
	| anOldActiveLink |
	self assert: [ self followingPanes includes: aPaneModel ].

	anOldActiveLink := activeLink.
	activeLink := aPaneModel.

	self notifyActiveLinkChangedFrom: anOldActiveLink to: activeLink
]

{ #category : #'api - following panes' }
GtTreePagerPaneModel >> addFollowingPane: aPaneModel [
	self followingPanes: (self followingPanes copyWith: aPaneModel)
]

{ #category : #'api - following panes' }
GtTreePagerPaneModel >> allFollowingPanes [
	^ Array
		streamContents: [ :aStream | self allPanesBreadthFirstDo: [ :eachPane | aStream nextPut: eachPane ] ]
]

{ #category : #'api - following panes' }
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

{ #category : #'api - following panes' }
GtTreePagerPaneModel >> beActiveLink [
	self previousPane ifNotNil: [ :aPaneModel | aPaneModel activeLink: self ]
]

{ #category : #'api - following panes' }
GtTreePagerPaneModel >> beInactiveLink [
	self previousPane ifNotNil: [ :aPaneModel | aPaneModel inactivateLink: self ]
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

{ #category : #'api - following panes' }
GtTreePagerPaneModel >> followingCollapsedPaneModels [
	^ Array
		streamContents: [ :aStream | 
			self followingPanes
				do: [ :eachPane | 
					eachPane isCollapsed
						ifTrue: [ aStream nextPut: eachPane.
							aStream nextPutAll: eachPane followingCollapsedPaneModels ] ] ]
]

{ #category : #'api - following panes' }
GtTreePagerPaneModel >> followingExpandedPaneModels [
	^ Array
		streamContents: [ :aStream | 
			self followingPanes
				do: [ :eachPane | 
					eachPane isExpanded
						ifTrue: [ aStream nextPut: eachPane ]
						ifFalse: [ aStream nextPutAll: eachPane followingExpandedPaneModels ] ] ]
]

{ #category : #'api - following panes' }
GtTreePagerPaneModel >> followingPanes [
	^ followingPanes
]

{ #category : #'api - following panes' }
GtTreePagerPaneModel >> followingPanes: aCollection [
	| anOldFollowingPanes |
	followingPanes = aCollection ifTrue: [ ^ self ].

	aCollection do: [ :each | each previousPane: self ].
	anOldFollowingPanes := followingPanes.
	followingPanes := aCollection.
	self updateActiveLink.

	self notifyFollowingPanesChanged: anOldFollowingPanes
]

{ #category : #printing }
GtTreePagerPaneModel >> gtDisplayOn: stream [
	stream nextPutAll: 'Pane: '.
	stream nextPutAll: self title asString.
	(self isCollapsed or: [ self isActiveLink ]) ifFalse: [ ^ self ].

	stream nextPutAll: ' ('.
	self isCollapsed ifTrue: [ stream nextPutAll: 'collapsed' ].
	self isActiveLink
		ifTrue: [ self isCollapsed ifTrue: [ stream nextPutAll: ', ' ].
			stream nextPutAll: 'active' ].
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

{ #category : #'api - following panes' }
GtTreePagerPaneModel >> inactivateLink [
	| anOldActiveLink |
	anOldActiveLink := activeLink.
	activeLink := nil.

	self notifyActiveLinkChangedFrom: anOldActiveLink to: activeLink
]

{ #category : #'api - following panes' }
GtTreePagerPaneModel >> inactivateLink: aPaneModel [
	activeLink = aPaneModel ifFalse: [ ^ self ].

	self inactivateLink
]

{ #category : #initialization }
GtTreePagerPaneModel >> initialize [
	super initialize.
	announcer := Announcer new.
	followingPanes := Array empty.
	isCollapsed := false.
	activeLink := nil.
]

{ #category : #'api - following panes' }
GtTreePagerPaneModel >> isActiveLink [
	^ self previousPane
		ifNotNil: [ :aPaneModel | aPaneModel activeLink = self ]
		ifNil: [ false ]
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
GtTreePagerPaneModel >> notifyFollowingPanesChanged: anOldFollowingPanes [
	| anAnnouncement |
	anAnnouncement := GtTreePagerPaneModelFollowingPanesChanged new
			paneModel: self;
			newFollowingPanes: self followingPanes;
			oldFollowingPanes: anOldFollowingPanes.
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
	self isActiveLink ifTrue: [ aStream nextPutAll: ', active' ].
	aStream nextPut: $)
]

{ #category : #'api - following panes' }
GtTreePagerPaneModel >> removeFollowingPane: aPaneModel [
	self followingPanes: (self followingPanes copyWithout: aPaneModel)
]

{ #category : #'api - previous panes' }
GtTreePagerPaneModel >> removeFromPreviousPane [
	self previousPane
		ifNotNil: [ :aPreviousPane | aPreviousPane removeFollowingPane: self ]
]

{ #category : #'api - following panes' }
GtTreePagerPaneModel >> removeLink [
	self activeLink ifNotNil: [ :aPaneModel | self removeFollowingPane: aPaneModel ]
]

{ #category : #'private - updating' }
GtTreePagerPaneModel >> replaceFollowingPane: anOldPaneModel by: aNewPaneModel [
	| anIndex aNewCollection |
	anIndex := self followingPanes
			detectIndex: [ :each | each == anOldPaneModel ]
			ifNone: [ NotFound signalFor: anOldPaneModel in: self followingPanes ].

	aNewPaneModel previousPane: self.
	aNewCollection := self followingPanes copy
			at: anIndex put: aNewPaneModel;
			yourself.
	self followingPanes: aNewCollection
]

{ #category : #'api - following panes' }
GtTreePagerPaneModel >> replaceFollowingPaneBy: aPaneModel [
	| anOldPaneModel |
	anOldPaneModel := self activeLink.

	anOldPaneModel
		ifNil: [ self addFollowingPane: aPaneModel ]
		ifNotNil: [ self replaceFollowingPane: anOldPaneModel by: aPaneModel ]
]

{ #category : #'api - following panes' }
GtTreePagerPaneModel >> selectFollowingPane: aNewPaneModel [
	| anOldPaneModel |
	anOldPaneModel := self activeLink.

	anOldPaneModel
		ifNil: [ self addFollowingPane: aNewPaneModel collapse ]
		ifNotNil: [ 
			aNewPaneModel collapse: anOldPaneModel isCollapsed.
			self replaceFollowingPane: anOldPaneModel by: aNewPaneModel ]
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
	followingPanes
		ifEmpty: [ self inactivateLink.
			^ self ].

	(activeLink notNil and: [ followingPanes includes: activeLink ])
		ifFalse: [ self activeLink: followingPanes last ]
]

{ #category : #'api - following panes' }
GtTreePagerPaneModel >> withAllFollowingPanes [
	^ Array
		streamContents: [ :aStream | 
			aStream nextPut: self.
			self allPanesBreadthFirstDo: [ :eachPane | aStream nextPut: eachPane ] ]
]
