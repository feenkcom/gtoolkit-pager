Class {
	#name : #GtTreePagerPaneCompressedFollowingsElement,
	#superclass : #GtTreePagerPaneBasicElement,
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #initialization }
GtTreePagerPaneCompressedFollowingsElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #'accessing - ui' }
GtTreePagerPaneCompressedFollowingsElement >> incomingLinkElements [
	^ self children flatCollect: #incomingLinkElements
]

{ #category : #initialization }
GtTreePagerPaneCompressedFollowingsElement >> initialize [
	super initialize.
	self hExact: GtTreePagerConstants triangleWidth.
	self vMatchParent.
	self clipChildren: false.
]

{ #category : #'private - updating' }
GtTreePagerPaneCompressedFollowingsElement >> newLinkElementFor: aLinkModel [
	^ GtTreePagerLinkOutputAndCollapsedPanesElement new
		linkModel: aLinkModel;
		yourself
]

{ #category : #'private - event management' }
GtTreePagerPaneCompressedFollowingsElement >> onGtTreePagerLinkModelStateChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'private - event management' }
GtTreePagerPaneCompressedFollowingsElement >> onGtTreePagerPaneModelExpansionChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'private - event management' }
GtTreePagerPaneCompressedFollowingsElement >> onGtTreePagerPaneModelFollowingLinksChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'private - event management' }
GtTreePagerPaneCompressedFollowingsElement >> onGtTreePagerPaneModelFollowingPanesChanged: anAnnouncement [
	anAnnouncement paneModel = self paneModel ifFalse: [ ^ self ].
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'api - pane model' }
GtTreePagerPaneCompressedFollowingsElement >> onPaneModelChanged [
	self updateElement
]

{ #category : #'accessing - ui' }
GtTreePagerPaneCompressedFollowingsElement >> outgoingLinkElements [
	^ self children flatCollect: #outgoingLinkElements
]

{ #category : #'api - pane model' }
GtTreePagerPaneCompressedFollowingsElement >> subscribeToPaneModel [
	self paneModel weak
		when: GtTreePagerPaneModelFollowingLinksChanged
			send: #onGtTreePagerPaneModelFollowingPanesChanged:
			to: self;
		when: GtTreePagerLinkModelStateChanged
			send: #onGtTreePagerLinkModelStateChanged:
			to: self
]

{ #category : #'api - pane model' }
GtTreePagerPaneCompressedFollowingsElement >> unsubscribeFromPaneModel [
	self paneModel unsubscribe: self
]

{ #category : #'api - pane model' }
GtTreePagerPaneCompressedFollowingsElement >> updateElement [
	| existingElements linkElementsToDisplay |
	existingElements := Dictionary
			newFrom: (self children collect: [ :eachElement | eachElement linkModel -> eachElement ]).

	linkElementsToDisplay := Array
			streamContents: [ :aStream | 
				self paneModel followingLinks
					do: [ :eachLinkModel | 
						existingElements
							at: eachLinkModel
							ifPresent: [ :aLinkElement | aStream nextPut: aLinkElement ]
							ifAbsent: [ aStream nextPut: (self newLinkElementFor: eachLinkModel) ] ] ].

	self
		removeChildren;
		addChildren: linkElementsToDisplay
]
