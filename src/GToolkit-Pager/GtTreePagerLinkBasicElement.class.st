Class {
	#name : #GtTreePagerLinkBasicElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable + TGtTreePagerWithLinkModel',
	#classTraits : 'TBrLayoutResizable classTrait + TGtTreePagerWithLinkModel classTrait',
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #printing }
GtTreePagerLinkBasicElement >> gtDisplayOn: aStream [
	self linkModel
		ifNotNil: [ :aLinkModel | 
			aLinkModel gtDisplayOn: aStream.
			aStream nextPutAll: ', ' ].
	super gtDisplayOn: aStream
]
