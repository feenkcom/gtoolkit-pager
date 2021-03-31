Class {
	#name : #GtPagerPageEmbellisher,
	#superclass : #BrPagerPageEmbellisher,
	#traits : 'TGtPagerSelectionContextAccessor + TGtPagerHolderAccessors',
	#classTraits : 'TGtPagerSelectionContextAccessor classTrait + TGtPagerHolderAccessors classTrait',
	#instVars : [
		'pageWidth',
		'extension'
	],
	#category : #'GToolkit-Pager-Stencils and Builders'
}

{ #category : #'api - configuration' }
GtPagerPageEmbellisher >> beExact: aNumber [
	self pageWidth: (GtPagerPageWidth exact: aNumber)
]

{ #category : #'api - configuration' }
GtPagerPageEmbellisher >> beExact: aNumber page: aPageElement [
	aPageElement width: aNumber.
	self beExact: aNumber.
]

{ #category : #'api - configuration' }
GtPagerPageEmbellisher >> beMatching: aNumber [
	self pageWidth: (GtPagerPageWidth weight: aNumber)
]

{ #category : #'api - configuration' }
GtPagerPageEmbellisher >> beMatching: aNumber page: aPageElement [
	aPageElement weight: aNumber.
	aPageElement constraintsDo: [ :c | c horizontal matchParent ].
	self beMatching: aNumber.
]

{ #category : #'api - instantiation' }
GtPagerPageEmbellisher >> create [
	<return: #BlElement>
	| aCreationContext |
	aCreationContext := self newCreationContext
		embellisher: self;
		pageElement: self newPageElement;
		wrapperElement: self newPageContentWrapper;
		contentElement: self contentElement.
	self fillContentWrapperIn: aCreationContext.
	self fillPageElementIn: aCreationContext.
	self fillWithExtensionIn: aCreationContext.
	^ aCreationContext pageElement
]

{ #category : #'widget configuration' }
GtPagerPageEmbellisher >> createMaximizeButtonIn: aCreationContext [
	^ self newMaximizeButton
		action: [ self pagerHolder maximizeIn: aCreationContext ]
]

{ #category : #'widget configuration' }
GtPagerPageEmbellisher >> createNextPageButtonOnContentWrapper: aContentWrapper [
	| aTriangleElement |
	aTriangleElement := self newNextPageButton.
	aContentWrapper
		when: GtPhlowObjectToSelect
		do: [ :anEvent | 
			aTriangleElement visibility: BlVisibility visible.
			self pagerHolder select: (self createSelectionContextFromEvent: anEvent) ].
	aContentWrapper
		when: GtPhlowObjectToSpawn
		do: [ :anEvent | 
			anEvent consumed: true.
			aTriangleElement visibility: BlVisibility visible.
			self pagerHolder spawn: (self createSelectionContextFromEvent: anEvent).].
	^ aTriangleElement
]

{ #category : #'widget configuration' }
GtPagerPageEmbellisher >> createPageCloseButtonIn: aCreationContext [
	| aCloseButton eventHandlers |
	aCloseButton := self newPageCloseButton.
	eventHandlers := OrderedCollection new.
	
	eventHandlers add: (BlEventHandler 
		on: BrPagerPageAddedEvent 
		do: [ :anEvent | self updateCloseButtonVisiblity: aCloseButton ]).
	eventHandlers add: (BlEventHandler 
		on: BrPagerPagesChanged 
		do: [ :anEvent | self updateCloseButtonVisiblity: aCloseButton ]).
	eventHandlers add: (BlEventHandler 
		on: BrPagerPageRemovedEvent 
		do: [ :anEvent |  
			anEvent page = aCreationContext contentElement viewModel 
				ifTrue: [ 
					eventHandlers do: [ :anEventHandler |
						self pagerHolder removeEventHandler: anEventHandler ] ]
				ifFalse: [
					 self updateCloseButtonVisiblity: aCloseButton ] ]).
	
	eventHandlers do: [ :anEventHandler |
		self pagerHolder addEventHandler: anEventHandler ].
	self updateCloseButtonVisiblity: aCloseButton.
	^ aCloseButton
]

{ #category : #'widget configuration' }
GtPagerPageEmbellisher >> createResizerForPage: aPageElement [
	^ self newResizer
		addChild: self newResizerHandrail;
		addEventHandler:
			(BlResizerRightListener new
				resizeTarget: aPageElement;
				minimumExtent: 75 @ 75);
		when: BlResizerResizedEvent
			do: [ :anEvent |
				self
					beExact: anEvent extent x
					page: aPageElement ];
		when: BlDoubleClickEvent
			do: [ :anEvent | 
				anEvent consumed: true.
				self
					beMatching: (self defaultPageWidthNumber)
					page: aPageElement ]
]

{ #category : #'widget configuration' }
GtPagerPageEmbellisher >> createSelectionContextFromEvent: anEvent [
	| aContext |
	aContext := self newSelectionContext
		tool: anEvent tool;
		afterPage: self contentElement.
	self selectionContext: aContext.
	^ aContext
]

{ #category : #defaults }
GtPagerPageEmbellisher >> defaultExtension [
	^ GtPagerPageEmbellisherExtension null
]

{ #category : #initialization }
GtPagerPageEmbellisher >> defaultPageWidth [
	^ GtPagerPageWidth weighted
]

{ #category : #defaults }
GtPagerPageEmbellisher >> defaultPageWidthNumber [
	^ 0.5
]

{ #category : #accessing }
GtPagerPageEmbellisher >> extension [
	^ extension
]

{ #category : #accessing }
GtPagerPageEmbellisher >> extension: anObject [
	extension := anObject
]

{ #category : #'widget configuration' }
GtPagerPageEmbellisher >> fillContentWrapperIn: aCreationContext [
	aCreationContext wrapperElement
		addChild: self contentElement;
		addChild: (self createPageCloseButtonIn: aCreationContext);
		addChild: (self createMaximizeButtonIn: aCreationContext).
]

{ #category : #'widget configuration' }
GtPagerPageEmbellisher >> fillPageElementIn: aCreationContext [
	| aTriangleElement aPageResizer |
	aTriangleElement := self createNextPageButtonOnContentWrapper: aCreationContext wrapperElement.
	aPageResizer := self createResizerForPage: aCreationContext pageElement.
	aCreationContext pageElement 
		addChild: aCreationContext wrapperElement;
		addChild: aPageResizer;
		addChild: aTriangleElement.
]

{ #category : #'widget configuration' }
GtPagerPageEmbellisher >> fillWithExtensionIn: aCreationContext [
	self extension fillToolWidgetIn: aCreationContext. 
]

{ #category : #initialization }
GtPagerPageEmbellisher >> initialize [
	super initialize.
	pageWidth := self defaultPageWidth.
	self initializePagerHolder.
	self initializeSelectionContext.
	self initializeExtension.
]

{ #category : #initialization }
GtPagerPageEmbellisher >> initializeExtension [
	extension := self defaultExtension.
]

{ #category : #'instance creation' }
GtPagerPageEmbellisher >> newCreationContext [
	^ GtPagerPageCreationContext new
]

{ #category : #'instance creation' }
GtPagerPageEmbellisher >> newMaximizeButton [
	^ GtInspectorRoundButtonStencil normal asElement
		icon: BrPlusIconStencil add asElement;
		id: GtPagerMaximizeButtonElementId;
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c margin: (BlInsets top: -10 left: -10).
			c ignored horizontal alignLeft.
			c ignored vertical alignTop ]
]

{ #category : #'instance creation' }
GtPagerPageEmbellisher >> newNextPageButton [
	^ BrPagerNextButton new
		size: 16 @ 32;
		geometry:
			(BlPolygon
				vertices:
					{(0 @ 0).
					(16 @ 16).
					(0 @ 32)});
		background: ((Color fromHexString: #BDBDBD) alpha: 0.5);
		visibility: BlVisibility hidden;
		constraintsDo: [ :c | 
			c linear horizontal alignRight.
			c linear vertical alignCenter ];
		margin: (BlInsets all: 2);
		when: BlClickEvent
			do: [ :anEvent | 
				anEvent consumed: true.
				self pagerHolder spawn: self selectionContext.
				anEvent modifiers isShift
					ifTrue: [ self pagerHolder smoothScrollToLast ] ]
]

{ #category : #'instance creation' }
GtPagerPageEmbellisher >> newPageCloseButton [
	^ GtInspectorRoundButtonStencil normal asElement
		icon: GtInspectorPlusIconStencil close asElement;
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c
				margin:
					(BlInsets
						top: -10
						left: 0
						bottom: 0
						right: -10).
			c ignored horizontal alignRight.
			c ignored vertical alignTop ];
		action: [ self pagerHolder close: self contentElement ]
]

{ #category : #'instance creation' }
GtPagerPageEmbellisher >> newPageContentWrapper [
	^ BrPagerPageContentElement new
		clipChildren: false;
		background: Color white;
		viewModel: (BrInteractiveModel new addState: BrFocusModel new);
		aptitude: BrGlamorousFocusableShadowAptitude new beLarge;
		layout: BlLinearLayout vertical;
		margin:
			(BlInsets
				top: 15
				right: 0
				bottom: 15
				left: 15);
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ]
]

{ #category : #'instance creation' }
GtPagerPageEmbellisher >> newPageElement [
	| aPageElement |

	aPageElement := BrPagerPageElement new
		id: GtPagerPageElementId;
		layout: BlLinearLayout horizontal;
		margin: (BlInsets all: 0);
		constraintsDo: [ :c | c vertical matchParent ].		

	self pageWidth onElement: aPageElement.
	
	^ aPageElement
]

{ #category : #'instance creation' }
GtPagerPageEmbellisher >> newResizer [
	^ BrPagerPageResizerElement new
		layout: BlFrameLayout new;
		constraintsDo: [ :c | 
			c vertical matchParent.
			c horizontal exact: 8.
			c margin: (BlInsets top: 40 bottom: 40).
			c padding: BlInsets empty ]
]

{ #category : #'instance creation' }
GtPagerPageEmbellisher >> newResizerHandrail [
	^ BlElement new
			background: ((Color fromHexString: #BDBDBD) alpha: 0.5);
			geometry: (BlRoundedRectangleGeometry cornerRadius: 2);
			constraintsDo: [ :c | 
				c vertical matchParent.
				c horizontal exact: 3.
				c frame vertical weight: 0.2.
				c frame horizontal alignLeft.
				c frame vertical alignCenter ]
]

{ #category : #'instance creation' }
GtPagerPageEmbellisher >> newSelectionContext [
	^ GtPagerPageSelectionContext new
]

{ #category : #accessing }
GtPagerPageEmbellisher >> pageWidth [
	<return: #GtPagerPageWidth>
	^ pageWidth
]

{ #category : #accessing }
GtPagerPageEmbellisher >> pageWidth: aGtPagerPageWidth [
	self 
		assert: [ aGtPagerPageWidth isNotNil ] 
		description: [ 'Page width must be non-nil' ].
	pageWidth := aGtPagerPageWidth
]

{ #category : #'api - configuration' }
GtPagerPageEmbellisher >> pager: aGtPager [
	pagerHolder := GtPagerHolder new pager: aGtPager.
]

{ #category : #accessing }
GtPagerPageEmbellisher >> pagerHolder [
	<return: #GtPagerHolder>
	^ pagerHolder
]

{ #category : #'api - configuration' }
GtPagerPageEmbellisher >> removePager: aGtPager [
	pagerHolder := GtPagerHolder null.
]

{ #category : #updating }
GtPagerPageEmbellisher >> updateCloseButtonVisiblity: aCloseButton [
	((self pagerHolder isLastPageEqualTo: self contentElement)
		and: [ (pagerHolder isFirstPageEqualTo: self contentElement) not ])
			ifTrue: [ aCloseButton visibility: BlVisibility visible ]
			ifFalse: [ aCloseButton visibility: BlVisibility hidden ]
]
