Class {
	#name : #GtTreePagerColumnToolsElement,
	#superclass : #GtTreePagerColumnBasicElement,
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #initialization }
GtTreePagerColumnToolsElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #'api - pane model' }
GtTreePagerColumnToolsElement >> onColumnModelChanged [
	| somePaneElements |
	somePaneElements := self paneModel paneModels
			collect: [ :eachPaneModel | 
				GtTreePagerPaneElement new
					paneModel: eachPaneModel;
					margin: (BlInsets all: 10);
					addAptitude: BrGlamorousFocusableShadowAptitude new ].
	self removeChildren.
	self addChildren: somePaneElements
]
