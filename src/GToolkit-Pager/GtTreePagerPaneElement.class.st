Class {
	#name : #GtTreePagerPaneElement,
	#superclass : #GtTreePagerPaneBasicElement,
	#instVars : [
		'contentElement',
		'followingsElement'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #initialization }
GtTreePagerPaneElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtTreePagerPaneElement >> initialize [
	super initialize.
	self matchParent.

	contentElement := GtTreePagerPaneContentElement new
			margin: (BlInsets all: 5);
			addAptitude: BrGlamorousFocusableShadowAptitude new.
	followingsElement := GtTreePagerPaneFollowingsElement new.

	self addChild: contentElement.
	self addChild: followingsElement
]

{ #category : #accessing }
GtTreePagerPaneElement >> onPaneModelChanged [
	contentElement paneModel: self paneModel.
	followingsElement paneModel: self paneModel.
]
