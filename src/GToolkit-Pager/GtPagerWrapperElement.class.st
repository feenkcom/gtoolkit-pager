Class {
	#name : #GtPagerWrapperElement,
	#superclass : #BlElement,
	#traits : 'TGtPhlowToolDetailAdjustable',
	#classTraits : 'TGtPhlowToolDetailAdjustable classTrait',
	#category : #'GToolkit-Pager-UI'
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
		viewModel: GtPagerPageModel new.

	self addChild: self createToolAreaElement
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
		addChild: anElement asElement 
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
