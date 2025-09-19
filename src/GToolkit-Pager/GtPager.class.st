Class {
	#name : #GtPager,
	#superclass : #BrPager,
	#instVars : [
		'context'
	],
	#category : #'GToolkit-Pager-! Core'
}

{ #category : #'instance creation' }
GtPager class >> createOn: anElement [
	| aPager theElement |
	theElement := anElement asStencil asElement.
	self 
		assert: [ theElement viewModel isKindOf: BrPagerPageModel ] 
		description: [ 'The tool element must have ', BrPagerPageModel name asString, ' view model' ].
	aPager := self new.
	aPager 
		matchParent;
		addPage: theElement.
	^ aPager
]

{ #category : #'instance creation' }
GtPager class >> createWrappedOn: anElement [
	^ self createOn: (self wrapped: anElement)
]

{ #category : #defaults }
GtPager class >> defaultExtent [
	^ 1200@600
]

{ #category : #'private - instance creation' }
GtPager class >> newSpaceWith: anElement title: aTitle [
	| aSpace |
	aSpace := BlSpace new.
	aSpace withSceneDriller.
	aSpace title: aTitle asString.
	aSpace extent: self defaultExtent.
	aSpace root addChild: anElement.
	^ aSpace
]

{ #category : #'instance creation' }
GtPager class >> openOn: anElement [
	^ self openOn: anElement title: 'GToolkit'
]

{ #category : #'instance creation' }
GtPager class >> openOn: anElement title: aTitle [
	| aPager |
	aPager :=  self createOn: anElement.
	self openSpaceWith: aPager title: aTitle.
	^ aPager
]

{ #category : #'instance creation' }
GtPager class >> openOn: anElement title: aTitle from: aSourceElement [
	| aPager |
	aPager :=  self createOn: anElement.
	self openSpaceWith: aPager title: aTitle from: aSourceElement.
	^ aPager
]

{ #category : #'private - instance creation' }
GtPager class >> openSpaceWith: anElement title: aTitle [
	| aSpace |
	aSpace := self newSpaceWith: anElement title: aTitle.
	aSpace show.
	^ aSpace
]

{ #category : #'private - instance creation' }
GtPager class >> openSpaceWith: anElement title: aTitle from: aSourceElement [
	| aSpace |
	aSpace := self newSpaceWith: anElement title: aTitle.
	aSourceElement showSpace: aSpace.
	^ aSpace
]

{ #category : #'instance creation' }
GtPager class >> openWrappedOn: anElement [
	^ self openOn: (self wrapped: anElement)
]

{ #category : #'instance creation' }
GtPager class >> openWrappedOn: anElement title: aTitle [
	^ self openOn: (self wrapped: anElement) title: aTitle
]

{ #category : #'instance creation' }
GtPager class >> openWrappedOn: anElement title: aTitle from: aSourceElement [
	^ self 
		openOn: (self wrapped: anElement) 
		title: aTitle 
		from: aSourceElement
]

{ #category : #utility }
GtPager class >> wrapped: anElement [
	^ GtPagerWrapperElement new
		tool: anElement
]

{ #category : #'api - adding / removing' }
GtPager >> addWrapped: anElement [
	self addPage: (self class wrapped: anElement)
]

{ #category : #asserting }
GtPager >> assertToolElement: aToolElement [
	self 
		assert: [ aToolElement isKindOf: BlElement ] 
		description: [ 'Tool element must be kind of ', BlElement name ].
	self 
		assert: [ aToolElement viewModel isKindOf: BrPagerPageModel ] 
		description: [ 'Tool element view model must be kind of ', BrPagerPageModel name ].
	
]

{ #category : #accessing }
GtPager >> context [
	<return: #GtPagerContext>
	^ context
]

{ #category : #defaults }
GtPager >> defaultContext [
	^ GtPagerContext new
]

{ #category : #'gt - extensions' }
GtPager >> gtNavigationContextFor: aView [
	<gtView>
	self pages ifEmpty: [ ^ aView empty ].
	
	^ aView forward
		title: 'Navigation contexts';
		priority: 3;
		object: [ self navigationContext ];
		view: #gtNavigationContextsFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			tooltip: 'Inspect navigation context'
			action: [ :aButton | aButton phlow spawnObject: self navigationContext ]
]

{ #category : #initialization }
GtPager >> initialize [
	super initialize.
	context := self defaultContext.
	self
		addShortcut:
			(BlShortcutWithAction new
				repeatable: true;
				combination: BlKeyCombination primaryW;
				action: [ :aShortcutEvent | 
					self pages size > 1 
						ifTrue: [
							self removePageAt: self pages size.
							aShortcutEvent consumed: true ]
						ifFalse: [ aShortcutEvent beNotConsumed ] ] ).
						
	self 
		when: BrTabGroupCanBeClosedQuestionEvent
		do: [ :anEvent | self onBrTabGroupCanBeClosedQuestionEvent: anEvent ].
	self 
		when: BrTagGroupPreventedCloseAttemptEvent
		do: [ :anEvent | self onBrTagGroupPreventedCloseAttemptEvent: anEvent ]
]

{ #category : #'api - requests' }
GtPager >> maximizePageContentIn: anElement [
	GtPagerEventPassingMaximizer new 
		pager: self;
		contentElement: anElement;
		syncMaximize
]

{ #category : #'api - requests' }
GtPager >> maximized [
	"Maximize the last page"
	self pages ifEmpty: [ ^ self ].
	self maximizePageContentIn: self pages last contentElement.
]

{ #category : #'api - requests' }
GtPager >> minimizePageContentIn: anElement [
	GtPagerEventPassingMaximizer new 
		pager: self;
		contentElement: anElement;
		minimize
]

{ #category : #'api - requests' }
GtPager >> minimized [
	"Minimize the last page"
	self pages ifEmpty: [ ^ self ].
	self minimizePageContentIn: self pages last contentElement.
]

{ #category : #'gt - extensions' }
GtPager >> navigationContext [
	<return: #GtPagerPageNavigationContext>
	self pages
		reverseDo: [ :eachPageModel | 
			eachPageModel
				widgetDo: [ :aWidget | 
					^ aWidget navigationContext ] ].
	^ nil
]

{ #category : #'instance creation' }
GtPager >> newPagerModel [
	^ GtPagerModel new
]

{ #category : #'private - event handling' }
GtPager >> onBrTabGroupCanBeClosedQuestionEvent: anEvent [
	"Prevent closing me if I have more than one page."

	self pages size > 1 ifTrue: [
		anEvent bePrevented.
		^ self ]
]

{ #category : #'private - event handling' }
GtPager >> onBrTagGroupPreventedCloseAttemptEvent: anEvent [
	anEvent consumed: true.
	self pages size > 1 ifTrue: [ 
		self removePageAt: self pages size ]
]

{ #category : #'api - scrolling' }
GtPager >> select: aGtPagerPageSelectionContext [
	aGtPagerPageSelectionContext ifDefinedDo: [ 
		self assertToolElement: aGtPagerPageSelectionContext afterPage.
		(self hasPageAfter: aGtPagerPageSelectionContext afterPage) ifTrue: [
			self spawn: aGtPagerPageSelectionContext ] ]
]

{ #category : #'api - scrolling' }
GtPager >> spawn: aGtPagerPageSelectionContext [
	aGtPagerPageSelectionContext createNavigationContextWithPager: self.

	aGtPagerPageSelectionContext asElementDo: [ :aWrapperElement | 
		self assertToolElement: aWrapperElement.
		self assertToolElement: aGtPagerPageSelectionContext afterPage.
		self removePagesAfter: aGtPagerPageSelectionContext afterPage.
		
		self context toolSelectionStatesHandler 
						applySelectionStateTo: aWrapperElement tool.
		
		self addPage: aWrapperElement.
		self smoothScrollToLast
	] 
]
