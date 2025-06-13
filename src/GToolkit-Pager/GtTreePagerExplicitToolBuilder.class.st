Class {
	#name : #GtTreePagerExplicitToolBuilder,
	#superclass : #GtTreePagerToolBuilder,
	#instVars : [
		'stencil',
		'icon',
		'title'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #converting }
GtTreePagerExplicitToolBuilder >> asElement [
	<return: #BlElement>
	^ self stencil asElement
]

{ #category : #views }
GtTreePagerExplicitToolBuilder >> gtStencilSourceCodeFor: aView [
	<gtView>
	stencil ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Source code';
		object: [ stencil ];
		view: #gtSourceCodeFor:
]

{ #category : #accessing }
GtTreePagerExplicitToolBuilder >> icon [
	<return: #BrStencil or: nil>
	^ icon
]

{ #category : #accessing }
GtTreePagerExplicitToolBuilder >> icon: anObject [
	icon := anObject
]

{ #category : #accessing }
GtTreePagerExplicitToolBuilder >> stencil [
	^ stencil
]

{ #category : #accessing }
GtTreePagerExplicitToolBuilder >> stencil: aStencil [
	stencil := aStencil asStencil
]

{ #category : #accessing }
GtTreePagerExplicitToolBuilder >> title [
	<return: #String>
	^ title ifNil: [ title := self stencil gtDisplayString ]
]

{ #category : #accessing }
GtTreePagerExplicitToolBuilder >> title: anObject [
	title := anObject
]
