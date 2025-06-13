Class {
	#name : #GtMultiPagerColumnFollowersElement,
	#superclass : #GtMultiPagerColumnBasicElement,
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #initialization }
GtMultiPagerColumnFollowersElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #initialization }
GtMultiPagerColumnFollowersElement >> initialize [
	super initialize.
	self hFitContent.
	self padding: (BlInsets left: 5).

	self addChild: self newFollowerButton
]

{ #category : #'instance  creation' }
GtMultiPagerColumnFollowersElement >> newContainerWith: anElement [
	^ BrFrame new
		hFitContent;
		vMatchParent;
		addChild: anElement
]

{ #category : #'instance  creation' }
GtMultiPagerColumnFollowersElement >> newFollowerButton [
	^ GtMultiPagerFollowingPaneElement new
		constraintsDo: [ :c | 
			c frame vertical alignCenter.
			c frame horizontal alignCenter ]
]

{ #category : #'api - pane model' }
GtMultiPagerColumnFollowersElement >> onColumnModelChanged [
	| someToolModels someToolElements |
	someToolModels := self paneModel paneModels flatCollect: #followingPanes.
	someToolElements := someToolModels
			collect: [ :each | self newContainerWith: (self newFollowerButton toolModel: each) ].
	self removeChildren.
	self addChildren: someToolElements.
	someToolElements size isZero ifTrue: [ self addChild: self newFollowerButton ]
]
