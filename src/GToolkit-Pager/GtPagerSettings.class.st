Class {
	#name : #GtPagerSettings,
	#superclass : #Object,
	#classInstVars : [
		'usedPager'
	],
	#category : #'GToolkit-Pager-! Core'
}

{ #category : #settings }
GtPagerSettings class >> useLinearPager [
	self usedPager: GtPager
]

{ #category : #settings }
GtPagerSettings class >> useTreePager [
	self usedPager: GtTreePager
]

{ #category : #settings }
GtPagerSettings class >> usedPager [
	^ usedPager ifNil: [ GtPager ]
]

{ #category : #settings }
GtPagerSettings class >> usedPager: anObject [
	usedPager := anObject
]
