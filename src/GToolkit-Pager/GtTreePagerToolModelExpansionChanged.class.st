Class {
	#name : #GtTreePagerToolModelExpansionChanged,
	#superclass : #GtTreePagerToolModelAnnouncement,
	#instVars : [
		'isCollapsed'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #accessing }
GtTreePagerToolModelExpansionChanged >> isCollapsed [
	^ isCollapsed
]

{ #category : #accessing }
GtTreePagerToolModelExpansionChanged >> isCollapsed: anObject [
	isCollapsed := anObject
]
