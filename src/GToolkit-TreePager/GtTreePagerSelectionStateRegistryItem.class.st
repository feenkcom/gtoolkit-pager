Class {
	#name : #GtTreePagerSelectionStateRegistryItem,
	#superclass : #Object,
	#instVars : [
		'priority',
		'name',
		'description',
		'selectionStateStencil',
		'elementStencil'
	],
	#category : #'GToolkit-TreePager-Settings'
}

{ #category : #accessing }
GtTreePagerSelectionStateRegistryItem >> description [
	^ description
]

{ #category : #accessing }
GtTreePagerSelectionStateRegistryItem >> description: anObject [
	description := anObject
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
	^ elementStencil
]

{ #category : #accessing }
GtTreePagerSelectionStateRegistryItem >> stencil: aStencil [
	elementStencil := aStencil asStencil
]
