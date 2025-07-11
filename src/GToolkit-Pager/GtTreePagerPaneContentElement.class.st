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
	| aSelectedPane |
	self paneModel ifNil: [ ^ self ].
	anEvent consumed: true.
	aSelectedPane := GtTreePagerPaneModel new phlowTool: anEvent tool.
	self paneModel selectPane: aSelectedPane.
	
	aSelectedPane isSpawned ifFalse: [ ^ self ].
	
	self
		fireEvent: (GtTreePagerScrollToColumnWish new column: aSelectedPane depthIndex)
]

{ #category : #'private - event handling' }
GtTreePagerPaneContentElement >> onGtPhlowObjectToSpawn: anEvent [
	| aSpawnedPane |
	self paneModel ifNil: [ ^ self ].
	anEvent consumed: true.
	aSpawnedPane := GtTreePagerPaneModel new
			phlowTool: anEvent tool;
			expand.
	self paneModel spawnPane: aSpawnedPane.

	self
		fireEvent: (GtTreePagerScrollToColumnWish new column: aSpawnedPane depthIndex)
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
