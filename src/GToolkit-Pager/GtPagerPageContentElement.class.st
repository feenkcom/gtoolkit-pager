Class {
	#name : #GtPagerPageContentElement,
	#superclass : #BrVerticalPane,
	#instVars : [
		'closeButton',
		'maximizeButton'
	],
	#category : #'GToolkit-Pager-UI'
}

{ #category : #accessing }
GtPagerPageContentElement >> closeButton [
	^ closeButton
]

{ #category : #'private - instance creation' }
GtPagerPageContentElement >> createCloseButton [
	^ GtInspectorRoundButtonStencil normal asElement
		icon: BrPlusIconStencil close asElement;
		zIndex: 10;
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
			c ignored vertical alignTop ]
]

{ #category : #'private - instance creation' }
GtPagerPageContentElement >> createMaximizeButton [
	^ GtInspectorRoundButtonStencil normal asElement
		icon: BrPlusIconStencil add asElement;
		zIndex: 10;
		id: GtPagerMaximizeButtonElementId;
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c margin: (BlInsets top: -10 left: -10).
			c ignored horizontal alignLeft.
			c ignored vertical alignTop ]
]

{ #category : #initialization }
GtPagerPageContentElement >> initialize [
	super initialize.
	
	self
		matchParent;
		clipChildren: false;
		background: Color white;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 3);
		addAptitude: BrGlamorousFocusableShadowAptitude new beLarge;
		margin: (BlInsets top: 15 right: 0 bottom: 15 left: 15).

	closeButton := self createCloseButton.
	maximizeButton := self createMaximizeButton.

	self addChild: closeButton.
	self addChild: maximizeButton
]

{ #category : #accessing }
GtPagerPageContentElement >> maximizeButton [
	^ maximizeButton
]
