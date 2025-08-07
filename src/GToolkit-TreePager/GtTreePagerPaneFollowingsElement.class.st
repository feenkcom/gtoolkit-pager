Class {
	#name : #GtTreePagerPaneFollowingsElement,
	#superclass : #GtTreePagerPaneBasicElement,
	#category : #'GToolkit-TreePager-UI'
}

{ #category : #initialization }
GtTreePagerPaneFollowingsElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #'accessing - ui' }
GtTreePagerPaneFollowingsElement >> incomingLinkElements [
	^ self children flatCollect: #incomingLinkElements
]

{ #category : #initialization }
GtTreePagerPaneFollowingsElement >> initialize [
	super initialize.
	self hExact: GtTreePagerConstants triangleWidth.
	self vMatchParent.
	self clipChildren: false.
]

{ #category : #'private - event management' }
GtTreePagerPaneFollowingsElement >> onGtTreePagerLinkModelStateChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'private - event management' }
GtTreePagerPaneFollowingsElement >> onGtTreePagerPaneModelExpansionChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'private - event management' }
GtTreePagerPaneFollowingsElement >> onGtTreePagerPaneModelFollowingLinksChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'private - event management' }
GtTreePagerPaneFollowingsElement >> onGtTreePagerPaneModelFollowingPanesChanged: anAnnouncement [
	anAnnouncement paneModel = self paneModel ifFalse: [ ^ self ].
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'api - pane model' }
GtTreePagerPaneFollowingsElement >> onPaneModelChanged [
	self updateElement
]

{ #category : #'accessing - ui' }
GtTreePagerPaneFollowingsElement >> outgoingLinkElements [
	^ self children flatCollect: #outgoingLinkElements
]

{ #category : #'api - pane model' }
GtTreePagerPaneFollowingsElement >> subscribeToPaneModel [
	self paneModel weak
		when: GtTreePagerPaneModelFollowingLinksChanged
			send: #onGtTreePagerPaneModelFollowingPanesChanged:
			to: self;
		when: GtTreePagerLinkModelStateChanged
			send: #onGtTreePagerLinkModelStateChanged:
			to: self
]

{ #category : #'api - pane model' }
GtTreePagerPaneFollowingsElement >> unsubscribeFromPaneModel [
	self paneModel unsubscribe: self
]

{ #category : #'api - pane model' }
GtTreePagerPaneFollowingsElement >> updateElement [
	GtTreePagerPaneFollowingsElementUpdater new
		followingsElement: self;
		update
]
