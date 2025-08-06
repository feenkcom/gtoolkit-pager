Class {
	#name : #GtTreePagerPaneKeyEventHandler,
	#superclass : #BlCustomEventHandler,
	#instVars : [
		'paneElement'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'api - accessing' }
GtTreePagerPaneKeyEventHandler >> eventsToHandle [
	^ { BlKeyDownEvent. BlKeyUpEvent}
]

{ #category : #'api - event managing' }
GtTreePagerPaneKeyEventHandler >> keyDownEvent: anEvent [
	paneElement ifNil: [ ^ self ].

	self onModifiersEvent: anEvent
]

{ #category : #'api - event managing' }
GtTreePagerPaneKeyEventHandler >> keyUpEvent: anEvent [
	| aCopy |
	paneElement ifNil: [ ^ self ].

	"Let's process an event for which 
	the modifiers does not include released keys."
	(anEvent key isPrimary or: [ anEvent key isShift ])
		ifTrue: [ aCopy := anEvent copy modifiers: anEvent modifiers copy.
			anEvent key isMeta ifTrue: [ aCopy modifiers cmd: false ].
			anEvent key isControl ifTrue: [ aCopy modifiers ctrl: false ].
			anEvent key isShift ifTrue: [ aCopy modifiers shift: false ] ]
		ifFalse: [ aCopy := anEvent ].

	self onModifiersEvent: aCopy
]

{ #category : #'api - event managing' }
GtTreePagerPaneKeyEventHandler >> onModifiersEvent: anEvent [
	paneElement ifNil: [ ^ self ].

	paneElement onModifiersEvent: anEvent
]

{ #category : #accessing }
GtTreePagerPaneKeyEventHandler >> paneElement [
	^ paneElement
]

{ #category : #accessing }
GtTreePagerPaneKeyEventHandler >> paneElement: anElement [
	self assert: [ paneElement isNil ].
	paneElement := anElement
]
