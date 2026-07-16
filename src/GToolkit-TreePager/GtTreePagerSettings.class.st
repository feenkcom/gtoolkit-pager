Class {
	#name : #GtTreePagerSettings,
	#superclass : #Object,
	#classVars : [
		'DisplayHideMenuItem',
		'ReplacedLinkRestoration',
		'SelectionStateHandler'
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

{ #category : #settings }
GtTreePagerSettings class >> selectionStateHandler [
	"Return a default selection state handler that is used to create similar copies for individual tree pagers."

	<return: #TGtPhlowToolSelectionStateHandler>
	SelectionStateHandler
		ifNil: [ ^ GtTreePagerPerPaneSelectionStateHandler new ].

	^ SelectionStateHandler similarSelectionStateHandler
]

{ #category : #settings }
GtTreePagerSettings class >> selectionStateHandler: aSelectionStateHandler [
	"Set a default selection state handler that is used to create similar copies for individual tree pagers."

	SelectionStateHandler := aSelectionStateHandler
]

{ #category : #settings }
GtTreePagerSettings class >> selectionStateHandlerRegistryItem [
	"Return a default selection state handler that is used to create similar copies for individual tree pagers."

	<return: #GtTreePagerSelectionStateRegistryItem>
	^ self selectionStateHandler asTreePagerSelectionStateHandlerRegistryItem
]
