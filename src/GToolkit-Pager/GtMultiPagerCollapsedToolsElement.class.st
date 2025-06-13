Class {
	#name : #GtMultiPagerCollapsedToolsElement,
	#superclass : #GtMultiPagerToolBasicElement,
	#instVars : [
		'containerElement'
	],
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #initialization }
GtMultiPagerCollapsedToolsElement >> defaultLayout [
	^ BlFrameLayout new
]

{ #category : #initialization }
GtMultiPagerCollapsedToolsElement >> initialize [
	super initialize.

	containerElement := BrHorizontalPane new
			fitContent;
			constraintsDo: [ :c | 
				c frame horizontal alignCenter.
				c frame vertical alignCenter ].

	self addChild: containerElement
]

{ #category : #'api - tool model' }
GtMultiPagerCollapsedToolsElement >> onToolModelChanged [
	| aCount someElements |
	aCount := self toolModel collapsedChainCount.

	self removeChildren.
	someElements := (1 to: aCount)
			collect: [ :eachIndex | 
				BlElement new
					geometry: BlStadiumGeometry new beVertical;
					size: 2 @ 30;
					background: self theme default contentBackground;
					border: (BlBorder paint: self theme default darkBorderColor width: 1) ].
	containerElement addChildren: someElements
]
