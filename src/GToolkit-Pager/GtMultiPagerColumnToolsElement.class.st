Class {
	#name : #GtMultiPagerColumnToolsElement,
	#superclass : #GtMultiPagerColumnBasicElement,
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #initialization }
GtMultiPagerColumnToolsElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #'api - pane model' }
GtMultiPagerColumnToolsElement >> onColumnModelChanged [
	| somePaneElements |
	somePaneElements := self paneModel paneModels
			collect: [ :eachToolModel | 
				GtMultiPagerPaneElement new
					toolModel: eachToolModel;
					margin: (BlInsets all: 10);
					addAptitude: BrGlamorousFocusableShadowAptitude new ].
	self removeChildren.
	self addChildren: somePaneElements
]
