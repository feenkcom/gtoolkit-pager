Class {
	#name : #GtMultiPagerToolModelExpansionChanged,
	#superclass : #GtMultiPagerToolModelAnnouncement,
	#instVars : [
		'isCollapsed'
	],
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #accessing }
GtMultiPagerToolModelExpansionChanged >> isCollapsed [
	^ isCollapsed
]

{ #category : #accessing }
GtMultiPagerToolModelExpansionChanged >> isCollapsed: anObject [
	isCollapsed := anObject
]
