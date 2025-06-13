Class {
	#name : #GtMultiPagerPanesElement,
	#superclass : #GtMultiPagerBasicElement,
	#instVars : [
		'pagerElement'
	],
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #initialization }
GtMultiPagerPanesElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #initialization }
GtMultiPagerPanesElement >> initialize [
	super initialize.
	self matchParent.

	pagerElement := BrPager new matchParent.
	self addChild: pagerElement
]

{ #category : #'api - pager model' }
GtMultiPagerPanesElement >> onPagerModelChanged [
	| someElements |
	super onPagerModelChanged.

	someElements := self pagerModel panes
			collect: [ :eachPane | GtMultiPagerPaneElement new paneModel: eachPane ].

	pagerElement removeAllPages.
	someElements do: [ :eachElement | pagerElement addPage: eachElement ]
]
