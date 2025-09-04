Class {
	#name : #GtTreePagerPaneModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer + TGtTreePagerModelEnumerable + TGtTreePagerLinkModelState + TGtTreePagerPaneModel',
	#classTraits : 'TGtAnnouncer classTrait + TGtTreePagerModelEnumerable classTrait + TGtTreePagerLinkModelState classTrait + TGtTreePagerPaneModel classTrait',
	#instVars : [
		'title',
		'icon',
		'announcer',
		'phlowTool',
		'followingLinks',
		'previousLink'
	],
	#category : #'GToolkit-TreePager-Model Core'
}

{ #category : #'gt - extensions' }
GtTreePagerPaneModel class >> gtPaneActionsFor: aView [
	<gtClassView>
	^ aView columnedTree
		title: 'Pane actions';
		tooltip: 'Pane toolbar and dropdown menu actions';
		items: [ | aPager |
			aPager := GtTreePagerExamples new pagerWithThreeSpawnedPanes.
			Array
				streamContents: [ :aStream | aPager allPaneModelsBreadthFirstDo: [ :eachPane | aStream nextPut: eachPane ] ] ];
		children: [ :anObject | 
			(anObject isKindOf: GtTreePagerPaneModel)
				ifTrue: [ anObject gtActions ]
				ifFalse: [ #() ] ];
		expandUpTo: 1;
		column: 'Title'
			text: [ :anObject | 
				(anObject isKindOf: GtTreePagerPaneModel)
					ifTrue: [ 'Pane depth: {1}' format: {anObject depthIndex} ]
					ifFalse: [ anObject description ] ]
			weight: 2.5;
		column: 'Shortcut'
			text: [ :anObject | 
				(anObject isKindOf: GtTreePagerPaneModel)
					ifTrue: [ '' ]
					ifFalse: [ anObject menuShortcutIfPresent: [ :e | e value ] ifAbsent: [ '' ] ] ];
		column: 'Priority'
			text: [ :anObject | 
				(anObject isKindOf: GtTreePagerPaneModel)
					ifTrue: [ '' ]
					ifFalse: [ anObject priority ] ]
			width: 55;
		column: 'Normal toolbar'
			text: [ :anObject | 
				(anObject isKindOf: GtTreePagerPaneModel)
					ifTrue: [ '' ]
					ifFalse: [ (anObject target isForTarget: GtTreePagerPaneNormalTopRightToolbarTarget)
							ifTrue: [ 'yes' ]
							ifFalse: [ '' ] ] ];
		column: 'Normal dropdown'
			text: [ :anObject | 
				(anObject isKindOf: GtTreePagerPaneModel)
					ifTrue: [ '' ]
					ifFalse: [ (anObject target isForTarget: GtTreePagerPaneNormalDropdownMenuTarget)
							ifTrue: [ 'yes' ]
							ifFalse: [ '' ] ] ];
		column: 'Maximized toolbar'
			text: [ :anObject | 
				(anObject isKindOf: GtTreePagerPaneModel)
					ifTrue: [ '' ]
					ifFalse: [ (anObject target isForTarget: GtTreePagerPaneMaximizedTopRightToolbarTarget)
							ifTrue: [ 'yes' ]
							ifFalse: [ '' ] ] ];
		column: 'Maximized dropdown'
			text: [ :anObject | 
				(anObject isKindOf: GtTreePagerPaneModel)
					ifTrue: [ '' ]
					ifFalse: [ (anObject target isForTarget: GtTreePagerPaneMaximizedDropdownMenuTarget)
							ifTrue: [ 'yes' ]
							ifFalse: [ '' ] ] ]
]

{ #category : #'api - previous panes' }
GtTreePagerPaneModel >> aboutToRemoveFromPreviousPane [
	self previousLink ifNotNil: [ :aPreviousLink | 
		aPreviousLink aboutToRemoveFromPreviousPane ]
]

{ #category : #'api - previous panes' }
GtTreePagerPaneModel >> activeLink [
	^ followingLinks activeLink
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> activeLink: aLinkModel [
	followingLinks activeLink: aLinkModel
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> addFollowingLink: aNewLinkModel after: aLinkModel reason: aReason [
	| aNewCollection |
	self followingLinks
		detectIndex: [ :each | each == aLinkModel ]
		ifNone: [ NotFound signalFor: aLinkModel in: self followingLinks ].

	aNewLinkModel previousPane: self.
	aNewCollection := Array
			new: self followingLinks size + 1
			streamContents: [ :aStream | 
				self followingLinks
					do: [ :eachLink | 
						aStream nextPut: eachLink.
						eachLink == aLinkModel ifTrue: [ 
							aStream nextPut: aNewLinkModel ] ] ].
	self followingLinks: aNewCollection reason: aReason
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> addFollowingLink: aNewLinkModel before: aLinkModel reason: aReason [
	| aNewCollection |
	self followingLinks
		detectIndex: [ :each | each == aLinkModel ]
		ifNone: [ NotFound signalFor: aLinkModel in: self followingLinks ].

	aNewLinkModel previousPane: self.
	aNewCollection := Array
			new: self followingLinks size + 1
			streamContents: [ :aStream | 
				self followingLinks
					do: [ :eachLink | 
						eachLink == aLinkModel ifTrue: [ aStream nextPut: aNewLinkModel ].
						aStream nextPut: eachLink ] ].
	self followingLinks: aNewCollection reason: aReason
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> addFollowingLink: aLinkModel reason: aReason [
	self isSpawned ifFalse: [ self expand ].

	followingLinks addLink: aLinkModel reason: aReason
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> addFollowingLinks: aCollectionOfLinkModels after: aLinkModel reason: aReason [
	| aNewCollection |
	self followingLinks
		detectIndex: [ :each | each == aLinkModel ]
		ifNone: [ NotFound signalFor: aLinkModel in: self followingLinks ].

	aCollectionOfLinkModels do: [ :eachLink |
		eachLink previousPane: self ].
	aNewCollection := Array
			new: self followingLinks size + 1
			streamContents: [ :aStream | 
				self followingLinks
					do: [ :eachLink | 
						aStream nextPut: eachLink.
						eachLink == aLinkModel ifTrue: [ 
							aStream nextPutAll: aCollectionOfLinkModels ] ] ].
	self followingLinks: aNewCollection reason: aReason
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> addFollowingLinks: aCollectionOfLinkModels before: aLinkModel reason: aReason [
	| aNewCollection |
	self followingLinks
		detectIndex: [ :each | each == aLinkModel ]
		ifNone: [ NotFound signalFor: aLinkModel in: self followingLinks ].

	aCollectionOfLinkModels do: [ :eachLink |
		eachLink previousPane: self ].
	aNewCollection := Array
			new: self followingLinks size + 1
			streamContents: [ :aStream | 
				self followingLinks
					do: [ :eachLink | 
						eachLink == aLinkModel ifTrue: [ 
							aStream nextPutAll: aCollectionOfLinkModels ].
						aStream nextPut: eachLink ] ].
	self followingLinks: aNewCollection reason: aReason
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
	| aToolElement |
	aToolElement := [ self phlowTool asToolElementDo: [ :anElement | anElement ] ]
			onErrorDo: [ :anError | anError asDebuggableElement ].

	^ aToolElement
]

{ #category : #'api - previous panes' }
GtTreePagerPaneModel >> breakingFlowPaneRemoval [
	"I remove myself as a link between previous pane and my following panes.
	My following panes are linked directly to my parent pane,
	and I am removed.
	
	Note: No recommended action as it breaks the exploration flow.
	As a consequence, such broken flows cannot be re-played.
	
	Note: I currently do not work for the root panes."

	| aParent someLinks |
	self depthIndex > 1 ifFalse: [ ^ self ].
	
	aParent := self previousPane.
	aParent ifNil: [ ^ self ].
	
	someLinks := self followingLinks.
	self followingLinks: #() reason: GtTreePagerBreakingFlowDetachReason default.

	aParent
		addFollowingLinks: someLinks
		after: self
		reason: GtTreePagerBreakingFlowAttachReason default.

	aParent
		removeFollowingLink: self
		reason: GtTreePagerBreakingFlowRemovalReason default
]

{ #category : #'api - phlow' }
GtTreePagerPaneModel >> canRecreateToolElement [
	<return: #Boolean>
	^ self phlowTool canRecreateToolElement
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

{ #category : #'api - previous panes' }
GtTreePagerPaneModel >> collapseOrSelect [
	"If the pane does not have any spawned panes, set select link state.
	Changing state to a select state keeps #isActive value.
	Changing state to a collapse state change #isActive value to false."

	self followingSpawnedLinkModels
		ifEmpty: [ self select ]
		ifNotEmpty: [ self collapse ]
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
		ifNotNil: [ :aLink | aLink depthIndex ] 
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
GtTreePagerPaneModel >> followingLinks: aCollection reason: aReason [
	followingLinks links: aCollection reason: aReason
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> followingPanes [
	^ self followingLinks collect: #paneModel
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> followingPanes: aCollection reason: aReason [
	self
		followingLinks: (aCollection collect: [ :each | GtTreePagerLinkModel new paneModel: each ])
		reason: aReason
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

{ #category : #actions }
GtTreePagerPaneModel >> gtCollapseOrSelectActionFor: anAction [
	<gtAction>
	self depthIndex = 1 ifTrue: [ ^ anAction noAction ].
	^ anAction button
		priority: 1;
		id: #'tree-pager--menu-collapse';
		label: 'Collapse pane';
		menuShortcut: [ OSPlatform current primaryModifier gtDisplayString , '+Click' ];
		target: GtTreePagerPaneNormalDropdownMenuTarget;
		action: [ :aButton | self collapseOrSelect ]
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
		column: 'State'
			text: [ :each | 
				each state label ] weight: 0.4;
		column: 'Active'
			text: [ :each | 
				each isActive
					ifTrue: [ 'yes' ]
					ifFalse: [ 'no' asRopedText foreground: BlTheme default button disabledTextColor ] ]
			width: 50;
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
			width: 55;
		column: 'Collapsed'
			text: [ :each | 
				each isCollapsed
					ifTrue: [ 'yes' ]
					ifFalse: [ 'no' asRopedText foreground: BlTheme default button disabledTextColor ] ]
			width: 70
]

{ #category : #actions }
GtTreePagerPaneModel >> gtHidePanesActionFor: anAction [
	<gtAction>
	GtTreePagerSettings isDisplayHideMenuItem ifFalse: [ ^ anAction noAction ].
	self depthIndex = 1 ifTrue: [ ^ anAction noAction ].
	self followingSpawnedLinkModels ifEmpty: [ ^ anAction noAction ].
	
	^ anAction button
		priority: 2;
		id: #'tree-pager--menu--hide';
		label: 'Collapse all panes';
		target: GtTreePagerPaneNormalDropdownMenuTarget;
		action: [ :aButton | self hide ]
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

{ #category : #actions }
GtTreePagerPaneModel >> gtMaximizeActionFor: anAction [
	<gtAction>
	^ anAction button
		priority: 4;
		id: #'menu--maximize-pane';
		label: 'Maximize pane';
		target: GtTreePagerPaneNormalDropdownMenuTarget;
		action: [ :aButton | self requestMaximizePane ]
]

{ #category : #actions }
GtTreePagerPaneModel >> gtMinimizeActionFor: anAction [
	<gtAction>
	^ anAction button
		priority: 4;
		id: #'menu--minimize-pane';
		label: 'Minimize pane';
		target: GtTreePagerPaneMaximizedDropdownMenuTarget;
		action: [ :aButton | aButton fireEvent: BrMaximizerHostMinimizeWish new ]
]

{ #category : #actions }
GtTreePagerPaneModel >> gtOpenInNewWorldTabActionFor: anAction [
	<gtAction>
	^ anAction button
		priority: 6;
		id: #'menu--new-world-tab';
		label: (self followingLinks
				ifNotEmpty: [ 'Open this and following panes in new tab' ]
				ifEmpty: [ 'Open pane in new tab' ]);
		target: GtTreePagerPaneNormalDropdownMenuTarget;
		addTarget: GtTreePagerPaneMaximizedDropdownMenuTarget;
		action: [ :aButton | 
			BlSpace new
				paneInTreePager: self similarPaneCopy settings: self pagerSettings;
				withSceneDriller;
				showFrom: aButton ];
		menuDisable: [ :aMenuModel | 
			| isOK |
			isOK := self canRecreateToolElement.
			isOK
				ifTrue: [ self
						allLinkModelsBreadthFirstDo: [ :eachLinkModel | isOK := isOK & eachLinkModel canRecreateToolElement ] ].
			isOK not ]
]

{ #category : #actions }
GtTreePagerPaneModel >> gtRemoveActionFor: anAction [
	<gtAction>
	self depthIndex = 1 ifTrue: [ ^ anAction noAction ].

	^ anAction button
		priority: 3;
		id: #'tree-pager--menu-remove';
		label: (self followingLinks
				ifNotEmpty: [ 'Remove this and following panes' ]
				ifEmpty: [ 'Remove pane' ]);
		menuShortcut: [ OSPlatform current primaryModifier gtDisplayString , '+Shift+Click' ];
		target: GtTreePagerPaneNormalDropdownMenuTarget;
		action: [ :aButton | self aboutToRemoveFromPreviousPane ]
]

{ #category : #actions }
GtTreePagerPaneModel >> gtUpdateToolActionFor: anAction [
	<gtAction>
	^ anAction button
		priority: 10;
		id: #'menu--rebuild-pane-tool-element';
		label: 'Update pane tool';
		target: GtTreePagerPaneNormalDropdownMenuTarget;
		addTarget: GtTreePagerPaneMaximizedDropdownMenuTarget;
		action: [ :aButton | self requestRebuildPaneTool ];
		menuDisable: [ :aMenuModel | self canRecreateToolElement not ]
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
	^ icon ifNil: [ 
		self phlowTool ifNotNil: [ :aTool | 
			[ aTool icon ] onErrorDo: [ :anException | anException return: nil ] ] ]
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
	self announcer
		announce: (GtTreePagerPaneModelActiveLinkChanged new
				paneModel: self;
				oldActiveLink: anOldActiveLink;
				newActiveLink: aNewActiveLink)
]

{ #category : #'private - notifying' }
GtTreePagerPaneModel >> notifyFollowingLinksChanged: anOldFollowingLinks reason: aReason [
	| anAnnouncement |
	anAnnouncement := GtTreePagerPaneModelFollowingLinksChanged new
			paneModel: self;
			newFollowingLinks: self followingLinks;
			oldFollowingLinks: anOldFollowingLinks;
			reason: aReason.
	self announcer announce: anAnnouncement.
	self allPreviousPanesDo: [ :aPreviousModel | 
		aPreviousModel announcer announce: anAnnouncement ]
]

{ #category : #'private - notifying' }
GtTreePagerPaneModel >> notifyMaximizePane [
	self announcer
		announce: (GtTreePagerPaneModelMaximizeRequest new paneModel: self)
]

{ #category : #'private - notifying' }
GtTreePagerPaneModel >> notifyRebuildPaneTool [
	self announcer
		announce: (GtTreePagerPaneModelRebuildToolRequest new paneModel: self)
]

{ #category : #'api - phlow' }
GtTreePagerPaneModel >> object: anObject [
	self phlowTool: anObject gtDefaultInspectorTool
]

{ #category : #'api - previous links' }
GtTreePagerPaneModel >> pagerSettings [
	"Note: it is usually a pager model"

	<return: #GtTreePagerModelSettings or: nil>
	^ self previousPane ifNotNil: #pagerSettings
]

{ #category : #accessing }
GtTreePagerPaneModel >> phlowTool [
	^ phlowTool
]

{ #category : #'api - phlow' }
GtTreePagerPaneModel >> phlowTool: aGtPhlowTool [
	phlowTool := aGtPhlowTool
]

{ #category : #copying }
GtTreePagerPaneModel >> postSimilarPaneCopy [
	| newLinks |
	announcer := Announcer new.
	previousLink := nil.
	newLinks := self followingLinks
			collect: [ :eachLink | eachLink similarLinkCopy ].
	followingLinks := GtTreePagerPaneLinks new paneModel: self.
	self followingLinks: newLinks reason: GtTreePagerCopyReason default.
	phlowTool := phlowTool ifNotNil: #similarToolCopy
]

{ #category : #'api - phlow' }
GtTreePagerPaneModel >> prepareForReusedNavigation [
	self phlowTool prepareForReusedNavigation
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
	followingLinks removeLink: aLinkModel reason: GtTreePagerRemoveReason default
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> removeFollowingLink: aLinkModel reason: aReason [
	followingLinks removeLink: aLinkModel reason: aReason
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
	self previousLink ifNotNil: [ :aPreviousLink | 
		aPreviousLink removeFromPreviousPane ]
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> removeLink [
	"Deselect an existing link model."
	
	self activeLink ifNotNil: [ :aLinkModel | 
		self removeFollowingLink: aLinkModel ]
]

{ #category : #'private - updating' }
GtTreePagerPaneModel >> replaceFollowingLink: anOldLinkModel by: aNewLinkModel reason: aReason [
	| anIndex aNewCollection |
	anIndex := self followingLinks
			detectIndex: [ :each | each == anOldLinkModel ]
			ifNone: [ NotFound signalFor: anOldLinkModel in: self followingLinks ].

	aNewLinkModel previousPane: self.
	GtTreePagerReplacedLinkUpdater new
		newLinkModel: aNewLinkModel;
		replacedLinkModel: anOldLinkModel;
		update.
	aNewCollection := self followingLinks copy
			at: anIndex put: aNewLinkModel;
			yourself.
	self followingLinks: aNewCollection reason: aReason
]

{ #category : #'api - requests' }
GtTreePagerPaneModel >> requestMaximizePane [
	self notifyMaximizePane
]

{ #category : #'api - requests' }
GtTreePagerPaneModel >> requestRebuildPaneTool [
	self notifyRebuildPaneTool
]

{ #category : #'api - state' }
GtTreePagerPaneModel >> select [
	self previousLink ifNotNil: [ :aLinkModel | 
		aLinkModel select ]
]

{ #category : #'api - previous panes' }
GtTreePagerPaneModel >> selectInPreviousPane [
	self previousLink
		ifNotNil: [ :aPreviousLink | aPreviousLink select ]
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> selectPane: aNewPaneModel [
	| anOldLinkModel aNewLinkModel |
	anOldLinkModel := self activeLink.
	aNewLinkModel := GtTreePagerLinkModel new paneModel: aNewPaneModel.

	anOldLinkModel
		ifNil: [ 
			self 
				addFollowingLink: aNewLinkModel 
				reason: GtTreePagerSelectReason default ]
		ifNotNil: [ aNewLinkModel state: anOldLinkModel state.
			self
				replaceFollowingLink: anOldLinkModel
				by: aNewLinkModel
				reason: GtTreePagerSelectReason default ]
]

{ #category : #copying }
GtTreePagerPaneModel >> similarPaneCopy [
	<return: #TGtTreePagerPaneModel>
	^ self shallowCopy postSimilarPaneCopy
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> spawnPane: aNewPaneModel [
	| anOldLinkModel aNewLinkModel |
	anOldLinkModel := self activeLink.
	aNewLinkModel := GtTreePagerLinkModel new paneModel: aNewPaneModel.
	aNewLinkModel expand.

	anOldLinkModel
		ifNil: [ 
			self 
				addFollowingLink: aNewLinkModel 
				reason: GtTreePagerSpawnReason default ]
		ifNotNil: [ 
			self
				replaceFollowingLink: anOldLinkModel
				by: aNewLinkModel
				reason: GtTreePagerSpawnReason default ]
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> spawnSiblingPane: aNewPaneModel [
	| aNewLinkModel |
	aNewLinkModel := GtTreePagerLinkModel new paneModel: aNewPaneModel.
	aNewLinkModel expand.

	self addFollowingLink: aNewLinkModel reason: GtTreePagerSpawnReason default
]

{ #category : #'api - following links' }
GtTreePagerPaneModel >> spawnedFollowingLinks [
	"Return collection of following links that are spawned"

	<return: #Collection of: #TGtTreePagerLinkModel>
	^ self followingLinks select: #isSpawned
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
	^ title
		ifNil: [ self phlowTool
				ifNotNil: [ :aTool | 
					[ aTool title ]
						onErrorDo: [ :anException | 
							anException
								return: ('{1}''s exception: {2}'
										format: {aTool className.
												anException}) ] ]
				ifNil: [ 'empty' ] ]
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
