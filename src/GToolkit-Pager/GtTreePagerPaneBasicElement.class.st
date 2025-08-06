Class {
	#name : #GtTreePagerPaneBasicElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable + TGtTreePagerWithPaneModel',
	#classTraits : 'TBrLayoutResizable classTrait + TGtTreePagerWithPaneModel classTrait',
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #printing }
GtTreePagerPaneBasicElement >> gtDisplayOn: aStream [
	self paneModel
		ifNotNil: [ :aPaneModel | 
			aPaneModel gtDisplayOn: aStream.
			aStream nextPutAll: ', ' ].
	super gtDisplayOn: aStream
]
