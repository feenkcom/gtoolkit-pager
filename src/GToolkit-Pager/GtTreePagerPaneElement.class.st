Class {
	#name : #GtTreePagerPaneElement,
	#superclass : #GtTreePagerPaneBasicElement,
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #initialization }
GtTreePagerPaneElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtTreePagerPaneElement >> initialize [
	super initialize.
	self background: self theme default contentBackground.
	self matchParent
]

{ #category : #accessing }
GtTreePagerPaneElement >> onPaneModelChanged [
	self removeChildren.
	self addChild: self paneModel asElement as: #tool
]
