Class {
	#name : #GtMultiPagerElement,
	#superclass : #GtMultiPagerBasicElement,
	#instVars : [
		'pagesListElement',
		'scrollbarElement'
	],
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #initialization }
GtMultiPagerElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #initialization }
GtMultiPagerElement >> initialize [
	super initialize.
	self initializeScrollbarElement.
	self initializePagesListElement.

	self addChild: scrollbarElement as: #scrollbar.
	self addChild: pagesListElement as: #list.
	self matchParent
]

{ #category : #initialization }
GtMultiPagerElement >> initializePagesListElement [
	pagesListElement := GtMultiPagerInfiniteElement new.

	self addAptitude: (BrLayoutResizerAptitude new inherit: pagesListElement).
	pagesListElement
		addAptitude: (BrLayoutResizerAptitude new inherit: [ pagesListElement children ])
]

{ #category : #initialization }
GtMultiPagerElement >> initializeScrollbarElement [
	scrollbarElement := GtMultiPagerScrollbarElement new.

	self addAptitude: (BrLayoutResizerAptitude new hInherit: scrollbarElement)
]

{ #category : #'api - pager model' }
GtMultiPagerElement >> onPagerModelChanged [
	pagesListElement pagerModel: self pagerModel.
	scrollbarElement pagerModel: self pagerModel
]
