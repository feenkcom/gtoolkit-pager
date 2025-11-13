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
	self beFocusable.
	self
		when: BrPopoverWhoToPinToEvent
		do: [ :anEvent | self onMenuWhoToPinToEvent: anEvent ]
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

	BlTaskAction
		enqueueElement: self
		action: [ 
			self paneModel prepareForReusedNavigation.
			self updateToolElement ]
]

{ #category : #'private - event handling' }
GtTreePagerPaneContentElement >> onMenuWhoToPinToEvent: anEvent [
	anEvent consumed: true.
	anEvent anchorElement: self
]

{ #category : #'api - pane model' }
GtTreePagerPaneContentElement >> onPaneModelChanged [
	self updateElement
]

{ #category : #accessing }
GtTreePagerPaneContentElement >> realToolElementDo: aBlock [
	"Temporary solution, as some tool elements are wrapped. Such cases must be eliminated."

	self toolElementDo: [ :anElement | 
		self realToolElementDo: aBlock in: anElement ]
]

{ #category : #'private - updating' }
GtTreePagerPaneContentElement >> realToolElementDo: aBlock in: anElement [
	"Temporary solution, as some tool elements are wrapped. Such cases must be eliminated."

	(anElement isKindOf: GtPagerWrapperElement)
		ifTrue: [ anElement tool ifNotNil: aBlock ]
		ifFalse: [ anElement ifNotNil: aBlock ]
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
	| targetId aToolElement aSelectionState |
	targetId := #tool asBlocElementId.
	
	"Let's store the selection state to keep the same state in the new phlow tool element"
	self realToolElementDo: [ :aRealToolElement | 
		aSelectionState := GtPhlowToolSelectionStateHandler new.
		aSelectionState storeSelectionStateFrom: aRealToolElement ].
	
	self
		childrenDo: [ :eachChild | 
			eachChild id = targetId ifTrue: [ 
				eachChild removeFromParent.
				BrWidgetPermanentlyRemovedEvent notifyWithAllChildren: eachChild. ] ].

	self navigationContext
		ifNotNil: [ :aContext | self paneModel phlowTool contextWithNavigationContext: aContext ].

	aToolElement := self paneModel asElement.
	BrAsyncElementFutureScheduledEventHandler ensureEventHandlerIn: aToolElement.

	"Let's apply the selection state to keep the same state in the new phlow tool element"
	aSelectionState ifNotNil: [ 
		self 
			realToolElementDo: [ :aRealToolElement | 
				aSelectionState 
					applySelectionStateTo: aRealToolElement ] 
			in: aToolElement  ].
			
	self addChild: aToolElement as: targetId.
]
