Class {
	#name : #GtTreePagerSelectionStateRegistryItemElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-TreePager-Examples'
}

{ #category : #examples }
GtTreePagerSelectionStateRegistryItemElementExamples >> element [
	<gtExample>
	<return: #GtTreePagerSelectionStateRegistryItemElement>
	| anItem anElement aNameLabel aStencilElement aScripter |
	anItem := self registryItem.
	anElement := GtTreePagerSelectionStateRegistryItemElement new
			registryItem: anItem.

	self assert: anElement registryItem equals: anItem.
	self assert: anElement hasRegistryItem.
	self assert: anElement children size equals: 2.

	aNameLabel := anElement
			childWithId: #'tree-pager--selection-state-registry-item-name'.
	self assert: aNameLabel text asString equals: 'Pane circular selection'.

	aStencilElement := anElement
			childWithId: #'tree-pager--selection-state-registry-item-stencil'.
	self assert: aStencilElement notNil.
	self
		assert: aStencilElement class
		equals: GtTreePagerToolCircularSelectionStateHandlerElement.

	aScripter := BlScripter new
			model: anItem;
			element: anElement.

	^ aScripter
]

{ #category : #examples }
GtTreePagerSelectionStateRegistryItemElementExamples >> nameElement [
	<gtExample>
	<return: #GtTreePagerSelectionStateRegistryItemNameElement>
	| anItem anElement aNameLabel aScripter |
	anItem := self registryItem.
	anElement := GtTreePagerSelectionStateRegistryItemNameElement new
			registryItem: anItem.

	self assert: anElement registryItem equals: anItem.
	self assert: anElement hasRegistryItem.
	self assert: anElement children size equals: 1.

	aNameLabel := anElement
			childWithId: #'tree-pager--selection-state-registry-item-name'.
	self assert: aNameLabel text asString equals: 'Pane circular selection'.

	aScripter := BlScripter new
			model: anItem;
			element: anElement.

	^ aScripter
]

{ #category : #examples }
GtTreePagerSelectionStateRegistryItemElementExamples >> registryItem [
	<gtExample>
	<return: #GtTreePagerSelectionStateRegistryItem>
	^ GtTreePagerSelectionStateRegistry new perPaneCircular
]
