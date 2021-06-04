"
I keep information that is passed to {{gtClass:GtPager}} when there are {{gtMethod:GtPager>>#select:}} and {{gtMethod:GtPager>>#spawn:}} requests.
I am created by {{gtClass:GtPagerPageEmbellisher}}.


"
Class {
	#name : #GtPagerPageSelectionContext,
	#superclass : #GtPagerPageAbstractSelectionContext,
	#traits : 'TGtPhlowToolAccessors',
	#classTraits : 'TGtPhlowToolAccessors classTrait',
	#instVars : [
		'afterPage'
	],
	#category : #'GToolkit-Pager-Contexts'
}

{ #category : #factory }
GtPagerPageSelectionContext class >> null [
	^ GtPagerPageNullSelectionContext default
]

{ #category : #accessing }
GtPagerPageSelectionContext >> afterPage [
	<return: #BlElement>
	^ afterPage
]

{ #category : #accessing }
GtPagerPageSelectionContext >> afterPage: anElement [
	self 
		assert: [ anElement isNotNil ] 
		description: [ 'Page element must be non-nil' ].
	afterPage := anElement
]

{ #category : #converting }
GtPagerPageSelectionContext >> asElementDo: aOneArgBlock [
	"Create a tool element and execute the block"
	self tool asElementDo: [ :anElement | 
		aOneArgBlock cull: (GtPagerWrapperElement forElement: anElement) ]		
]

{ #category : #enumerating }
GtPagerPageSelectionContext >> ifDefinedDo: aBlock [
	aBlock value
]

{ #category : #initialization }
GtPagerPageSelectionContext >> initialize [
	super initialize.
	self initializeTool.
]
