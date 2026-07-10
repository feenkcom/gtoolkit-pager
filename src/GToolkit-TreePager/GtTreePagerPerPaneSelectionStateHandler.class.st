Class {
	#name : #GtTreePagerPerPaneSelectionStateHandler,
	#superclass : #Object,
	#traits : 'TGtPhlowToolSelectionStateHandler',
	#classTraits : 'TGtPhlowToolSelectionStateHandler classTrait',
	#instVars : [
		'selectionStateHandlers',
		'selectionStateHandler'
	],
	#category : #'GToolkit-TreePager-Model Rest'
}

{ #category : #actions }
GtTreePagerPerPaneSelectionStateHandler >> applySelectionState: aSelectionState to: aToolElement treePaneContext: aTreePagerPaneSelectionStateContext [
	"Apply an explicitly defined selected state to an element"

	<parameterType: #GtPhlowToolSelectionState>
	<parameterType: #BlElement>
	<parameterType: #GtTreePagerPaneSelectionStateContext>
	<return: #GtPhlowToolSelectionStateResponse>
	| aPaneSelectionStateHandler |
	aToolElement phlow isTool ifFalse: [ ^ self ].

	aPaneSelectionStateHandler := self
			selectionStateHandlerFromTreePaneContext: aTreePagerPaneSelectionStateContext.

	aPaneSelectionStateHandler
		applySelectionState: aSelectionState
		to: aToolElement
		treePaneContext: aTreePagerPaneSelectionStateContext
]

{ #category : #actions }
GtTreePagerPerPaneSelectionStateHandler >> applySelectionStateTo: aToolElement [
	"Apply a stored selected state to an element"

	selectionStateHandler ifNil: [ ^ self ].
	aToolElement phlow isTool ifFalse: [ ^ self ].
	
	selectionStateHandler applySelectionStateTo: aToolElement
]

{ #category : #'as yet unclassified' }
GtTreePagerPerPaneSelectionStateHandler >> applySelectionStateTo: aToolElement treePaneContext: aTreePagerPaneSelectionStateContext [
	"Apply a stored selected state to an element"

	<parameterType: #BlElement>
	<parameterType: #GtTreePagerPaneSelectionStateContext>
	| aPaneSelectionStateHandler |
	aToolElement phlow isTool ifFalse: [ ^ self ].

	aPaneSelectionStateHandler := self
			selectionStateHandlerFromTreePaneContext: aTreePagerPaneSelectionStateContext.

	aPaneSelectionStateHandler
		applySelectionStateTo: aToolElement
		treePaneContext: aTreePagerPaneSelectionStateContext
]

{ #category : #initialization }
GtTreePagerPerPaneSelectionStateHandler >> initialize [
	super initialize.
	
	selectionStateHandler := GtPhlowToolCircularSelectionStateHandler new.
	selectionStateHandlers := Dictionary new.
]

{ #category : #private }
GtTreePagerPerPaneSelectionStateHandler >> newSelectionStateHandler [
	^ selectionStateHandler similarSelectionStateHandler
]

{ #category : #copying }
GtTreePagerPerPaneSelectionStateHandler >> postSimilarSelectionStateHandler [
	selectionStateHandler := selectionStateHandler similarSelectionStateHandler.
	selectionStateHandlers := selectionStateHandlers copy.
	selectionStateHandlers keysAndValuesDo: [ :eachKey :eachValue | 
		selectionStateHandlers at: eachKey put: eachKey similarSelectionStateHandler ]
]

{ #category : #accessing }
GtTreePagerPerPaneSelectionStateHandler >> selectionStateHandler [
	<return: #TGtPhlowToolSelectionStateHandler>
	^ selectionStateHandler
]

{ #category : #accessing }
GtTreePagerPerPaneSelectionStateHandler >> selectionStateHandler: aSelectionStateHandler [
	"Set a default selection state handler that is used to create similar copies for individual pane positions."

	self
		assert: [ aSelectionStateHandler isNotNil ]
		description: [ 'Selection state must be non-nil' ].
	self
		assert: [ selectionStateHandler isNil ]
		description: [ 'The object is immutable. Crate a new instance if you want to change the instance variable' ].

	selectionStateHandler := aSelectionStateHandler
]

{ #category : #accessing }
GtTreePagerPerPaneSelectionStateHandler >> selectionStateHandlerClass: anObject [
	selectionStateHandler := anObject
]

{ #category : #private }
GtTreePagerPerPaneSelectionStateHandler >> selectionStateHandlerFromTreePaneContext: aTreePagerPaneSelectionStateContext [
	^ selectionStateHandlers
		at: (Array
				with: aTreePagerPaneSelectionStateContext columnIndex
				with: aTreePagerPaneSelectionStateContext rowIndex)
		ifAbsentPut: [ self newSelectionStateHandler ]
]

{ #category : #actions }
GtTreePagerPerPaneSelectionStateHandler >> storeSelectionStateFrom: aToolElement [
	"Store tool element's selected state"

	selectionStateHandler ifNil: [ ^ self ].
	aToolElement phlow isTool ifFalse: [ ^ self ].

	selectionStateHandler storeSelectionStateFrom: aToolElement
]

{ #category : #'as yet unclassified' }
GtTreePagerPerPaneSelectionStateHandler >> storeSelectionStateFrom: aToolElement treePaneContext: aTreePagerPaneSelectionStateContext [
	"Store tool element's selected state"

	<parameterType: #BlElement>
	<parameterType: #GtTreePagerPaneSelectionStateContext>
	| aSelectionStateHandler |
	aToolElement phlow isTool ifFalse: [ ^ self ].

	aSelectionStateHandler := self
			selectionStateHandlerFromTreePaneContext: aTreePagerPaneSelectionStateContext.

	aSelectionStateHandler
		storeSelectionStateFrom: aToolElement
		treePaneContext: aTreePagerPaneSelectionStateContext
]
