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
		'afterPage',
		'navigationContext'
	],
	#category : #'GToolkit-Pager-Contexts'
}

{ #category : #factory }
GtPagerPageSelectionContext class >> null [
	^ GtPagerPageNullSelectionContext default
]

{ #category : #accessing }
GtPagerPageSelectionContext >> afterPage [
	<return: #GtPagerWrapperElement>
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

	self tool context: self phlowContext.
	self tool
		asToolElementDo: [ :anElement | 
			| aWrapper |
			aWrapper := GtPagerWrapperElement forElement: anElement.
			aWrapper navigationContext: self navigationContext.
			aOneArgBlock cull: aWrapper ]
]

{ #category : #'api - initialization' }
GtPagerPageSelectionContext >> createNavigationContextWithPager: aGtPager [
	| aPreviousContext aFollowingContext |
	aPreviousContext := self afterPage navigationContext.
	aFollowingContext := GtPagerPageNavigationContext new.
	aFollowingContext previousContext: aPreviousContext.
	aFollowingContext pager: aGtPager.
	aFollowingContext object: self object.
	self navigationContext: aFollowingContext
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

{ #category : #'api - initialization' }
GtPagerPageSelectionContext >> navigationContext [
	<return: #GtPagerPageNavigationContext>
	^ navigationContext
]

{ #category : #accessing }
GtPagerPageSelectionContext >> navigationContext: anObject [
	navigationContext := anObject
]

{ #category : #accessing }
GtPagerPageSelectionContext >> phlowContext [
	<return: #GtPhlowContext>
	^ GtPhlowContext new 
		navigationContext: self navigationContext
]

{ #category : #accessing }
GtPagerPageSelectionContext >> prepareForReusedNavigation [
	self tool ifNotNil: [ :aTool |
		aTool prepareForReusedNavigation ]
]

{ #category : #'as yet unclassified' }
GtPagerPageSelectionContext >> toolElement [
	<return: #BlElement>
	^ self afterPage tool
]
