Class {
	#name : #GtTreePagerSelectionStateHandlerElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
	#instVars : [
		'selectionStateHandler'
	],
	#category : #'GToolkit-TreePager-UI'
}

{ #category : #testing }
GtTreePagerSelectionStateHandlerElement >> hasSelectionStateHandler [
	^ selectionStateHandler isNotNil
]

{ #category : #accessing }
GtTreePagerSelectionStateHandlerElement >> selectionStateHandler [
	^ selectionStateHandler
]

{ #category : #accessing }
GtTreePagerSelectionStateHandlerElement >> selectionStateHandler: aSelectionStateHandler [
	selectionStateHandler == aSelectionStateHandler ifTrue: [ ^ self ].
	selectionStateHandler := aSelectionStateHandler.
	self updateElement
]

{ #category : #private }
GtTreePagerSelectionStateHandlerElement >> selectionStateHandlerDo: aBlock [
	^ selectionStateHandler ifNotNil: aBlock
]
