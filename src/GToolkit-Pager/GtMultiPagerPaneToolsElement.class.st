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
	someToolElements := self paneModel toolModels
			collect: [ :eachToolModel | 
				GtMultiPagerToolElement new
					toolModel: eachToolModel;
					margin: (BlInsets all: 10);
					addAptitude: BrGlamorousFocusableShadowAptitude new ].
	self removeChildren.
	self addChildren: someToolElements
]
