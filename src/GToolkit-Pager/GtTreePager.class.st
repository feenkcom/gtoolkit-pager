"
I hold backward compatibility API with {{gtClass:GtPager}}. The rest of the code is expected to be implemented in my superclass.
"
Class {
	#name : #GtTreePager,
	#superclass : #GtTreePagerElement,
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #factory }
GtTreePager class >> createWrappedOn: anElementStencil [
	| aPaneModel aPagerModel aPagerElement |
	(anElementStencil isKindOf: BlElement)
		ifTrue: [ aPaneModel := GtTreePagerPaneModel new stencil: anElementStencil ].
	(anElementStencil isKindOf: BlStencil)
		ifTrue: [ aPaneModel := GtTreePagerPaneModel new stencil: anElementStencil ].
	(anElementStencil isKindOf: GtPhlowAbstractTool)
		ifTrue: [ aPaneModel := GtTreePagerPaneModel new phlowTool: anElementStencil ].
	anElementStencil isClosure
		ifTrue: [ aPaneModel := GtTreePagerPaneModel new stencil: anElementStencil ].
	aPaneModel
		ifNil: [ aPaneModel := GtTreePagerPaneModel new object: anElementStencil ].

	aPagerModel := GtTreePagerModel new paneModel: aPaneModel.
	aPagerElement := self new pagerModel: aPagerModel.

	^ aPagerElement
]

{ #category : #'api - requests' }
GtTreePager >> maximized [
	| someLinks |
	self hasPagerModel ifFalse: [ ^ self ].
	someLinks := self pagerModel linkModels ifEmpty: [ ^ self ].

	panesElement
		childrenNodesDo: [ :eachPaneElement | 
			eachPaneElement maximize.
			^ self ]
]
