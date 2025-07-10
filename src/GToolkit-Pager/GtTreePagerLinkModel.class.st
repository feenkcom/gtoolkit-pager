Class {
	#name : #GtTreePagerLinkModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer + TGtTreePagerLinkModelState + TGtTreePagerLinkModel + TGtTreePagerPaneModel',
	#classTraits : 'TGtAnnouncer classTrait + TGtTreePagerLinkModelState classTrait + TGtTreePagerLinkModel classTrait + TGtTreePagerPaneModel classTrait',
	#instVars : [
		'paneModel',
		'previousPane',
		'state'
	],
	#category : #'GToolkit-Pager-Tree Pager'
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

{ #category : #'as yet unclassified' }
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
	^ self previousPane ifNotNil: #depthIndex ifNil: [ 1 ]
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
	self
		allPreviousPanesDo: [ :aPreviousPane | aPreviousPane announcer announce: anAnnouncement ]
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

{ #category : #'api - following links' }
GtTreePagerLinkModel >> selectPane: aPaneModel [
	self paneModel selectPane: aPaneModel
]

{ #category : #'api - following links' }
GtTreePagerLinkModel >> spawnPane: aPaneModel [
	self paneModel spawnPane: aPaneModel
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
