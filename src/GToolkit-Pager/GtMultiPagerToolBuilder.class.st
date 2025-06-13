Class {
	#name : #GtMultiPagerToolBuilder,
	#superclass : #Object,
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #converting }
GtMultiPagerToolBuilder >> asElement [
	<return: #BlElement>
	^ self subclassResponsibility
]

{ #category : #views }
GtMultiPagerToolBuilder >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 10;
		stencil: [ self asElement ]
]

{ #category : #converting }
GtMultiPagerToolBuilder >> icon [
	<return: #BrStencil or: nil>
	^ nil
]

{ #category : #converting }
GtMultiPagerToolBuilder >> title [
	<return: #String>
	^ self subclassResponsibility
]
