Class {
	#name : #GtMultiPagerPaneElement,
	#superclass : #GtMultiPagerPaneBasicElement,
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #initialization }
GtMultiPagerPaneElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtMultiPagerPaneElement >> initialize [
	super initialize.
	self background: self theme default contentBackground.
	self matchParent
]

{ #category : #accessing }
GtMultiPagerPaneElement >> onToolModelChanged [
	self removeChildren.
	self addChild: self toolModel asElement as: #tool
]
