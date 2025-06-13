Class {
	#name : #GtTreePagerToolBuilder,
	#superclass : #Object,
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #converting }
GtTreePagerToolBuilder >> asElement [
	<return: #BlElement>
	^ self subclassResponsibility
]

{ #category : #views }
GtTreePagerToolBuilder >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 10;
		stencil: [ self asElement ]
]

{ #category : #converting }
GtTreePagerToolBuilder >> icon [
	<return: #BrStencil or: nil>
	^ nil
]

{ #category : #converting }
GtTreePagerToolBuilder >> title [
	<return: #String>
	^ self subclassResponsibility
]
