Class {
	#name : #GtPagerWrapperElement,
	#superclass : #BlElement,
	#traits : 'TGtPhlowToolDetailAdjustable',
	#classTraits : 'TGtPhlowToolDetailAdjustable classTrait',
	#instVars : [
		'volumeModel'
	],
	#category : #'GToolkit-Pager-UI'
}

{ #category : #factory }
GtPagerWrapperElement class >> forElement: aToolElement [
	(aToolElement isKindOf: self) ifTrue: [ ^ aToolElement ].
	^ self new tool: aToolElement
]

{ #category : #accessing }
GtPagerWrapperElement >> embellisher: aStencil [
	self viewModel embellisher: aStencil
]

{ #category : #testing }
GtPagerWrapperElement >> hasTool [
	<return: #Boolean>
	^ self 
		childNamed: self toolAreaIdentifier
		ifFound: [ :aToolAreaElement |
			aToolAreaElement
				childNamed: self toolIdentificator 
				ifFound: [ :aToolElement | true ] 
				ifNone: [ false ] ]
		ifNone: [ false ]
]

{ #category : #initialization }
GtPagerWrapperElement >> initialize [
	super initialize.
	self initializeViewModel.
	self initializeElement.
	self initializeToolAreaElement.
]

{ #category : #initialization }
GtPagerWrapperElement >> initializeElement [
	self 
		labeled: 'Tool Wrapper';
		clipChildren: false;
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].
]

{ #category : #initialization }
GtPagerWrapperElement >> initializeToolAreaElement [
	| anElement |
	anElement := BlElement new
		labeled: 'Tool Container';
		clipChildren: false;
		layout: BlFrameLayout new;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].
	self addChild: anElement as: self toolAreaIdentifier.
]

{ #category : #initialization }
GtPagerWrapperElement >> initializeViewModel [
	self viewModel: GtPagerPageModel new.
	self addInteractiveModelState: GtPhlowToolContainerDetailModel new beUndefinedLevel.
]

{ #category : #accessing }
GtPagerWrapperElement >> model: anObject [
	self viewModel model: anObject
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
	^ self toolArea childNamed: self toolIdentificator.
]

{ #category : #accessing }
GtPagerWrapperElement >> tool: anElement [
	self toolArea
		addChild: anElement asElement 
		as: self toolIdentificator.
]

{ #category : #accessing }
GtPagerWrapperElement >> toolArea [
	<return: #BlElement>
	^ self childNamed: self toolAreaIdentifier.
]

{ #category : #accessing }
GtPagerWrapperElement >> toolAreaIdentifier [
	^ #toolArea
]

{ #category : #accessing }
GtPagerWrapperElement >> toolIdentificator [
	^ #tool
]
