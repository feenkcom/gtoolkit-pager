Class {
	#name : #GtTreePagerLinkModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'paneModel',
		'previousPane',
		'announcer',
		'state',
		'isHidden',
		'isActive'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'api - following links' }
GtTreePagerLinkModel >> allFollowingPanesCount [
	^ paneModel allFollowingPanesCount
]

{ #category : #announcer }
GtTreePagerLinkModel >> announcer [
	<return: #Announcer>
	^ announcer
]

{ #category : #'api - activation' }
GtTreePagerLinkModel >> beActiveLink [
	self previousPane ifNotNil: [ :aPaneModel | aPaneModel activeLink: self ]
]

{ #category : #'api - activation' }
GtTreePagerLinkModel >> beInactiveLink [
	self previousPane ifNotNil: [ :aPaneModel | aPaneModel inactivateLink: self ]
]

{ #category : #'api - expandable' }
GtTreePagerLinkModel >> collapse [
	^ paneModel collapse
]

{ #category : #'api - expandable' }
GtTreePagerLinkModel >> expand [
	^ paneModel expand
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

{ #category : #initialization }
GtTreePagerLinkModel >> initialize [
	super initialize.
	isActive := false.
	announcer := Announcer new.
	state := GtTreePagerLinkState selected.
	isHidden := false
]

{ #category : #'api - activation' }
GtTreePagerLinkModel >> isActiveLink [
	^ self previousPane
		ifNotNil: [ :aPaneModel | aPaneModel activeLink = self ]
		ifNil: [ false ]
]

{ #category : #'api - expandable' }
GtTreePagerLinkModel >> isCollapsed [
	^ paneModel isCollapsed
]

{ #category : #'api - expandable' }
GtTreePagerLinkModel >> isExpanded [
	^ paneModel isExpanded
]

{ #category : #accessing }
GtTreePagerLinkModel >> paneModel [
	^ paneModel
]

{ #category : #accessing }
GtTreePagerLinkModel >> paneModel: aPaneModel [
	self assert: [ aPaneModel isKindOf: GtTreePagerPaneModel ].

	paneModel := aPaneModel
]

{ #category : #accessing }
GtTreePagerLinkModel >> previousPane [
	^ previousPane
]

{ #category : #accessing }
GtTreePagerLinkModel >> previousPane: aPaneModel [
	previousPane := aPaneModel.
	paneModel previousPane: aPaneModel
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

{ #category : #accessing }
GtTreePagerLinkModel >> title [
	^ paneModel title
]
