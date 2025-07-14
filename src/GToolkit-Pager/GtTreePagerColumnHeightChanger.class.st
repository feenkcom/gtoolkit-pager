Class {
	#name : #GtTreePagerColumnHeightChanger,
	#superclass : #Object,
	#traits : 'TBlHorizontalTreeFlowLayoutRowCountVisitor',
	#classTraits : 'TBlHorizontalTreeFlowLayoutRowCountVisitor classTrait',
	#instVars : [
		'settings'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #updating }
GtTreePagerColumnHeightChanger >> change [
	self visitLayoutRowCount: self settings columnHeight
]

{ #category : #accessing }
GtTreePagerColumnHeightChanger >> settings [
	^ settings
]

{ #category : #accessing }
GtTreePagerColumnHeightChanger >> settings: anObject [
	settings := anObject
]

{ #category : #visiting }
GtTreePagerColumnHeightChanger >> visitBlHorizontalTreeFlowLayoutCellCount: aCount [
	self settings fillRowHeight
]

{ #category : #visiting }
GtTreePagerColumnHeightChanger >> visitBlHorizontalTreeFlowLayoutRowGrowingCount: aCount [
	self settings fillEntireColumnHeight
]
