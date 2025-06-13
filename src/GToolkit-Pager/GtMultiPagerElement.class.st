Class {
	#name : #GtMultiPagerElement,
	#superclass : #GtMultiPagerBasicElement,
	#instVars : [
		'panesElement'
	],
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #initialization }
GtMultiPagerElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #initialization }
GtMultiPagerElement >> initialize [
	super initialize.
	self matchParent.

	panesElement := GtMultiPagerPanesElement new matchParent.
	self addChild: panesElement
]

{ #category : #'api - pager model' }
GtMultiPagerElement >> onPagerModelChanged [
	super onPagerModelChanged.

	panesElement pagerModel: self pagerModel
]
