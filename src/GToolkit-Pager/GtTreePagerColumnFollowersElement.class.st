Class {
	#name : #GtTreePagerColumnFollowersElement,
	#superclass : #GtTreePagerColumnBasicElement,
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #initialization }
GtTreePagerColumnFollowersElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #initialization }
GtTreePagerColumnFollowersElement >> initialize [
	super initialize.
	self hFitContent.
	self padding: (BlInsets left: 5).

	self addChild: self newFollowerButton
]

{ #category : #'instance  creation' }
GtTreePagerColumnFollowersElement >> newContainerWith: anElement [
	^ BrFrame new
		hFitContent;
		vMatchParent;
		addChild: anElement
]

{ #category : #'instance  creation' }
GtTreePagerColumnFollowersElement >> newFollowerButton [
	^ GtTreePagerFollowingPaneElement new
		constraintsDo: [ :c | 
			c frame vertical alignCenter.
			c frame horizontal alignCenter ]
]

{ #category : #'api - pane model' }
GtTreePagerColumnFollowersElement >> onColumnModelChanged [
	| someToolModels someToolElements |
	someToolModels := self paneModel paneModels flatCollect: #followingPanes.
	someToolElements := someToolModels
			collect: [ :each | self newContainerWith: (self newFollowerButton toolModel: each) ].
	self removeChildren.
	self addChildren: someToolElements.
	someToolElements size isZero ifTrue: [ self addChild: self newFollowerButton ]
]
