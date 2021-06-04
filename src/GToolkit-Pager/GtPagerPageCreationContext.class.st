"
I keep common elements that are accessed (and modified) during a ${class:name=GtPagerPageModel}$ widget creation.
I am used by ${class:GtPagerPageEmbellisher}$ as an internal object that is passed among methods.!

"
Class {
	#name : #GtPagerPageCreationContext,
	#superclass : #Object,
	#traits : 'TBlDebug + TGtContentElementAccessors',
	#classTraits : 'TBlDebug classTrait + TGtContentElementAccessors classTrait',
	#instVars : [
		'embellisher',
		'pageElement',
		'wrapperElement'
	],
	#category : #'GToolkit-Pager-Contexts'
}

{ #category : #accessing }
GtPagerPageCreationContext >> embellisher [
	<return: #GtPagerPageEmbellisher>
	^ embellisher
]

{ #category : #accessing }
GtPagerPageCreationContext >> embellisher: aGtPagerPageEmbellisher [
	self 
		assert: [ aGtPagerPageEmbellisher isNotNil ] 
		description: [ 'Embellisher must be non-nil' ].
	embellisher := aGtPagerPageEmbellisher
]

{ #category : #requests }
GtPagerPageCreationContext >> maximizePageContentInPager: aGtPager [
	"maximize a page"
	aGtPager maximizePageContentIn: self contentElement
]

{ #category : #accessing }
GtPagerPageCreationContext >> pageElement [
	^ pageElement
]

{ #category : #accessing }
GtPagerPageCreationContext >> pageElement: anElement [
	self assertElement: anElement.
	pageElement := anElement.
]

{ #category : #accessing }
GtPagerPageCreationContext >> wrapperElement [
	^ wrapperElement
]

{ #category : #accessing }
GtPagerPageCreationContext >> wrapperElement: anElement [
	self assertElement: anElement.
	wrapperElement := anElement
]
