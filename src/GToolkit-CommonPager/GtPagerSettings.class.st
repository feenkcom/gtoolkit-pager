Class {
	#name : #GtPagerSettings,
	#superclass : #Object,
	#classInstVars : [
		'usedPager',
		'isAllowedForDebugTools'
	],
	#category : #'GToolkit-CommonPager-! Core'
}

{ #category : #settings }
GtPagerSettings class >> disableForDebugTools [
	isAllowedForDebugTools := false
]

{ #category : #settings }
GtPagerSettings class >> enableForDebugTools [
	isAllowedForDebugTools := true
]

{ #category : #settings }
GtPagerSettings class >> isAllowedForDebugTools [
	"True return value means that `GtPagerSettings class>>#usedPager`
	can be used to open debug tools, e.g., debugger and driller.
	False return value means that `GtPager` should me used."

	^ isAllowedForDebugTools ifNil: [ true ]
]

{ #category : #settings }
GtPagerSettings class >> usedPager [
	^ usedPager ifNil: [ GtPager ]
]

{ #category : #settings }
GtPagerSettings class >> usedPager: anObject [
	usedPager := anObject
]
