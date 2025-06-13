Class {
	#name : #GtMultiPagerPaneToolsElement,
	#superclass : #GtMultiPagerPaneBasicElement,
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #initialization }
GtMultiPagerPaneToolsElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #'api - pane model' }
GtMultiPagerPaneToolsElement >> onPaneModelChanged [
	| someToolElements |
	someToolElements := self paneModel toolModels collect: #asElement.
	self removeChildren.
	self addChildren: someToolElements
]
