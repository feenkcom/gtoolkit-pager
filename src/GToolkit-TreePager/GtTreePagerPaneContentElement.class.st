Class {
	#name : #GtTreePagerPaneContentElement,
	#superclass : #GtTreePagerPaneBasicElement,
	#instVars : [
		'navigationContext'
	],
	#category : #'GToolkit-TreePager-UI'
}

{ #category : #initialization }
GtTreePagerPaneContentElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #views }
GtTreePagerPaneContentElement >> gtNavigationContextFor: aView [
	<gtView>
	navigationContext ifNil: [ ^ aView empty ].
	
	^ aView forward
		title: 'Navigation context';
		priority: 1.5;
		object: [ navigationContext ];
		view: #gtNavigationContextsFor:
]

{ #category : #initialization }
GtTreePagerPaneContentElement >> initialize [
	super initialize.
	self background: self theme default contentBackground.
	self matchParent.
	self clipChildren: false.
	self beFocusable
]

{ #category : #'api - navigation' }
GtTreePagerPaneContentElement >> navigationContext [
	<return: #GtTreePagerPaneNavigationContext>
	^ navigationContext
]

{ #category : #'api - navigation' }
GtTreePagerPaneContentElement >> navigationContext: aNavigationContext [
	"Set navigation context.
	Note that the navigation context must be set before pane model, as it is likely to change GtPhlowContext that must be passed to a phlow tool before its tool element is created.
	See 
	- GtInspectorTool>>#contextWithNavigationContext:
	- GtTreePagerPaneContentElement>>#updateToolElement"

	self assert: [ self paneModel isNil ].
	
	navigationContext := aNavigationContext
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
	| targetId aToolElement |
	targetId := #tool asBlocElementId.
	self
		childrenDo: [ :eachChild | eachChild id = targetId ifTrue: [ eachChild removeFromParent ] ].

	self navigationContext
		ifNotNil: [ :aContext | self paneModel phlowTool contextWithNavigationContext: aContext ].

	aToolElement := self paneModel asElement.

	self addChild: aToolElement as: targetId
]
