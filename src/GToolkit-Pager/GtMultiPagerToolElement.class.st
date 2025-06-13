Class {
	#name : #GtMultiPagerToolElement,
	#superclass : #GtMultiPagerToolBasicElement,
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #initialization }
GtMultiPagerToolElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtMultiPagerToolElement >> initialize [
	super initialize.

	self matchParent
]

{ #category : #accessing }
GtMultiPagerToolElement >> onToolModelChanged [
	self removeChildren.
	self addChild: self toolModel asElement as: #tool
]
