Class {
	#name : #GtTreePagerExplicitlySelectedTabStorageEventHandler,
	#superclass : #GtPhlowExplicitlySelectedTabStorageEventHandler,
	#category : #'GToolkit-TreePager-Support'
}

{ #category : #'api - accessing' }
GtTreePagerExplicitlySelectedTabStorageEventHandler >> eventsToHandle [
	^ super eventsToHandle , {GtTreePagerModelChanged}
]

{ #category : #private }
GtTreePagerExplicitlySelectedTabStorageEventHandler >> newSelectionStateContextForToolElement: aToolElement [
	^ aToolElement
		allParentsDetect: [ :eachParent | eachParent isKindOf: GtTreePagerPaneElement ]
		ifFound: [ :aPaneElement | 
			^ GtTreePagerPaneSelectionStateContext new
				toolElement: aToolElement;
				columnIndex: aPaneElement constraints horizontalTreeFlow depth;
				rowIndex: aPaneElement constraints horizontalTreeFlow row ]
		ifNone: [ nil ]
]

{ #category : #'event handling' }
GtTreePagerExplicitlySelectedTabStorageEventHandler >> phlowExplicitlySelectedTabEvent: anEvent [
	| aToolElement aSelectionStateContext |
	selectionStateHandler ifNil: [ ^ self ].
	anEvent consumed: true.
	aToolElement := anEvent toolElement ifNil: [ ^ self ].

	aSelectionStateContext := self
			newSelectionStateContextForToolElement: aToolElement.
	aSelectionStateContext ifNil: [ ^ self ].

	selectionStateHandler
		storeSelectionStateFrom: aToolElement
		treePaneContext: aSelectionStateContext
]

{ #category : #'event handling' }
GtTreePagerExplicitlySelectedTabStorageEventHandler >> treePagerModelChanged: anEvent [
	anEvent consumed: true.

	selectionStateHandler := anEvent pagerModel pagerSettings selectionStateHandler.
]
