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

	self
		when: GtPhlowObjectToSelect
		do: [ :anEvent | self onGtPhlowObjectToSelect: anEvent ].
	self
		when: GtPhlowObjectToDeselect
		do: [ :anEvent | self onGtPhlowObjectToDeselect: anEvent ].
	self
		when: GtPhlowObjectToSpawn
		do: [ :anEvent | self onGtPhlowObjectToSpawn: anEvent ]
]

{ #category : #initialization }
GtTreePagerPaneContentElement >> onGtPhlowObjectToDeselect: anEvent [
	self paneModel ifNil: [ ^ self ].
	anEvent consumed: true.
	self paneModel removeLink
]

{ #category : #'private - event handling' }
GtTreePagerPaneContentElement >> onGtPhlowObjectToSelect: anEvent [
	self paneModel ifNil: [ ^ self ].
	anEvent consumed: true.
	self paneModel
		selectFollowingPane: (GtTreePagerPaneModel new phlowTool: anEvent tool)
]

{ #category : #'private - event handling' }
GtTreePagerPaneContentElement >> onGtPhlowObjectToSpawn: anEvent [
	self paneModel ifNil: [ ^ self ].
	anEvent consumed: true.
	self paneModel
		spawnFollowingPane: (GtTreePagerPaneModel new
				phlowTool: anEvent tool;
				expand)
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
