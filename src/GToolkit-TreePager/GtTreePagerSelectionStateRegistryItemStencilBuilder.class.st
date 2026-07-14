Class {
	#name : #GtTreePagerSelectionStateRegistryItemStencilBuilder,
	#superclass : #BrStencilBuilder,
	#instVars : [
		'selectionStateHandler'
	],
	#category : #'GToolkit-TreePager-Support'
}

{ #category : #'instance creation' }
GtTreePagerSelectionStateRegistryItemStencilBuilder >> buildDefault [
	| aSelectionStateHandler |
	aSelectionStateHandler := self selectionStateHandler
			ifNil: [ GtPhlowToolEmptySelectionStateHandler new ].

	^ (aSelectionStateHandler respondsTo: #asElement)
		ifTrue: [ aSelectionStateHandler asElement ]
		ifFalse: [ BlElement new size: 0 @ 0 ]
]

{ #category : #accessing }
GtTreePagerSelectionStateRegistryItemStencilBuilder >> paramsOn: aStencilExecutor [
	super paramsOn: aStencilExecutor.

	aStencilExecutor push: self selectionStateHandler
]

{ #category : #accessing }
GtTreePagerSelectionStateRegistryItemStencilBuilder >> reset [
	super reset.

	selectionStateHandler := nil
]

{ #category : #accessing }
GtTreePagerSelectionStateRegistryItemStencilBuilder >> selectionStateHandler [
	^ selectionStateHandler
]

{ #category : #accessing }
GtTreePagerSelectionStateRegistryItemStencilBuilder >> selectionStateHandler: anObject [
	selectionStateHandler := anObject
]
