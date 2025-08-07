"
I hold backward compatibility API with {{gtClass:GtPager}}. The rest of the code is expected to be implemented in my superclass.
"
Class {
	#name : #GtTreePager,
	#superclass : #GtTreePagerElement,
	#category : #'GToolkit-TreePager-UI'
}

{ #category : #factory }
GtTreePager class >> createOn: anElementStencil [
	^ self createWrappedOn: anElementStencil
]

{ #category : #factory }
GtTreePager class >> createWrappedOn: anElementStencilOrPhlowTool [
	| aPaneModel aPagerModel aPagerElement |
	(anElementStencilOrPhlowTool isKindOf: GtPagerWrapperElement)
		ifTrue: [ aPaneModel := GtTreePagerPaneModel new stencil: [ anElementStencilOrPhlowTool tool removeFromParent ] ].
		
	(aPaneModel isNil and: [ anElementStencilOrPhlowTool isKindOf: BlElement ])
		ifTrue: [ aPaneModel := GtTreePagerPaneModel new stencil: [ anElementStencilOrPhlowTool removeFromParent ] ].
		
	(anElementStencilOrPhlowTool isKindOf: BlStencil)
		ifTrue: [ aPaneModel := GtTreePagerPaneModel new stencil: anElementStencilOrPhlowTool ].
		
	(anElementStencilOrPhlowTool isKindOf: GtPhlowAbstractTool)
		ifTrue: [ aPaneModel := GtTreePagerPaneModel new phlowTool: anElementStencilOrPhlowTool ].
		
	anElementStencilOrPhlowTool isClosure
		ifTrue: [ aPaneModel := GtTreePagerPaneModel new stencil: anElementStencilOrPhlowTool ].
		
	aPaneModel
		ifNil: [ aPaneModel := GtTreePagerPaneModel new object: anElementStencilOrPhlowTool ].

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

{ #category : #'backward compatibility' }
GtTreePager >> pages [
	^ self pagerModel
		ifNotNil: [ :aPagerModel | aPagerModel paneModels ]
		ifNil: [ #() ]
]
