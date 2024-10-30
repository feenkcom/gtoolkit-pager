Class {
	#name : #GtPagerPageNavigationContext,
	#superclass : #Object,
	#instVars : [
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

{ #category : #'gt - extensions' }
GtPagerPageNavigationContext >> gtNavigationContextsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Navigations';
		items: [ self withAllNavigationContexts ];
		column: 'Index'
			text: [ :_ :anIndex | anIndex ]
			width: 40;
		column: 'Type' text: #toolType weight: 0.5;
		column: 'Tool' text: #toolElement;
		column: 'Object' text: #object
]

{ #category : #'gt - extensions' }
GtPagerPageNavigationContext >> gtOverview [
	^ {
		GtPhlowOverviewItem new
			name: 'Phlow view model';
			value: self phlowViewModel.
		GtPhlowOverviewItem new
			name: 'Tool type';
			value: self toolType.
		GtPhlowOverviewItem new
			name: 'Tool element';
			value: self toolElement.
		GtPhlowOverviewItem new
			name: 'Tool view model';
			value: self toolViewModel.
		GtPhlowOverviewItem new
			name: 'Tool model object';
			value: self object}
]

{ #category : #'gt - extensions' }
GtPagerPageNavigationContext >> gtOverviewFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Overview';
		priority: 0;
		items: [ self gtOverview ];
		column: 'Name'
			text: #name
			weight: 0.3;
		column: 'Value' text: #description;
		send: #value
]

{ #category : #accessing }
GtPagerPageNavigationContext >> object [
	^ self phlowViewModel ifNotNil: #object
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

{ #category : #'api - accessing' }
GtPagerPageNavigationContext >> previousObjectDo: aDoBlock ifAbsent: anAbsentBlock [
	self allPreviousContextsDo: [ :aContext | 
		^ aDoBlock cull: aContext object cull: aContext ].

	^ anAbsentBlock value
]

{ #category : #accessing }
GtPagerPageNavigationContext >> toolElement [
	^ self phlowViewModel ifNotNil: #element
]

{ #category : #accessing }
GtPagerPageNavigationContext >> toolType [
	^ self phlowViewModel ifNotNil: #type
]

{ #category : #accessing }
GtPagerPageNavigationContext >> toolViewModel [
	^ self phlowViewModel ifNotNil: #viewModel
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
