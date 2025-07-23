Class {
	#name : #GtPagerMaximizer,
	#superclass : #Object,
	#traits : 'TBlDebug + TGtContentElementAccessors + TGtPagerAccessors',
	#classTraits : 'TBlDebug classTrait + TGtContentElementAccessors classTrait + TGtPagerAccessors classTrait',
	#instVars : [
		'originalParent',
		'overlayElement'
	],
	#category : #'GToolkit-Pager-Stencils and Builders'
}

{ #category : #asserting }
GtPagerMaximizer >> assertPreMaximizeConditions [
	self 
		assert: [ self contentElement hasParent ]
		description: [ 'Content element must have a parent' ].
	self 
		assert: [ originalParent isNil ] 
		description: [ 'Original parent must be nil. I should be used only once.' ].
	self 
		assert: [ overlayElement isNil ] 
		description: [ 'Overlay element must be nil. I should be used only once.' ].
	
]

{ #category : #private }
GtPagerMaximizer >> enqueueMaximize [
	self pager enqueueTask: (BlTaskAction new
		action: [ self syncMaximize ])
]

{ #category : #'api - actions' }
GtPagerMaximizer >> maximize [
	BlUseAsyncFeatures 
		ifEnabledDo: [ 
			self enqueueMaximize ] 
		otherwise: [ 
			self syncMaximize ]
]

{ #category : #private }
GtPagerMaximizer >> minimize [
	self
		realToolElementDo: [ :aToolElement | 
			aToolElement userData
				at: #previousToolDetailPositionState
				ifPresent: [ :aState | 
					aToolElement states addState: aState.
					aToolElement userData removeKey: #previousToolDetailPositionState ]
				ifAbsent: [  ].
			aToolElement userData
				at: #previousToolDetailState
				ifPresent: [ :aState | 
					aToolElement states addState: aState.
					aToolElement userData removeKey: #previousToolDetailState ]
				ifAbsent: [  ] ].

	self contentElement beNormalLevel.
	originalParent
		ifNotNil: [ :aParent | 
			self contentElement removeFromParent.
			aParent addChildFirst: self contentElement ].
	overlayElement ifNotNil: [ :anOverlay | anOverlay removeFromParent ]
]

{ #category : #'instance creation' }
GtPagerMaximizer >> newMinimizeIcon [
	^ GtInspectorRoundButtonStencil normal asElement
		icon: GtInspectorMinusIconStencil minus asElement;
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c margin: (BlInsets top: -10 left: -10 bottom: 0 right: 0).
			c ignored horizontal alignLeft.
			c ignored vertical alignTop ];
		action: [ self minimize ].
]

{ #category : #'instance creation' }
GtPagerMaximizer >> newOverlay [
	^ BlOverlayElement new
		id: GtPagerMaximizedPageElementId;
		background: BlTheme default default backdropBackground;
		padding: (BlInsets all: 20);
		attachTo: self pager;
		layout: BlLinearLayout horizontal
]

{ #category : #'instance creation' }
GtPagerMaximizer >> newOverlayContent [
	^ BlElement new
		background: BlTheme default default contentBackground;
		aptitude: BrGlamorousFocusableShadowAptitude new beLarge;
		constraintsDo: [ :c | c horizontal matchParent. c vertical matchParent ];
		clipChildren: false;
		addChild: self contentElement;
		addChild: self newMinimizeIcon.
]

{ #category : #accessing }
GtPagerMaximizer >> realToolElementDo: aBlock [
	(self contentElement isKindOf: GtPagerWrapperElement)
		ifTrue: [ self contentElement tool ifNotNil: aBlock ]
		ifFalse: [ self contentElement ifNotNil: aBlock ]
]

{ #category : #'api - actions' }
GtPagerMaximizer >> syncMaximize [
	"I must be called in a UI process"

	self assertPreMaximizeConditions.
	originalParent := self contentElement parent.
	self contentElement removeFromParent.

	self
		realToolElementDo: [ :aToolElement | 
			aToolElement states
				stateLike: GtPhlowToolDetailPositionState left
				ifFound: [ :aState | 
					aToolElement userData at: #previousToolDetailPositionState put: aState.
					aToolElement states removeState: aState ]
				ifNone: [  ].
			aToolElement states
				stateLike: GtPhlowToolDetailState normal
				ifFound: [ :aState | 
					aToolElement userData at: #previousToolDetailState put: aState.
					aToolElement states removeState: aState ]
				ifNone: [  ] ].

	self contentElement beDetailedLevel.
	self contentElement states addState: GtPhlowToolDetailPositionState left.

	overlayElement := self newOverlay.
	overlayElement addChild: self newOverlayContent.
	self pager addChild: overlayElement
]
