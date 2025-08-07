Class {
	#name : #GtTreePagerPaneScrollPreviewElement,
	#superclass : #GtTreePagerPaneBasicElement,
	#category : #'GToolkit-TreePager-UI'
}

{ #category : #'accessing - ui' }
GtTreePagerPaneScrollPreviewElement >> incomingLinkElements [
	^ self hasPaneModel ifTrue: [ Array with: self ] ifFalse: [ Array empty ]
]

{ #category : #'api - pane model' }
GtTreePagerPaneScrollPreviewElement >> linkModel [
	^ self paneModel previousLink
]

{ #category : #'accessing - ui' }
GtTreePagerPaneScrollPreviewElement >> outgoingLinkElements [
	^ self hasPaneModel ifTrue: [ Array with: self ] ifFalse: [ Array empty ]
]
