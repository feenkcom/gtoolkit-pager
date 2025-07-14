Class {
	#name : #GtTreePagerPanePreviewResizeListener,
	#superclass : #BlCustomEventHandler,
	#instVars : [
		'previewElement',
		'height'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'element handlers' }
GtTreePagerPanePreviewResizeListener >> elementExtentChangedEvent: anEvent [
	self updateSizeFrom: anEvent currentTarget
]

{ #category : #'api - accessing' }
GtTreePagerPanePreviewResizeListener >> eventsToHandle [
	^ { BlElementExtentChangedEvent }
]

{ #category : #accessing }
GtTreePagerPanePreviewResizeListener >> height [
	^ height
]

{ #category : #accessing }
GtTreePagerPanePreviewResizeListener >> height: anObject [
	height := anObject
]

{ #category : #initialization }
GtTreePagerPanePreviewResizeListener >> initialize [
	super initialize.
	
	height := 10
]

{ #category : #'api - hooks' }
GtTreePagerPanePreviewResizeListener >> onInstalledIn: aPageElement [
	super onInstalledIn: aPageElement.
	
	self updateSizeFrom: aPageElement
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
GtTreePagerPanePreviewResizeListener >> updateSizeFrom: aPageElement [
	| aPageExtent aScale aPreviewExtent |

	aPageExtent := aPageElement extent max: 1@1.
	aScale := (aPageExtent y / 10).
	
	self
		assert: [ aScale isZero not ]
		description: [ 'Scale must not be zero' ].
	
	aScale < 1
		ifTrue: [
			aScale := 1.
			aPageExtent := self height asPoint ].

	aPreviewExtent := (aPageExtent / aScale).
	aPreviewExtent := ((aPreviewExtent x / (aPreviewExtent y / self height)) @ self height) ceiling.

	self
		assert: [ aPreviewExtent isIntegerPoint ]
		description: [ 'Extent must be an integer point' ].
	
	self previewElement size: aPreviewExtent
]
