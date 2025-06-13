Class {
	#name : #GtTreePagerPanesElement,
	#superclass : #GtTreePagerBasicElement,
	#instVars : [
		'pagerElement'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #initialization }
GtTreePagerPanesElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #initialization }
GtTreePagerPanesElement >> initialize [
	super initialize.
	self matchParent.

	pagerElement := BrPager new matchParent.
	self addChild: pagerElement
]

{ #category : #'api - pager model' }
GtTreePagerPanesElement >> onPagerModelChanged [
	| someElements |
	super onPagerModelChanged.

	someElements := self pagerModel columns
			collect: [ :eachPane | GtTreePagerColumnElement new paneModel: eachPane ].

	pagerElement removeAllPages.
	someElements do: [ :eachElement | pagerElement addPage: eachElement ]
]
