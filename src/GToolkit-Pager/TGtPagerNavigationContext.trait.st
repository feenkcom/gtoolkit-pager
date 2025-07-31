Trait {
	#name : #TGtPagerNavigationContext,
	#category : #'GToolkit-Pager-Contexts'
}

{ #category : #'api - navigation' }
TGtPagerNavigationContext >> allPreviousContextsDo: aBlock [
	self explicitRequirement
]

{ #category : #'gt - extensions' }
TGtPagerNavigationContext >> gtDepth [
	| aDepth |
	aDepth := 0.
	self withAllNavigationContextsDo: [ aDepth := aDepth + 1 ].
	^ aDepth
]

{ #category : #'gt - extensions' }
TGtPagerNavigationContext >> gtNavigationContextsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Navigations';
		items: [ self withAllNavigationContexts ];
		column: 'Index'
			text: [ :anItem :anIndex | anItem gtDepth ]
			width: 40;
		column: 'Type' text: #toolType weight: 0.5;
		column: 'Tool' text: #toolElement;
		column: 'Object' text: #object
]

{ #category : #'gt - extensions' }
TGtPagerNavigationContext >> gtOverview [
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
TGtPagerNavigationContext >> gtOverviewFor: aView [
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

{ #category : #'api - phlow' }
TGtPagerNavigationContext >> object [
	^ self phlowViewModel ifNotNil: #object
]

{ #category : #'api - phlow' }
TGtPagerNavigationContext >> phlowViewModel [
	<return: #TGtPhlowToolViewModel>
	^ self explicitRequirement
]

{ #category : #'api - navigation' }
TGtPagerNavigationContext >> previousContextSuchThat: aConditionBlock do: aDoBlock ifAbsent: anAbsentBlock [
	self allPreviousContextsDo: [ :aContext | 
		(aConditionBlock cull: aContext cull: aContext phlowViewModel)
			ifTrue: [ ^ aDoBlock cull: aContext cull: aContext phlowViewModel ] ].

	^ anAbsentBlock value
]

{ #category : #'api - navigation' }
TGtPagerNavigationContext >> previousObjectSuchThat: aConditionBlock do: aDoBlock ifAbsent: anAbsentBlock [
	self allPreviousContextsDo: [ :aContext | 
		(aConditionBlock cull: aContext object cull: aContext)
			ifTrue: [ ^ aDoBlock cull: aContext object cull: aContext ] ].

	^ anAbsentBlock value
]

{ #category : #'api - navigation' }
TGtPagerNavigationContext >> previousProcessContextSuchThat: aConditionBlock do: aDoBlock ifAbsent: anAbsentBlock [
	"Find debugger context or exception suspended context"
	
	| aProcessContextBlock |
	aProcessContextBlock := [ :anObject | 
		| aProcessContext |
		aProcessContext := nil.
		(anObject isKindOf: DebugSession) ifTrue: [ aProcessContext := anObject context ].
		((anObject isKindOf: Exception) and: [ anObject signalContext isNotNil ]) 
			ifTrue: [ aProcessContext := anObject signalContext ].
		(anObject isKindOf: Context) ifTrue: [ aProcessContext := anObject ].
		aProcessContext ].
	
	^ self 
		previousObjectSuchThat: [ :anObject :aNavigationContext |
			| aProcessContext |
			aProcessContext := aProcessContextBlock value: anObject.
			aProcessContext isNotNil and: [
				aConditionBlock cull: aProcessContext cull: aNavigationContext cull: anObject ] ] 
		do: [ :anObject :aNavigationContext |
			| aProcessContext |
			aProcessContext := aProcessContextBlock value: anObject.
			aDoBlock cull: aProcessContext cull: aNavigationContext cull: anObject ] 
		ifAbsent: anAbsentBlock.
]

{ #category : #'api - phlow' }
TGtPagerNavigationContext >> toolElement [
	^ self phlowViewModel ifNotNil: #element
]

{ #category : #'api - phlow' }
TGtPagerNavigationContext >> toolType [
	^ self phlowViewModel ifNotNil: #type
]

{ #category : #'api - phlow' }
TGtPagerNavigationContext >> toolViewModel [
	^ self phlowViewModel ifNotNil: #viewModel
]

{ #category : #'api - navigation' }
TGtPagerNavigationContext >> withAllNavigationContexts [
	^ Array streamContents: [ :aStream | 
		self withAllNavigationContextsDo: [ :eachContext | 
			aStream nextPut: eachContext ] ]
]

{ #category : #'api - navigation' }
TGtPagerNavigationContext >> withAllNavigationContextsDo: aBlock [
	aBlock cull: self.
	self allPreviousContextsDo: aBlock
]
