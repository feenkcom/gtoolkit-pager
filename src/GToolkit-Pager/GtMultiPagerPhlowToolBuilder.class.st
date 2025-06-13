Class {
	#name : #GtMultiPagerPhlowToolBuilder,
	#superclass : #GtMultiPagerToolBuilder,
	#instVars : [
		'phlowTool'
	],
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #converting }
GtMultiPagerPhlowToolBuilder >> asElement [
	^ self phlowTool asElement
]

{ #category : #converting }
GtMultiPagerPhlowToolBuilder >> icon [
	<return: #BrStencil or: nil>
	^ self phlowTool icon
]

{ #category : #convenience }
GtMultiPagerPhlowToolBuilder >> object: anObject [
	self phlowTool: anObject gtDefaultInspectorTool
]

{ #category : #accessing }
GtMultiPagerPhlowToolBuilder >> phlowTool [
	<return: #GtPhlowTool>
	^ phlowTool
]

{ #category : #accessing }
GtMultiPagerPhlowToolBuilder >> phlowTool: aGtPhlowTool [
	phlowTool := aGtPhlowTool
]

{ #category : #converting }
GtMultiPagerPhlowToolBuilder >> title [
	<return: #String>
	^ self phlowTool object gtDisplayString
]
