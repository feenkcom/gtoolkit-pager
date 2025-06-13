Class {
	#name : #GtMultiPagerExplicitToolBuilder,
	#superclass : #GtMultiPagerToolBuilder,
	#instVars : [
		'stencil',
		'icon',
		'title'
	],
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #converting }
GtMultiPagerExplicitToolBuilder >> asElement [
	<return: #BlElement>
	^ self stencil asElement
]

{ #category : #views }
GtMultiPagerExplicitToolBuilder >> gtStencilSourceCodeFor: aView [
	<gtView>
	stencil ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Source code';
		object: [ stencil ];
		view: #gtSourceCodeFor:
]

{ #category : #accessing }
GtMultiPagerExplicitToolBuilder >> icon [
	<return: #BrStencil or: nil>
	^ icon
]

{ #category : #accessing }
GtMultiPagerExplicitToolBuilder >> icon: anObject [
	icon := anObject
]

{ #category : #accessing }
GtMultiPagerExplicitToolBuilder >> stencil [
	^ stencil
]

{ #category : #accessing }
GtMultiPagerExplicitToolBuilder >> stencil: aStencil [
	stencil := aStencil asStencil
]

{ #category : #accessing }
GtMultiPagerExplicitToolBuilder >> title [
	<return: #String>
	^ title ifNil: [ title := self stencil gtDisplayString ]
]

{ #category : #accessing }
GtMultiPagerExplicitToolBuilder >> title: anObject [
	title := anObject
]
