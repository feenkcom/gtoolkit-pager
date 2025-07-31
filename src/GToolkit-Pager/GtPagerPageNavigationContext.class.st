Class {
	#name : #GtPagerPageNavigationContext,
	#superclass : #Object,
	#traits : 'TGtPagerNavigationContext',
	#classTraits : 'TGtPagerNavigationContext classTrait',
	#instVars : [
		'pagerPageModel',
		'previousContext',
		'pager'
	],
	#category : #'GToolkit-Pager-Contexts'
}

{ #category : #'api - navigation' }
GtPagerPageNavigationContext >> allPreviousContextsDo: aBlock [
	self previousContext ifNotNil: [ :aContext | 
		aContext withAllNavigationContextsDo: aBlock ]
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
GtPagerPageNavigationContext >> phlowViewModel [
	<return: #TGtPhlowToolViewModel>
	self pagerPageModel widgetDo: [ :aWidget | 
		^ aWidget toolViewModel ].
	^ nil
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
