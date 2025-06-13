Class {
	#name : #GtTreePagerColumnBasicElement,
	#superclass : #BlElement,
	#traits : 'TGtTreePagerWithColumnModel + TBrLayoutResizable',
	#classTraits : 'TGtTreePagerWithColumnModel classTrait + TBrLayoutResizable classTrait',
	#instVars : [
		'columnModel'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #initialization }
GtTreePagerColumnBasicElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtTreePagerColumnBasicElement >> initialize [
	super initialize.
	self matchParent
]
