Class {
	#name : #GtTreePagerLinkModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer + TGtTreePagerLinkModelState + TGtTreePagerLinkModel + TGtTreePagerPaneModel + TGtTreePagerModelEnumerable',
	#classTraits : 'TGtAnnouncer classTrait + TGtTreePagerLinkModelState classTrait + TGtTreePagerLinkModel classTrait + TGtTreePagerPaneModel classTrait + TGtTreePagerModelEnumerable classTrait',
	#instVars : [
		'paneModel',
		'previousPane',
		'state',
		'replacedLink'
	],
	#category : #'GToolkit-TreePager-Model Core'
}

{ #category : #'gt - extensions' }
GtTreePagerLinkModel class >> gtLinkActionsFor: aView [
	<gtClassView>
	| aList |
	aList := aView columnedList
			title: 'Link actions';
			items: [ | aPager allActions |
				aPager := GtTreePagerExamples new pagerWithAllLinkStates.
				allActions := Array
						streamContents: [ :aStream | 
							aPager
								allLinkModelsBreadthFirstDo: [ :eachLink | 
									aStream
										nextPutAll: (eachLink gtActions collect: [ :eachAction | eachAction -> eachLink ]) ] ].
				(allActions groupedBy: [ :each | each key definingSelector ]) associations
					sort: [ :a :b | 
						(a value
							detect: [ :eachAssoc | (eachAssoc key isKindOf: GtPhlowNoAction) not ]
							ifFound: [ :eachAssoc | eachAssoc key priority ]
							ifNone: [ a value anyOne key priority ])
							< (b value
									detect: [ :eachAssoc | (eachAssoc key isKindOf: GtPhlowNoAction) not ]
									ifFound: [ :eachAssoc | eachAssoc key priority ]
									ifNone: [ b value anyOne key priority ]) ] ];
			send: [ :anAssoc | 
				anAssoc value
					detect: [ :eachAssoc | (eachAssoc key isKindOf: GtPhlowNoAction) not ]
					ifFound: [ :eachAssoc | eachAssoc key ]
					ifNone: [ anAssoc value anyOne key ] ];
			column: 'Title'
				text: [ :anAssoc | 
					anAssoc value
						detect: [ :eachAssoc | (eachAssoc key isKindOf: GtPhlowNoAction) not ]
						ifFound: [ :eachAssoc | eachAssoc key description ]
						ifNone: [ anAssoc value anyOne key description ] ]
				weight: 2.5;
			column: 'Shortcut'
				text: [ :anAssoc | 
					anAssoc value
						detect: [ :eachAssoc | (eachAssoc key isKindOf: GtPhlowNoAction) not ]
						ifFound: [ :eachAssoc | eachAssoc key menuShortcutIfPresent: [ :e | e value ] ifAbsent: [ '' ] ]
						ifNone: [ '' ] ];
			column: 'Priority'
				text: [ :anAssoc | 
					anAssoc value
						detect: [ :eachAssoc | (eachAssoc key isKindOf: GtPhlowNoAction) not ]
						ifFound: [ :eachAssoc | eachAssoc key priority ]
						ifNone: [ anAssoc value anyOne key priority ] ]
				width: 60.

	GtTreePagerLinkState gtAllStates
		do: [ :eachState | 
			aList
				column: eachState label
				text: [ :anAssoc | 
					anAssoc value
						detect: [ :eachAssoc | 
							eachAssoc value state = eachState
								and: [ (eachAssoc key isKindOf: GtPhlowNoAction) not
										and: [ eachAssoc key target isForTarget: GtTreePagerLinkTarget ] ] ]
						ifFound: [ :eachAssoc | 'yes' ]
						ifNone: [ '' ] ] ].

	^ aList
]

{ #category : #'api - previous panes' }
GtTreePagerLinkModel >> aboutToRemoveFromPreviousPane [
	self remove
]

{ #category : #'api - state' }
GtTreePagerLinkModel >> activate [
	self state: self state activate reason: GtTreePagerActivateReason default
]

{ #category : #'api - pane model' }
GtTreePagerLinkModel >> activeLink [
	"TODO: I think it can be removed"

	<return: #TGtTreePagerLinkModel or: nil>
	^ self previousPane activeLink
]

{ #category : #'api - following links' }
GtTreePagerLinkModel >> allFollowingPanesCount [
	^ paneModel allFollowingPanesCount
]

{ #category : #'api - previous links' }
GtTreePagerLinkModel >> allPreviousLinksDo: aBlock [
	"Iterate previous links hierarchy"

	self previousPane
		ifNotNil: [ :aPreviousPane | 
			aPreviousPane previousLink ifNotNil: [ :aPreviousLink | 
				aBlock value: aPreviousLink.
				aPreviousLink allPreviousLinksDo: aBlock ] ]
]

{ #category : #'api - previous links' }
GtTreePagerLinkModel >> allPreviousPanesDo: aBlock [
	"Iterate previous panes hierarchy"

	self previousPane
		ifNotNil: [ :aPreviousPane | 
			aBlock value: aPreviousPane.
			aPreviousPane allPreviousPanesDo: aBlock ]
]

{ #category : #announcer }
GtTreePagerLinkModel >> announcer [
	<return: #Announcer>
	^ self paneModel announcer
]

{ #category : #'api - activation' }
GtTreePagerLinkModel >> beInactiveLink [
	self inactivate
]

{ #category : #'api - phlow' }
GtTreePagerLinkModel >> canRecreateToolElement [
	<return: #Boolean>
	^ self paneModel canRecreateToolElement
]

{ #category : #'api - following links' }
GtTreePagerLinkModel >> children [
	<return: #Collection of: #TGtTreePagerLinkModel>
	^ self paneModel children
]

{ #category : #'api - expandable' }
GtTreePagerLinkModel >> collapse [
	self state: self state collapse reason: GtTreePagerCollapseReason default
]

{ #category : #'api - expandable' }
GtTreePagerLinkModel >> collapse: aBoolean [
	aBoolean ifTrue: [ self collapse ] ifFalse: [ self expand ]
]

{ #category : #'api - previous panes' }
GtTreePagerLinkModel >> depthIndex [
	^ self previousPane
		ifNotNil: [ :aPaneModel | aPaneModel depthIndex + 1 ]
		ifNil: [ 1 ]
]

{ #category : #'api - enumeration' }
GtTreePagerLinkModel >> enumerableLinkModels [
	<return: #Collection of: #TGtTreePagerLinkModel>
	^ self paneModel enumerableLinkModels
]

{ #category : #'api - enumeration' }
GtTreePagerLinkModel >> enumerablePaneModels [
	<return: #Collection of: #GtTreePagerPaneModel>
	^ self paneModel enumerablePaneModels
]

{ #category : #'api - expandable' }
GtTreePagerLinkModel >> expand [
	self state: self state expand reason: GtTreePagerSpawnReason default
]

{ #category : #'api - following links' }
GtTreePagerLinkModel >> followingCollapsedLinkModels [
	^ paneModel followingCollapsedLinkModels
]

{ #category : #'api - following links' }
GtTreePagerLinkModel >> followingLinks [
	<return: #Collection of: #TGtTreePagerLinkModel>
	^ self paneModel followingLinks
]

{ #category : #'api - following links' }
GtTreePagerLinkModel >> followingSpawnedLinkModels [
	^ paneModel followingSpawnedLinkModels
]

{ #category : #actions }
GtTreePagerLinkModel >> gtActivateLinkActionFor: anAction [
	<gtAction>
	self depthIndex = 1 ifTrue: [ ^ anAction noAction ].
	self isActive ifTrue: [ ^ anAction noAction ].
	self isRemoved ifTrue: [ ^ anAction noAction ].
	
	^ anAction button
		priority: 1;
		id: #'menu--activate-link';
		label: 'Activate link';
		icon: BrGlamorousVectorIcons accept;
		menuShortcut: [ 'Click' ];
		target: GtTreePagerLinkTarget;
		action: [ :aButton | self activate ]
]

{ #category : #actions }
GtTreePagerLinkModel >> gtCollapseLinkActionFor: anAction [
	<gtAction>
	self depthIndex = 1 ifTrue: [ ^ anAction noAction ].
	self isSpawned ifFalse: [ ^ anAction noAction ].
	
	^ anAction button
		priority: 2;
		id: #'menu--collapse-pane';
		label: 'Collapse pane';
		icon: BrGlamorousVectorIcons collapsebar;
		target: GtTreePagerLinkTarget;
		action: [ :aButton | self collapse ]
]

{ #category : #printing }
GtTreePagerLinkModel >> gtDisplayOn: stream [
	stream nextPutAll: 'Link: '.
	stream nextPutAll: self title asString.
	self isCollapsed ifFalse: [ ^ self ].

	stream nextPutAll: ' ('.
	self isCollapsed ifTrue: [ stream nextPutAll: 'collapsed' ].
	stream nextPut: $)
]

{ #category : #actions }
GtTreePagerLinkModel >> gtExpandLinkActionFor: anAction [
	<gtAction>
	self depthIndex = 1 ifTrue: [ ^ anAction noAction ].
	self isSpawned ifTrue: [ ^ anAction noAction ].
	self isRemoved ifTrue: [ ^ anAction noAction ].
	
	^ anAction button
		priority: 2;
		id: #'menu--expand-pane';
		label: 'Expand pane';
		icon: BrGlamorousVectorIcons maximize;
		target: GtTreePagerLinkTarget;
		action: [ :aButton | self expand ]
]

{ #category : #actions }
GtTreePagerLinkModel >> gtHidePanesActionFor: anAction [
	<gtAction>
	GtTreePagerSettings isDisplayHideMenuItem ifFalse: [ ^ anAction noAction ].
	self followingSpawnedLinkModels ifEmpty: [ ^ anAction noAction ].
	
	^ anAction button
		priority: 3;
		id: #'tree-pager--menu--hide';
		label: 'Collapse this and following panes';
		target: GtTreePagerLinkTarget;
		action: [ :aButton | self hide ]
]

{ #category : #actions }
GtTreePagerLinkModel >> gtKeepLinkActionFor: anAction [
	<gtAction>
	self depthIndex = 1 ifTrue: [ ^ anAction noAction ].
	self isActive ifFalse: [ ^ anAction noAction ].
	
	^ anAction button
		priority: 1;
		id: #'menu--keep-link';
		label: 'Inactivate link';
		icon: BrGlamorousVectorIcons interdiction;
		menuShortcut: [ 'Click' ];
		target: GtTreePagerLinkTarget;
		action: [ :aButton | self inactivate ]
]

{ #category : #views }
GtTreePagerLinkModel >> gtLiveFor: aView [
	<gtView>
	self paneModel ifNil: [ ^ aView empty ].

	^ aView explicit
		title: 'Live';
		priority: 10;
		stencil: [ BrFrame new
				matchParent;
				padding: (BlInsets all: 10);
				addChild: (GtTreePagerPaneElement new paneModel: self paneModel) ]
]

{ #category : #views }
GtTreePagerLinkModel >> gtPaneModelFor: aView [
	<gtView>
	paneModel ifNil: [ ^ aView empty ].
	
	^ aView forward
		title: 'Links';
		object: [ paneModel ];
		view: #gtFollowingPanesFor:
]

{ #category : #actions }
GtTreePagerLinkModel >> gtPermanentlyRemoveLinkActionFor: anAction [
	<gtAction>
	self depthIndex = 1 ifTrue: [ ^ anAction noAction ].
	self isRemoved ifFalse: [ ^ anAction noAction ].

	^ anAction button
		priority: 10;
		id: #'tree-pager--menu-permanent-remove';
		label: 'Permanently remove link';
		icon: BrGlamorousVectorIcons bin;
		target: GtTreePagerLinkTarget;
		action: [ :aButton | 
			| aWish |
			aWish := BrPopoverAnchorElementWish new.
			aButton fireEvent: aWish.
			aWish anchorElementDo: [ :anAnchor | 
				anAnchor dispatchEvent: BrCountdownDisableAndStopWish withoutFinishedAction ].
			self removeFromPreviousPane ]
]

{ #category : #views }
GtTreePagerLinkModel >> gtPreviousLinksFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Previous links';
		items: [ self withAllPreviousLinks ];
		column: 'Index'
			text: [ :_ :anIndex | anIndex ]
			width: 40;
		column: 'Link' text: #gtDisplayString;
		column: 'State' text: [ :eachLink | eachLink state label ]
]

{ #category : #views }
GtTreePagerLinkModel >> gtPreviousPanesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Previous panes';
		items: [ self withAllPreviousPanes ];
		column: 'Index'
			text: [ :_ :anIndex | anIndex ]
			width: 40;
		column: 'Link' text: #gtDisplayString;
		column: 'State' text: [ :eachLink | eachLink state label ]
]

{ #category : #actions }
GtTreePagerLinkModel >> gtRemoveLinkActionFor: anAction [
	<gtAction>
	self depthIndex = 1 ifTrue: [ ^ anAction noAction ].
	self isRemoved ifTrue: [ ^ anAction noAction ].
	
	^ anAction button
		priority: 10;
		id: #'tree-pager--menu-remove';
		label: 'Remove link';
		icon: BrGlamorousVectorIcons bin;
		target: GtTreePagerLinkTarget;
		action: [ :aButton | self aboutToRemoveFromPreviousPane ]
]

{ #category : #actions }
GtTreePagerLinkModel >> gtReplacedLinkRemoveActionFor: anAction [
	<gtAction>
	^ anAction button
		priority: 50;
		id: #'tree-pager--remove-link';
		label: 'Remove';
		icon: BrGlamorousVectorIcons bin;
		target: GtTreePagerReplacedLinkTarget;
		menuItemPreview: [ self title ];
		action: [ :aButton | 
			aButton anchor ifNotNil: [ :anElement | 
				anElement dispatchEvent: BrCountdownDisableAndStopWish withoutFinishedAction ].
			self removeReplacedLink ]
]

{ #category : #actions }
GtTreePagerLinkModel >> gtReplacedLinkRestoreActionFor: anAction [
	<gtAction>
	^ anAction button
		priority: 2;
		id: #'tree-pager--restore-link';
		label: 'Restore';
		icon: BrGlamorousVectorIcons add;
		target: GtTreePagerReplacedLinkTarget;
		menuItemPreview: [ self title ];
		action: [ :aButton | 
			aButton anchor ifNotNil: [ :anElement | 
				anElement dispatchEvent: BrCountdownDisableAndStopWish withoutFinishedAction ].
			self restoreReplacedLink ]
]

{ #category : #actions }
GtTreePagerLinkModel >> gtRestoreLinkActionFor: anAction [
	<gtAction>
	self depthIndex = 1 ifTrue: [ ^ anAction noAction ].
	self isRemoved ifFalse: [ ^ anAction noAction ].
	
	^ anAction button
		priority: 1;
		id: #'menu--restore-pane';
		label: 'Restore pane';
		icon: BrGlamorousVectorIcons add;
		menuShortcut: [ 'Click' ];
		target: GtTreePagerLinkTarget;
		action: [ :aButton | 
			| aWish |
			aWish := BrPopoverAnchorElementWish new.
			aButton fireEvent: aWish.
			aWish anchorElementDo: [ :anAnchor |
				anAnchor dispatchEvent: BrCountdownDisableAndStopWish withoutFinishedAction ].
			self expand ]
]

{ #category : #'api - visibility' }
GtTreePagerLinkModel >> hide [
	self state: self state hide reason: GtTreePagerSelectReason default
]

{ #category : #'api - state' }
GtTreePagerLinkModel >> inactivate [
	self state: self state inactivate reason: GtTreePagerInactivateReason default
]

{ #category : #initialization }
GtTreePagerLinkModel >> initialize [
	super initialize.
	state := GtTreePagerLinkState selected
]

{ #category : #'api - activation' }
GtTreePagerLinkModel >> isActiveLink [
	^ self isActive
]

{ #category : #'api - expandable' }
GtTreePagerLinkModel >> isExpanded [
	^ state isExpanded
]

{ #category : #'api - previous links' }
GtTreePagerLinkModel >> isInHiddenLink [
	"Return true if this links is in a tree branch that is hidden or selected.
	Following links of a hidden and selected parent link are not displayed as spawned panes"

	self allPreviousPanesDo: [ :aPaneModel | 
		aPaneModel isHidden ifTrue: [ ^ true ].
		aPaneModel isSelected ifTrue: [ ^ true ] ].
	
	^ false
]

{ #category : #'private - notifying' }
GtTreePagerLinkModel >> notifyAboutToRestoreReplacedLink: aReplacedLink in: aParentPane [
	| anAnnouncement |
	anAnnouncement := GtTreePagerLinkModelAboutToRestoreReplacedLinkAnnouncement
			new
			linkModel: self;
			replacedLink: aReplacedLink;
			parentPane: aParentPane.

	self announcer announce: anAnnouncement.
]

{ #category : #'private - notifying' }
GtTreePagerLinkModel >> notifyStateChangedFrom: anOldState reason: aReason [
	| anAnnouncement |
	self previousPane ifNotNil: [ :aPane | 
		aPane linkModel: self stateChangedFrom: anOldState to: self state ].
	
	anAnnouncement := GtTreePagerLinkModelStateChanged new
			linkModel: self;
			oldState: anOldState;
			newState: self state;
			reason: aReason.

	self announcer announce: anAnnouncement.
	self allPreviousPanesDo: [ :aPreviousModel | 
		aPreviousModel announcer announce: anAnnouncement ]
]

{ #category : #'api - previous links' }
GtTreePagerLinkModel >> pagerSettings [
	"Note: it is usually a pager model"

	<return: #GtTreePagerModelSettings or: nil>
	^ self previousPane ifNotNil: #pagerSettings
]

{ #category : #accessing }
GtTreePagerLinkModel >> paneModel [
	<return: #GtTreePagerPaneModel>
	^ paneModel
]

{ #category : #accessing }
GtTreePagerLinkModel >> paneModel: aPaneModel [
	self assert: [ aPaneModel isKindOf: GtTreePagerPaneModel ].

	aPaneModel previousLink: self.
	paneModel := aPaneModel.
]

{ #category : #copying }
GtTreePagerLinkModel >> postSimilarLinkCopy [
	previousPane := nil.
	self paneModel: paneModel similarPaneCopy.
]

{ #category : #'api - pane model' }
GtTreePagerLinkModel >> previousLink [
	<return: #TGtTreePagerLinkModel or: nil>
	^ self previousPane ifNotNil: #previousLink
]

{ #category : #accessing }
GtTreePagerLinkModel >> previousPane [
	^ previousPane
]

{ #category : #accessing }
GtTreePagerLinkModel >> previousPane: aPaneModel [
	self assert: [ paneModel isNotNil ].
	self assert: [ aPaneModel isNotNil ].
	previousPane := aPaneModel
]

{ #category : #printing }
GtTreePagerLinkModel >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: self title asString.
	self isCollapsed ifTrue: [ aStream nextPutAll: ', collapsed' ].
	aStream nextPut: $)
]

{ #category : #'api - state' }
GtTreePagerLinkModel >> remove [
	"Set removed state"

	self state: self state remove reason: GtTreePagerRemoveReason default
]

{ #category : #'api - previous panes' }
GtTreePagerLinkModel >> removeFromPreviousPane [
	self previousPane ifNotNil: [ :aPreviousPane | 
		aPreviousPane removeFollowingLink: self ]
]

{ #category : #'api - following links' }
GtTreePagerLinkModel >> removeLink [
	"Deselect an existing link model."

	self paneModel removeLink
]

{ #category : #'api - replaced link' }
GtTreePagerLinkModel >> removeReplacedLink [
	| aReplacedLink anAnnouncement |
	replacedLink ifNil: [ ^ self ].
	aReplacedLink := replacedLink.
	replacedLink := nil.

	anAnnouncement := GtTreePagerLinkModelReplacedLinkRemoved new
			linkModel: self;
			replacedLink: aReplacedLink.
	self announcer announce: anAnnouncement.
	self allPreviousPanesDo: [ :eachPane | 
		eachPane announcer announce: anAnnouncement ]
]

{ #category : #'api - replaced link' }
GtTreePagerLinkModel >> replacedLink [
	<return: #GtTreePagerLinkModel or: nil>
	^ replacedLink
]

{ #category : #'api - replaced link' }
GtTreePagerLinkModel >> replacedLink: anObject [
	replacedLink := anObject
]

{ #category : #'api - replaced link' }
GtTreePagerLinkModel >> restoreReplacedLink [
	| aReplacedLink aParentPane |
	aReplacedLink := self replacedLink ifNil: [ ^ self ].
	aParentPane := self previousPane ifNil: [ ^ self ].

	self notifyAboutToRestoreReplacedLink: aReplacedLink in: aParentPane.
	
	replacedLink := nil.
	aParentPane
		addFollowingLink: aReplacedLink
		before: self
		reason: GtTreePagerRestoreReason default
]

{ #category : #'api - state' }
GtTreePagerLinkModel >> select [
	self state: self state select reason: GtTreePagerSelectReason default
]

{ #category : #'api - following links' }
GtTreePagerLinkModel >> selectPane: aPaneModel [
	self paneModel selectPane: aPaneModel
]

{ #category : #copying }
GtTreePagerLinkModel >> similarPaneCopy [
	<return: #TGtTreePagerPaneModel>
	^ self paneModel similarPaneCopy
]

{ #category : #'api - following links' }
GtTreePagerLinkModel >> spawnPane: aPaneModel [
	self paneModel spawnPane: aPaneModel
]

{ #category : #'api - following links' }
GtTreePagerLinkModel >> spawnedFollowingLinks [
	"Return collection of following links that are spawned"

	<return: #Collection of: #TGtTreePagerLinkModel>
	^ self paneModel spawnedFollowingLinks
]

{ #category : #'api - state' }
GtTreePagerLinkModel >> state [
	^ state
]

{ #category : #'api - state' }
GtTreePagerLinkModel >> state: aState [
	self state: aState reason: GtTreePagerUnknownReason default
]

{ #category : #'api - state' }
GtTreePagerLinkModel >> state: aState reason: aReason [
	| anOldState |
	state = aState ifTrue: [ ^ self ].

	anOldState := state.
	state := aState.
	self notifyStateChangedFrom: anOldState reason: aReason
]

{ #category : #'api - accessing' }
GtTreePagerLinkModel >> timestamp [
	"Return a timestamp that indicates time of a pane creation, ideally time it was added to a pager."

	<return: #DateAndTime>
	^ self paneModel timestamp
]

{ #category : #accessing }
GtTreePagerLinkModel >> title [
	^ paneModel title
]

{ #category : #'api - previous links' }
GtTreePagerLinkModel >> withAllPreviousLinks [
	^ Array
		streamContents: [ :aStream | 
			aStream nextPut: self.
			self allPreviousLinksDo: [ :eachLink | aStream nextPut: eachLink ] ]
]

{ #category : #'api - previous links' }
GtTreePagerLinkModel >> withAllPreviousPanes [
	^ Array
		streamContents: [ :aStream | 
			aStream nextPut: self.
			self allPreviousPanesDo: [ :eachPane | aStream nextPut: eachPane ] ]
]
