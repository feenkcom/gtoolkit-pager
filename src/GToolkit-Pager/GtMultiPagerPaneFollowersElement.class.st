Class {
	#name : #GtMultiPagerPaneFollowersElement,
	#superclass : #GtMultiPagerPaneBasicElement,
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #initialization }
GtMultiPagerPaneFollowersElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #initialization }
GtMultiPagerPaneFollowersElement >> initialize [
	super initialize.
	self hFitContent.
	self padding: (BlInsets left: 5).

	self addChild: self newFollowerButton
]

{ #category : #'instance  creation' }
GtMultiPagerPaneFollowersElement >> newContainerWith: anElement [
	^ BrFrame new
		hFitContent;
		vMatchParent;
		addChild: anElement
]

{ #category : #'instance  creation' }
GtMultiPagerPaneFollowersElement >> newFollowerButton [
	^ GtMultiPagerFollowingToolElement new
		constraintsDo: [ :c | 
			c frame vertical alignCenter.
			c frame horizontal alignCenter ]
]

{ #category : #'api - pane model' }
GtMultiPagerPaneFollowersElement >> onPaneModelChanged [
	| someToolModels someToolElements |
	someToolModels := self paneModel toolModels flatCollect: #followingTools.
	someToolElements := someToolModels
			collect: [ :each | self newContainerWith: (self newFollowerButton toolModel: each) ].
	self removeChildren.
	self addChildren: someToolElements.
	someToolElements size isZero ifTrue: [ self addChild: self newFollowerButton ]
]
