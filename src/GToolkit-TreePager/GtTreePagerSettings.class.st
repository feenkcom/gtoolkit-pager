Class {
	#name : #GtTreePagerSettings,
	#superclass : #Object,
	#classVars : [
		'DisplayHideMenuItem',
		'ReplacedLinkRestoration'
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

{ #category : #settings }
GtTreePagerSettings class >> replacedLinkRestoration [
	"The time for which a replaced link remains accessible to a user for its restoration"

	<return: #Duration>
	^ ReplacedLinkRestoration ifNil: [ GtTreePagerConstants replacedLinkRestoration ]
]

{ #category : #settings }
GtTreePagerSettings class >> replacedLinkRestoration: aDuration [
	"Set the time for which a replaced link remains accessible to a user for its restoration"

	ReplacedLinkRestoration := aDuration
]
