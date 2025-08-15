Class {
	#name : #GtTreePagerSettings,
	#superclass : #Object,
	#classVars : [
		'DisplayHideMenuItem'
	],
	#category : #'GToolkit-TreePager-Settings'
}

{ #category : #settings }
GtTreePagerSettings class >> displayHideMenuItem [
	DisplayHideMenuItem := true
]

{ #category : #settings }
GtTreePagerSettings class >> hideHideMenuItem [
	DisplayHideMenuItem := false
]

{ #category : #settings }
GtTreePagerSettings class >> isDisplayHideMenuItem [
	^ DisplayHideMenuItem ifNil: [ DisplayHideMenuItem := false ]
]
