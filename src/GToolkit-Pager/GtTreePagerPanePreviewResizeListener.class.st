Class {
	#name : #GtTreePagerPanePreviewResizeListener,
	#superclass : #BlCustomEventHandler,
	#instVars : [
		'previewElement',
		'width'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'element handlers' }
GtTreePagerPanePreviewResizeListener >> elementExtentChangedEvent: anEvent [
	self updateSizeFrom: anEvent currentTarget.

	BlTaskAction
		enqueueElement: self previewElement
		action: [ self updateSizeFrom: anEvent currentTarget ]
]

{ #category : #'api - accessing' }
GtTreePagerPanePreviewResizeListener >> eventsToHandle [
	^ { BlElementExtentChangedEvent }
]

{ #category : #initialization }
GtTreePagerPanePreviewResizeListener >> initialize [
	super initialize.
	
	width := 5
]

{ #category : #'api - hooks' }
GtTreePagerPanePreviewResizeListener >> onInstalledIn: aPaneElement [
	super onInstalledIn: aPaneElement.

	self updateSizeFrom: aPaneElement.

	BlTaskAction
		enqueueElement: self previewElement
		action: [ self updateSizeFrom: aPaneElement ]
]

{ #category : #accessing }
GtTreePagerPanePreviewResizeListener >> previewElement [
	^ previewElement
]

{ #category : #accessing }
GtTreePagerPanePreviewResizeListener >> previewElement: anObject [
	previewElement := anObject
]

{ #category : #'element handlers' }
GtTreePagerPanePreviewResizeListener >> updateSizeFrom: aPaneElement [
	| aPaneExtent anExtentRatio aPreviewWidth |
	aPaneExtent := aPaneElement extent max: 1 @ 1.
	anExtentRatio := aPaneExtent x / aPaneExtent y.

	aPreviewWidth := (self previewElement height * anExtentRatio) ceiling.
	aPreviewWidth < 1 ifTrue: [ aPreviewWidth := self width ].

	self
		assert: [ aPreviewWidth isInteger ]
		description: [ 'Extent must be an integer point' ].

	self previewElement hExact: aPreviewWidth
]

{ #category : #accessing }
GtTreePagerPanePreviewResizeListener >> width [
	^ width
]

{ #category : #accessing }
GtTreePagerPanePreviewResizeListener >> width: anObject [
	width := anObject
]
