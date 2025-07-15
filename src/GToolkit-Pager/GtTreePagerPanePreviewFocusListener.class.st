Class {
	#name : #GtTreePagerPanePreviewFocusListener,
	#superclass : #BlCustomEventHandler,
	#instVars : [
		'previewElement',
		'scrollbarElement'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'api - accessing' }
GtTreePagerPanePreviewFocusListener >> eventsToHandle [
	^ {BlFocusInEvent.
		BlFocusOutEvent.
		BlFocusTransferEvent}
]

{ #category : #'element handlers' }
GtTreePagerPanePreviewFocusListener >> focusInEvent: anEvent [
	scrollbarElement selectPreviewElement: previewElement.	
	
	previewElement userData
		at: #previousFocusedElement
		put: anEvent target asWeakReference
]

{ #category : #'element handlers' }
GtTreePagerPanePreviewFocusListener >> focusOutEvent: anEvent [
	previewElement userData
		at: #previousFocusedElement
		put: anEvent target asWeakReference
]

{ #category : #'element handlers' }
GtTreePagerPanePreviewFocusListener >> focusTransferEvent: anEvent [
	previewElement userData
		at: #previousFocusedElement
		put: anEvent focusedElement asWeakReference
]

{ #category : #'api - hooks' }
GtTreePagerPanePreviewFocusListener >> onInstalledIn: aPaneElement [
	super onInstalledIn: aPaneElement.

	aPaneElement hasFocus
		ifTrue: [ scrollbarElement selectPreviewElement: previewElement ].
		
	aPaneElement deepestFocusedChild
		ifNotNil: [ :aFocusedElement |
			previewElement userData
				at: #previousFocusedElement
				put: aFocusedElement asWeakReference ]
]

{ #category : #'api - accessing' }
GtTreePagerPanePreviewFocusListener >> previewElement [
	^ previewElement
]

{ #category : #'api - accessing' }
GtTreePagerPanePreviewFocusListener >> previewElement: anObject [
	previewElement := anObject
]

{ #category : #'api - accessing' }
GtTreePagerPanePreviewFocusListener >> scrollbarElement [
	^ scrollbarElement
]

{ #category : #'api - accessing' }
GtTreePagerPanePreviewFocusListener >> scrollbarElement: anObject [
	scrollbarElement := anObject
]
