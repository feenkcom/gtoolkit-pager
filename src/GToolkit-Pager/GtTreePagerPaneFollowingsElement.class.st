Class {
	#name : #GtTreePagerPaneFollowingsElement,
	#superclass : #GtTreePagerPaneBasicElement,
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #initialization }
GtTreePagerPaneFollowingsElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #initialization }
GtTreePagerPaneFollowingsElement >> initialize [
	super initialize.
	self hFitContent.
	self vMatchParent
]

{ #category : #'private - updating' }
GtTreePagerPaneFollowingsElement >> newPaneElement [
	^ GtTreePagerPaneFollowingContainerElement new
]

{ #category : #'private - updating' }
GtTreePagerPaneFollowingsElement >> newPaneElementFor: aPaneModel [
	^ self newPaneElement
		paneModel: aPaneModel;
		yourself
]

{ #category : #'private - event management' }
GtTreePagerPaneFollowingsElement >> onGtTreePagerPaneModelExpansionChanged: anAnnouncement [
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

{ #category : #'api - pane model' }
GtTreePagerPaneFollowingsElement >> subscribeToPaneModel [
	self paneModel weak
		when: GtTreePagerPaneModelFollowingPanesChanged
			send: #onGtTreePagerPaneModelFollowingPanesChanged:
			to: self;
		when: GtTreePagerPaneModelExpansionChanged
			send: #onGtTreePagerPaneModelExpansionChanged:
			to: self
]

{ #category : #'api - pane model' }
GtTreePagerPaneFollowingsElement >> unsubscribeFromPaneModel [
	self paneModel unsubscribe: self
]

{ #category : #'api - pane model' }
GtTreePagerPaneFollowingsElement >> updateElement [
	| somePaneModels somePaneElements modelsWithElements |
	somePaneModels := self paneModel followingExpandedAndCollapsedPaneModels.

	modelsWithElements := Dictionary new.
	self
		childrenDo: [ :eachChild | modelsWithElements at: eachChild paneModel put: eachChild ].

	somePaneElements := somePaneModels
			collect: [ :eachPaneModel | 
				modelsWithElements
					at: eachPaneModel
					ifPresent: [ :aPaneElement | aPaneElement ]
					ifAbsent: [ self newPaneElementFor: eachPaneModel ] ].

	self removeChildren.
	self addChildren: somePaneElements.

	somePaneElements
		ifEmpty: [ self addChild: (self newPaneElement visibility: BlVisibility hidden) ]
]
