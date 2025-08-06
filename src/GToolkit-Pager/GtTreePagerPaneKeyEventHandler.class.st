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
	paneElement ifNil: [ ^ self ].

	self onModifiersEvent: anEvent
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
