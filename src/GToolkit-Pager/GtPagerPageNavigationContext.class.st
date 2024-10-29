Class {
	#name : #GtPagerPageNavigationContext,
	#superclass : #Object,
	#instVars : [
		'pageSelectionContext',
		'pagerPageModel',
		'previousContext',
		'pager',
		'object'
	],
	#category : #'GToolkit-Pager-Contexts'
}

{ #category : #'api - navigation' }
GtPagerPageNavigationContext >> allPreviousContextsDo: aBlock [
	self previousContext ifNotNil: [ :aContext | 
		aContext withAllNavigationContextsDo: aBlock ]
]

{ #category : #accessing }
GtPagerPageNavigationContext >> object [
	^ object
]

{ #category : #accessing }
GtPagerPageNavigationContext >> object: anObject [
	object := anObject
]

{ #category : #accessing }
GtPagerPageNavigationContext >> pager [
	<return: #GtPager>
	^ pager
]

{ #category : #accessing }
GtPagerPageNavigationContext >> pager: aGtPager [
	pager := aGtPager
]

{ #category : #accessing }
GtPagerPageNavigationContext >> pagerPageModel [
	<return: #GtPagerPageModel>
	^ pagerPageModel
]

{ #category : #accessing }
GtPagerPageNavigationContext >> pagerPageModel: anObject [
	pagerPageModel := anObject
]

{ #category : #accessing }
GtPagerPageNavigationContext >> previousContext [
	<return: #GtPagerPageNavigationContext or: nil>
	^ previousContext
]

{ #category : #accessing }
GtPagerPageNavigationContext >> previousContext: anObject [
	previousContext := anObject
]

{ #category : #'api - accessing' }
GtPagerPageNavigationContext >> previousObjectDo: aDoBlock ifAbsent: anAbsentBlock [
	self allPreviousContextsDo: [ :aContext | 
		^ aDoBlock cull: aContext object cull: aContext ].

	^ anAbsentBlock value
]

{ #category : #'api - navigation' }
GtPagerPageNavigationContext >> withAllNavigationContexts [
	^ Array streamContents: [ :aStream | 
		self withAllNavigationContextsDo: [ :eachContext | 
			aStream nextPut: eachContext ] ]
]

{ #category : #'api - navigation' }
GtPagerPageNavigationContext >> withAllNavigationContextsDo: aBlock [
	aBlock cull: self.
	self allPreviousContextsDo: aBlock
]
