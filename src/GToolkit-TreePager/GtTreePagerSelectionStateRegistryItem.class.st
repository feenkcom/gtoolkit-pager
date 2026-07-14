Class {
	#name : #GtTreePagerSelectionStateRegistryItem,
	#superclass : #Object,
	#instVars : [
		'priority',
		'name',
		'description',
		'selectionStateStencil',
		'elementStencilBuilder'
	],
	#category : #'GToolkit-TreePager-Settings'
}

{ #category : #converting }
GtTreePagerSelectionStateRegistryItem >> asElement [
	^ GtTreePagerSelectionStateRegistryItemElement new registryItem: self
]

{ #category : #accessing }
GtTreePagerSelectionStateRegistryItem >> description [
	^ description
]

{ #category : #accessing }
GtTreePagerSelectionStateRegistryItem >> description: anObject [
	description := anObject
]

{ #category : #accessing }
GtTreePagerSelectionStateRegistryItem >> element [
	^ self stencil
		selectionStateHandler: (selectionStateStencil ifNotNil: #create);
		asElement
]

{ #category : #initialization }
GtTreePagerSelectionStateRegistryItem >> initialize [
	super initialize.

	priority := 50
]

{ #category : #accessing }
GtTreePagerSelectionStateRegistryItem >> name [
	^ name
]

{ #category : #accessing }
GtTreePagerSelectionStateRegistryItem >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtTreePagerSelectionStateRegistryItem >> priority [
	^ priority
]

{ #category : #accessing }
GtTreePagerSelectionStateRegistryItem >> priority: anObject [
	priority := anObject
]

{ #category : #accessing }
GtTreePagerSelectionStateRegistryItem >> selectionState [
	^ selectionStateStencil
]

{ #category : #accessing }
GtTreePagerSelectionStateRegistryItem >> selectionState: aStencil [
	selectionStateStencil := aStencil asStencil
]

{ #category : #accessing }
GtTreePagerSelectionStateRegistryItem >> stencil [
	^ elementStencilBuilder
		ifNil: [ elementStencilBuilder := GtTreePagerSelectionStateRegistryItemStencilBuilder
					new ]
]

{ #category : #accessing }
GtTreePagerSelectionStateRegistryItem >> stencil: aStencil [
	elementStencilBuilder := aStencil asStencilBuilder: GtTreePagerSelectionStateRegistryItemStencilBuilder
]
