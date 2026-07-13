Class {
	#name : #GtTreePagerSelectionStateRegistryExamples,
	#superclass : #Object,
	#category : #'GToolkit-TreePager-Examples'
}

{ #category : #examples }
GtTreePagerSelectionStateRegistryExamples >> registryItems [
	<gtExample>
	<return: #Array>
	| items |
	items := GtTreePagerSelectionStateRegistry new items.
	self
		assert: (items
				allSatisfy: [ :each | each isKindOf: GtTreePagerSelectionStateRegistryItem ]).
	self assert: (items collect: #name) asSet size equals: items size.
	^ items
]
