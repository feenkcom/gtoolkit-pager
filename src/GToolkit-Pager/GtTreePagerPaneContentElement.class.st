Class {
	#name : #GtTreePagerPaneContentElement,
	#superclass : #GtTreePagerPaneBasicElement,
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #initialization }
GtTreePagerPaneContentElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtTreePagerPaneContentElement >> initialize [
	super initialize.
	self background: self theme default contentBackground.
	self matchParent.
	self clipChildren: false.
	self beFocusable
]

{ #category : #'private - event handling' }
GtTreePagerPaneContentElement >> onGtTreePagerPaneModelRebuildToolRequest: anAnnouncement [
	self paneModel = anAnnouncement paneModel ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ self updateToolElement ]
]

{ #category : #'api - pane model' }
GtTreePagerPaneContentElement >> onPaneModelChanged [
	self updateElement
]

{ #category : #accessing }
GtTreePagerPaneContentElement >> realToolElementDo: aBlock [
	"Temporary solution, as some tool elements are wrapped. Such cases must be eliminated."

	self
		toolElementDo: [ :anElement | 
			(anElement isKindOf: GtPagerWrapperElement)
				ifTrue: [ anElement tool ifNotNil: aBlock ]
				ifFalse: [ anElement ifNotNil: aBlock ] ]
]

{ #category : #'api - pane model' }
GtTreePagerPaneContentElement >> subscribeToPaneModel [
	self paneModel weak
		when: GtTreePagerPaneModelRebuildToolRequest
		send: #onGtTreePagerPaneModelRebuildToolRequest:
		to: self
]

{ #category : #accessing }
GtTreePagerPaneContentElement >> toolElement [
	| targetId |
	targetId := #tool asBlocElementId.
	self
		childrenDo: [ :eachChild | eachChild id = targetId ifTrue: [ ^ eachChild ] ].

	^ nil
]

{ #category : #accessing }
GtTreePagerPaneContentElement >> toolElementDo: aBlock [
	self toolElement ifNotNil: aBlock
]

{ #category : #'api - pane model' }
GtTreePagerPaneContentElement >> unsubscribeFromPaneModel [
	self paneModel unsubscribe: self
]

{ #category : #'private - updating' }
GtTreePagerPaneContentElement >> updateElement [
	self updateToolElement
]

{ #category : #'private - updating' }
GtTreePagerPaneContentElement >> updateToolElement [
	| targetId |
	targetId := #tool asBlocElementId.
	self
		childrenDo: [ :eachChild | eachChild id = targetId ifTrue: [ eachChild removeFromParent ] ].

	self addChild: self paneModel asElement as: targetId
]
