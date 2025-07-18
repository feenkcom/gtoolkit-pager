Class {
	#name : #GtTreePagerPaneContentElement,
	#superclass : #GtTreePagerPaneBasicElement,
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #initialization }
GtTreePagerPaneContentElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtTreePagerPaneContentElement >> initialize [
	super initialize.
	self background: self theme default contentBackground.
	self matchParent.
	self clipChildren: false.
	self beFocusable
]

{ #category : #accessing }
GtTreePagerPaneContentElement >> onPaneModelChanged [
	| targetId |
	targetId := #tool asBlocElementId.
	self childrenDo: [ :eachChild | eachChild id = targetId 
		ifTrue: [ eachChild removeFromParent ] ].

	self addChild: self paneModel asElement as: targetId
]

{ #category : #accessing }
GtTreePagerPaneContentElement >> toolElement [
	| targetId |
	targetId := #tool asBlocElementId.
	self
		childrenDo: [ :eachChild | eachChild id = targetId ifTrue: [ ^ eachChild ] ].

	^ nil
]
