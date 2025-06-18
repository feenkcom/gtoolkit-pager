Class {
	#name : #GtTreePagerPaneModelExpansionChanged,
	#superclass : #GtTreePagerPaneModelAnnouncement,
	#instVars : [
		'isCollapsed'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #accessing }
GtTreePagerPaneModelExpansionChanged >> isCollapsed [
	^ isCollapsed
]

{ #category : #accessing }
GtTreePagerPaneModelExpansionChanged >> isCollapsed: anObject [
	isCollapsed := anObject
]
