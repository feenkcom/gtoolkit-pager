Class {
	#name : #GtTreePagerSelectionStateRegistryItemBasicElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
	#instVars : [
		'registryItem'
	],
	#category : #'GToolkit-TreePager-UI'
}

{ #category : #testing }
GtTreePagerSelectionStateRegistryItemBasicElement >> hasRegistryItem [
	^ registryItem isNotNil
]

{ #category : #accessing }
GtTreePagerSelectionStateRegistryItemBasicElement >> registryItem [
	^ registryItem
]

{ #category : #accessing }
GtTreePagerSelectionStateRegistryItemBasicElement >> registryItem: aRegistryItem [
	registryItem == aRegistryItem ifTrue: [ ^ self ].
	registryItem := aRegistryItem.
	self updateElement
]

{ #category : #private }
GtTreePagerSelectionStateRegistryItemBasicElement >> registryItemDo: aBlock [
	^ registryItem ifNotNil: aBlock
]
