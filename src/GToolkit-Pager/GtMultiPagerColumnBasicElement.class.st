Class {
	#name : #GtMultiPagerColumnBasicElement,
	#superclass : #BlElement,
	#traits : 'TGtMultiPagerWithColumnModel + TBrLayoutResizable',
	#classTraits : 'TGtMultiPagerWithColumnModel classTrait + TBrLayoutResizable classTrait',
	#instVars : [
		'columnModel'
	],
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #initialization }
GtMultiPagerColumnBasicElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtMultiPagerColumnBasicElement >> initialize [
	super initialize.
	self matchParent
]
