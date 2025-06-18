Class {
	#name : #GtTreePagerPaneFollowingsElement,
	#superclass : #GtTreePagerPaneBasicElement,
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #initialization }
GtTreePagerPaneFollowingsElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #initialization }
GtTreePagerPaneFollowingsElement >> initialize [
	super initialize.
	self hFitContent.
	self vMatchParent
]

{ #category : #'private - updating' }
GtTreePagerPaneFollowingsElement >> newPaneElement [
	^ BrFrame new
		vMatchParent;
		hFitContent;
		addChild: (GtTreePagerFollowingPaneElement new
				constraintsDo: [ :c | 
					c frame vertical alignCenter.
					c frame horizontal alignLeft ])
]

{ #category : #'private - updating' }
GtTreePagerPaneFollowingsElement >> newPaneElementFor: aPaneModel [
	^ self newPaneElement
		in: [ :aFrame | (aFrame childAt: 1) paneModel: aPaneModel ];
		yourself
]

{ #category : #'api - pane model' }
GtTreePagerPaneFollowingsElement >> onPaneModelChanged [
	| somePaneModels somePaneElements |
	somePaneModels := self paneModel followingExpandedPaneModels.

	somePaneElements := somePaneModels
			collect: [ :eachPaneModel | self newPaneElementFor: eachPaneModel ].

	self removeChildren.
	self addChildren: somePaneElements.

	somePaneElements
		ifEmpty: [ self addChild: (self newPaneElement visibility: BlVisibility hidden) ]
]
