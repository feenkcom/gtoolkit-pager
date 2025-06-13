Class {
	#name : #GtTreePagerPhlowToolBuilder,
	#superclass : #GtTreePagerToolBuilder,
	#instVars : [
		'phlowTool'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #converting }
GtTreePagerPhlowToolBuilder >> asElement [
	^ self phlowTool asElement
]

{ #category : #converting }
GtTreePagerPhlowToolBuilder >> icon [
	<return: #BrStencil or: nil>
	^ self phlowTool icon
]

{ #category : #convenience }
GtTreePagerPhlowToolBuilder >> object: anObject [
	self phlowTool: anObject gtDefaultInspectorTool
]

{ #category : #accessing }
GtTreePagerPhlowToolBuilder >> phlowTool [
	<return: #GtPhlowTool>
	^ phlowTool
]

{ #category : #accessing }
GtTreePagerPhlowToolBuilder >> phlowTool: aGtPhlowTool [
	phlowTool := aGtPhlowTool
]

{ #category : #converting }
GtTreePagerPhlowToolBuilder >> title [
	<return: #String>
	^ self phlowTool object gtDisplayString
]
