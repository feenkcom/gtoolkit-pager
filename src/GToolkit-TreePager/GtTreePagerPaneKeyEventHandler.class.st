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
	paneElement ifNil: [ ^ self ].

	self onModifiersEvent: anEvent
]

{ #category : #'private - event handling' }
GtTreePagerPaneKeyEventHandler >> onBlMouseLeaveEvent: anEvent [ 
]

{ #category : #'private - event handling' }
GtTreePagerPaneKeyEventHandler >> onHovered [
	paneElement isAttachedToSceneGraph ifFalse: [ ^ self ].

	paneElement space addEventFilter: self
]

{ #category : #'api - hooks' }
GtTreePagerPaneKeyEventHandler >> onInstalledIn: anObject [
	super onInstalledIn: anObject.

	installedIn := anObject
]

{ #category : #'api - event managing' }
GtTreePagerPaneKeyEventHandler >> onModifiersEvent: anEvent [
	"I update the dropdown element based on event modifiers"
	paneElement ifNil: [ ^ self ].

	anEvent modifiers isSoftPrimaryModifierOnly
		ifTrue: [ ^ paneElement updateDropdownElementToCollapseIcon ].

	anEvent modifiers isSoftShiftPrimaryModifierOnly
		ifTrue: [ ^ paneElement updateDropdownElementToMaximizeIcon ].

	paneElement updateDropdownElementToDownwardsIcon
]

{ #category : #'private - event handling' }
GtTreePagerPaneKeyEventHandler >> onUnhovered [
	paneElement isAttachedToSceneGraph ifFalse: [ ^ self ].

	paneElement space removeEventFilter: self
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

	paneElement
		when: BlElementRemovedFromSceneGraphEvent do: [ :anEvent | self uninstall ];
		when: BlMouseEnterEvent do: [ :anEvent | self onBlMouseEnterEvent: anEvent ].

	paneElement
		addAptitude: (BrLazyStyleCommonAptitude new
				hovered: [ :aStyle | aStyle do: [ :aWidget | self onHovered ] after: [ :aWidget | self onUnhovered ] ])
]

{ #category : #'api - hooks' }
GtTreePagerPaneKeyEventHandler >> uninstall [
	installedIn ifNotNil: [ :anObject | anObject removeEventFilter: self ].
	installedIn := nil.
]
