Class {
	#name : #GtTreePagerPaneKeyEventHandler,
	#superclass : #BlCustomEventHandler,
	#instVars : [
		'paneElement',
		'installedIn'
	],
	#category : #'GToolkit-TreePager-Support'
}

{ #category : #'api - accessing' }
GtTreePagerPaneKeyEventHandler >> eventsToHandle [
	^ { BlKeyDownEvent. BlKeyUpEvent}
]

{ #category : #'as yet unclassified' }
GtTreePagerPaneKeyEventHandler >> installIn: anObject [ 
	installedIn == anObject ifTrue: [ ^ self ].
	
	installedIn ifNotNil: [ self uninstall ].
	anObject addEventHandler: self
]

{ #category : #'as yet unclassified' }
GtTreePagerPaneKeyEventHandler >> installedIn [
	^ installedIn
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

{ #category : #'private - event handling' }
GtTreePagerPaneKeyEventHandler >> onBlMouseEnterEvent: anEvent [ 
]

{ #category : #'private - event handling' }
GtTreePagerPaneKeyEventHandler >> onBlMouseLeaveEvent: anEvent [ 
]

{ #category : #'api - hooks' }
GtTreePagerPaneKeyEventHandler >> onInstalledIn: anObject [
	self assert: [ installedIn isNil ].
	super onInstalledIn: anObject.

	installedIn := anObject
]

{ #category : #'api - event managing' }
GtTreePagerPaneKeyEventHandler >> onModifiersEvent: anEvent [
	paneElement ifNil: [ ^ self ].

	paneElement onModifiersEvent: anEvent
]

{ #category : #'api - hooks' }
GtTreePagerPaneKeyEventHandler >> onUninstalledIn: anObject [
	super onUninstalledIn: anObject.
	installedIn := nil
]

{ #category : #accessing }
GtTreePagerPaneKeyEventHandler >> paneElement [
	^ paneElement
]

{ #category : #accessing }
GtTreePagerPaneKeyEventHandler >> paneElement: anElement [
	self assert: [ paneElement isNil ].
	paneElement := anElement.
	
	paneElement when: BlMouseEnterEvent do: [ :anEvent | self onBlMouseEnterEvent: anEvent ].
	paneElement when: BlMouseLeaveEvent do: [ :anEvent | self onBlMouseLeaveEvent: anEvent ]
]

{ #category : #'api - hooks' }
GtTreePagerPaneKeyEventHandler >> uninstall [
	installedIn ifNotNil: [ :anObject | anObject removeEventFilter: self ].
	installedIn := nil.
]
