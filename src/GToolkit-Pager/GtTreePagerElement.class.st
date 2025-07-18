Class {
	#name : #GtTreePagerElement,
	#superclass : #GtTreePagerBasicElement,
	#instVars : [
		'panesElement',
		'scrollbarElement'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #initialization }
GtTreePagerElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #initialization }
GtTreePagerElement >> initialize [
	super initialize.
	self matchParent.

	panesElement := GtTreePagerFlowPanesElement new matchParent.
	scrollbarElement := GtTreePagerScrollbarElement new
			panesElement: panesElement;
			margin: (BlInsets top: 5).
	self addChild: scrollbarElement.
	self addChild: panesElement.

	self background: self theme default backdropBackground.
	self
		addAptitude: (BrGlamorousMaximizerOverlayHostAptitude new
				contentElement: [ BlElement new
						addAptitude: BrGlamorousFocusableShadowAptitude new;
						background: self theme default contentBackground;
						layout: BlFrameLayout new;
						clipChildren: false;
						constraintsDo: [ :c | 
							c horizontal matchParent.
							c vertical matchParent ];
						when: GtPhlowObjectToSelect
							do: [ :anEvent | self onMaximizerGtPhlowObjectToSelect: anEvent ];
						when: GtPhlowObjectToDeselect
							do: [ :anEvent | self onMaximizerGtPhlowObjectToDeselect: anEvent ];
						when: GtPhlowObjectToSpawn
							do: [ :anEvent | self onMaximizerGtPhlowObjectToSpawn: anEvent ] ];
				closeButton: [ GtInspectorRoundButtonStencil small asElement
						icon: BrGlamorousVectorIcons remove;
						label: 'Minimize pane';
						constraintsDo: [ :c | 
							c frame horizontal alignCenterAt: 0.0.
							c frame vertical alignCenterAt: 0.0 ] ]).

	self
		when: GtTreePagerScrollToColumnWish
		do: [ :aWish | self onGtTreePagerScrollToColumnWish: aWish ]
]

{ #category : #initialization }
GtTreePagerElement >> onGtTreePagerScrollToColumnWish: aWish [
	aWish consumed: true.
	panesElement smoothScrollToColumn: aWish column
]

{ #category : #'private - event handling' }
GtTreePagerElement >> onMaximizerGtPhlowObjectToDeselect: anEvent [
	anEvent consumed: true
]

{ #category : #'private - event handling' }
GtTreePagerElement >> onMaximizerGtPhlowObjectToSelect: anEvent [
	anEvent consumed: true
]

{ #category : #'private - event handling' }
GtTreePagerElement >> onMaximizerGtPhlowObjectToSpawn: anEvent [
	| aWish aMaximizerContainer |
	aWish := BrMaximizerHostMaximizedElementWish new.
	anEvent currentTarget fireEvent: aWish.
	
	aWish maximizedElementDo: [ :anElement | 
		aMaximizerContainer := anElement parent ].
	
	anEvent currentTarget fireEvent: BrMaximizerHostMinimizeWish new.

	aWish maximizedElementDo: [ :anElement | 
		aMaximizerContainer ~= anElement parent ifTrue: [
			anElement phlow spawnPreviousEvent: anEvent ] ]
]

{ #category : #'api - pager model' }
GtTreePagerElement >> onPagerModelChanged [
	super onPagerModelChanged.

	panesElement pagerModel: self pagerModel.
	scrollbarElement pagerModel: self pagerModel
]
