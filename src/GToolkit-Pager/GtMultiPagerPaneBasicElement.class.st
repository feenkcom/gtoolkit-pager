Class {
	#name : #GtMultiPagerPaneBasicElement,
	#superclass : #BlElement,
	#traits : 'TGtMultiPagerWithPaneModel + TBrLayoutResizable',
	#classTraits : 'TGtMultiPagerWithPaneModel classTrait + TBrLayoutResizable classTrait',
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #initialization }
GtMultiPagerPaneBasicElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtMultiPagerPaneBasicElement >> initialize [
	super initialize.
	self matchParent
]
