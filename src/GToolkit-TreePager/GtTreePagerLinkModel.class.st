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
	#category : #'GToolkit-TreePager-Model'
}

{ #category : #'api - state' }
GtTreePagerLinkModel >> activate [
	self state: self state activate
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

{ #category : #'api - state' }
GtTreePagerLinkModel >> beActiveLink [
	self activate
]

{ #category : #'api - activation' }
GtTreePagerLinkModel >> beInactiveLink [
	self inactivate
]

{ #category : #'api - following links' }
GtTreePagerLinkModel >> children [
	<return: #Collection of: #TGtTreePagerLinkModel>
	^ self paneModel children
]

{ #category : #'api - expandable' }
GtTreePagerLinkModel >> collapse [
	self state: self state collapse
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
	self state: self state expand
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

{ #category : #printing }
GtTreePagerLinkModel >> gtDisplayOn: stream [
	stream nextPutAll: 'Link: '.
	stream nextPutAll: self title asString.
	self isCollapsed ifFalse: [ ^ self ].

	stream nextPutAll: ' ('.
	self isCollapsed ifTrue: [ stream nextPutAll: 'collapsed' ].
	stream nextPut: $)
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

{ #category : #'api - visibility' }
GtTreePagerLinkModel >> hide [
	self state: self state hide
]

{ #category : #'api - state' }
GtTreePagerLinkModel >> inactivate [
	self state: self state inactivate
]

{ #category : #initialization }
GtTreePagerLinkModel >> initialize [
	super initialize.
	state := GtTreePagerLinkState selected
]

{ #category : #'api - activation' }
GtTreePagerLinkModel >> isActive [
	^ state isActive
]

{ #category : #'api - activation' }
GtTreePagerLinkModel >> isActiveLink [
	^ self isActive
]

{ #category : #'api - expandable' }
GtTreePagerLinkModel >> isCollapsed [
	^ state isCollapsed
]

{ #category : #'api - expandable' }
GtTreePagerLinkModel >> isExpanded [
	^ state isExpanded
]

{ #category : #'api - visibility' }
GtTreePagerLinkModel >> isHidden [
	^ state isHidden
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
GtTreePagerLinkModel >> notifyStateChangedFrom: anOldState [
	| anAnnouncement |
	self previousPane ifNotNil: [ :aPane | 
		aPane linkModel: self stateChangedFrom: anOldState to: self state ].
	
	anAnnouncement := GtTreePagerLinkModelStateChanged new
			linkModel: self;
			oldState: anOldState;
			newState: self state.

	self announcer announce: anAnnouncement.
	self allPreviousPanesDo: [ :aPreviousModel | 
		aPreviousModel announcer announce: anAnnouncement ]
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

{ #category : #'api - previous panes' }
GtTreePagerLinkModel >> removeFromPreviousPane [
	self previousPane
		ifNotNil: [ :aPreviousPane | aPreviousPane removeFollowingLink: self ]
]

{ #category : #'api - following links' }
GtTreePagerLinkModel >> removeLink [
	self paneModel removeLink
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

	self replacedLink: nil.
	aParentPane addFollowingLink: aReplacedLink before: self
]

{ #category : #'api - state' }
GtTreePagerLinkModel >> select [
	self state: self state select
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
	| anOldState |
	state = aState ifTrue: [ ^ self ].

	anOldState := state.
	state := aState.
	self notifyStateChangedFrom: anOldState
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
