Class {
	#name : #GtTreePagerLinkBasicElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable + TGtTreePagerWithLinkModel',
	#classTraits : 'TBrLayoutResizable classTrait + TGtTreePagerWithLinkModel classTrait',
	#category : #'GToolkit-TreePager-UI'
}

{ #category : #printing }
GtTreePagerLinkBasicElement >> gtDisplayOn: aStream [
	self linkModel
		ifNotNil: [ :aLinkModel | 
			aLinkModel gtDisplayOn: aStream.
			aStream nextPutAll: ', ' ].
	super gtDisplayOn: aStream
]
