Class {
	#name : #GtPagerWrapperElement,
	#superclass : #BlElement,
	#traits : 'TGtPhlowToolDetailAdjustable',
	#classTraits : 'TGtPhlowToolDetailAdjustable classTrait',
	#category : #'GToolkit-CommonPager-UI'
}

{ #category : #factory }
GtPagerWrapperElement class >> forElement: aToolElement [
	(aToolElement isKindOf: self) ifTrue: [ ^ aToolElement ].
	^ self new tool: aToolElement
]

{ #category : #initialization }
GtPagerWrapperElement >> createToolAreaElement [
	^ BrFrame new
		labeled: 'Tool Container';
		id: self toolAreaIdentifier;
		clipChildren: false;
		matchParent
]

{ #category : #accessing }
GtPagerWrapperElement >> embellisher: aStencil [
	self viewModel embellisher: aStencil
]

{ #category : #'gt - extensions' }
GtPagerWrapperElement >> gtNavigationContextFor: aView [
	<gtView>
	^ aView forward
		title: 'Navigation contexts';
		priority: 3;
		object: [ self navigationContext ];
		view: #gtNavigationContextsFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			tooltip: 'Inspect navigation context'
			action: [ :aButton | aButton phlow spawnObject: self navigationContext ]
]

{ #category : #testing }
GtPagerWrapperElement >> hasTool [
	<return: #Boolean>

	^ self 
		childWithId: self toolAreaIdentifier
		ifFound: [ :aToolAreaElement |
			aToolAreaElement
				childWithId: self toolIdentificator 
				ifFound: [ :aToolElement | true ] 
				ifNone: [ false ] ]
		ifNone: [ false ]
]

{ #category : #initialization }
GtPagerWrapperElement >> initialize [
	super initialize.
	
	self 
		id: GtPagerToolWrapperElementId;
		clipChildren: false;
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ];
		viewModel: GtPagerPageModel new;
		when: BrPopoverWhoToPinToEvent do: [ :anEvent | 
			self onMenuWhoToPinToEvent: anEvent ].

	self addChild: self createToolAreaElement.
]

{ #category : #accessing }
GtPagerWrapperElement >> model: anObject [
	self viewModel model: anObject
]

{ #category : #accessing }
GtPagerWrapperElement >> navigationContext [
	<return: #GtPagerPageNavigationContext>
	^ self viewModel navigationContext
]

{ #category : #accessing }
GtPagerWrapperElement >> navigationContext: aNavigationContext [
	^ self viewModel navigationContext: aNavigationContext
]

{ #category : #'event handling' }
GtPagerWrapperElement >> onMenuWhoToPinToEvent: anEvent [ 
	anEvent consumed: true.
	anEvent anchorElement: self.
]

{ #category : #'focus requesting' }
GtPagerWrapperElement >> requestFocus [
	self hasTool
		ifTrue: [ self tool requestFocus ]
		ifFalse: [ super requestFocus ]
]

{ #category : #accessing }
GtPagerWrapperElement >> tool [
	<return: #BlElement>

	^ self toolArea childWithId: self toolIdentificator
]

{ #category : #accessing }
GtPagerWrapperElement >> tool: anElement [
	self toolArea
		addChild: anElement asStencil asElement
		as: self toolIdentificator
]

{ #category : #accessing }
GtPagerWrapperElement >> toolArea [
	<return: #BlElement>

	^ self childWithId: self toolAreaIdentifier
]

{ #category : #accessing }
GtPagerWrapperElement >> toolAreaIdentifier [
	^ #toolArea
]

{ #category : #accessing }
GtPagerWrapperElement >> toolIdentificator [
	^ #tool
]

{ #category : #'api - accessing' }
GtPagerWrapperElement >> toolViewModel [
	<return: #TGtPhlowToolViewModel>
	^ self tool phlow toolViewModel
]
