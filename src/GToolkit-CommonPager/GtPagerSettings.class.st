Class {
	#name : #GtPagerSettings,
	#superclass : #Object,
	#classInstVars : [
		'usedPager'
	],
	#category : #'GToolkit-CommonPager-! Core'
}

{ #category : #settings }
GtPagerSettings class >> usedPager [
	^ usedPager ifNil: [ GtPager ]
]

{ #category : #settings }
GtPagerSettings class >> usedPager: anObject [
	usedPager := anObject
]
