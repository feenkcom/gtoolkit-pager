Class {
	#name : #GtMultiPagerScrollbarElement,
	#superclass : #GtMultiPagerBasicElement,
	#instVars : [
		'scrollbarElement',
		'pagesElement',
		'pageModelsAndElements'
	],
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #initialization }
GtMultiPagerScrollbarElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtMultiPagerScrollbarElement >> initialize [
	| containerElement wrapperElement |
	super initialize.
	self hMatchParent.
	self vFitContent.

	pageModelsAndElements := OrderedCollection new.

	pagesElement := BrHorizontalPane new.
	pagesElement
		alignCenter;
		fitContent.

	scrollbarElement := BlHorizontalScrollbarElement new
			disableClickToScroll;
			beAlwaysVisible;
			constraintsDo: [ :c | c vertical exact: 6 ];
			track: (BlElement new size: 0 @ 0);
			thumb: (BlElement new
					geometry: BlStadiumGeometry new beHorizontal;
					constraintsDo: [ :c | 
						c horizontal matchParent.
						c vertical matchParent.
						c frame horizontal weight: 0.25.
						c frame vertical alignCenter ];
					aptitude: BrGlamorousFadedButtonExteriourAptitude).

	wrapperElement := BrVerticalPane new
			fitContent;
			addChild: pagesElement;
			addChild: scrollbarElement.

	containerElement := BrHorizontalPane new
			margin: (BlInsets top: 5);
			alignCenter;
			hMatchParent;
			vFitContent;
			addChild: wrapperElement.

	self addChild: containerElement
]
