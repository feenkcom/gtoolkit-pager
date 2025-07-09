Class {
	#name : #GtTreePagerLinkModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer + TGtTreePagerLinkModelState + TGtTreePagerPreviousLinkModelAdaptor',
	#classTraits : 'TGtAnnouncer classTrait + TGtTreePagerLinkModelState classTrait + TGtTreePagerPreviousLinkModelAdaptor classTrait',
	#instVars : [
		'paneModel',
		'previousPane',
		'announcer',
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

{ #category : #'api - pane model' }
GtTreePagerLinkModel >> allPreviousPanesDo: aFullBlockClosure [
	"Iterate previous panes hierarchy"

	self previousPane allPreviousPanesDo: aFullBlockClosure
]

{ #category : #announcer }
GtTreePagerLinkModel >> announcer [
	<return: #Announcer>
	^ announcer
]

{ #category : #'api - state' }
GtTreePagerLinkModel >> beActiveLink [
	self activate
]

{ #category : #'api - activation' }
GtTreePagerLinkModel >> beInactiveLink [
	self inactivate
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
	^ self previousPane depthIndex
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
GtTreePagerLinkModel >> followingExpandedLinkModels [
	^ paneModel followingExpandedLinkModels
]

{ #category : #'api - following links' }
GtTreePagerLinkModel >> followingLinks [
	^ paneModel followingLinks
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
	announcer := Announcer new.
	state := GtTreePagerLinkState selected.
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

{ #category : #'api - visibility' }
GtTreePagerLinkModel >> isDisplayed [
	^ state isDisplayed
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
	self announcer
		announce: (GtTreePagerLinkModelStateChanged new
				linkModel: self;
				oldState: anOldState;
				newState: self state)
]

{ #category : #accessing }
GtTreePagerLinkModel >> paneModel [
	^ paneModel
]

{ #category : #accessing }
GtTreePagerLinkModel >> paneModel: aPaneModel [
	self assert: [ aPaneModel isKindOf: GtTreePagerPaneModel ].

	aPaneModel previousLink: self.
	paneModel := aPaneModel.
]

{ #category : #accessing }
GtTreePagerLinkModel >> previousPane [
	^ previousPane
]

{ #category : #accessing }
GtTreePagerLinkModel >> previousPane: aPaneModel [
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
		ifNotNil: [ :aPreviousPane | aPreviousPane removeFollowingPane: self ]
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
