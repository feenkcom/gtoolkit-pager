Class {
	#name : #GtTreePagerExamples,
	#superclass : #Object,
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'examples - pager' }
GtTreePagerExamples >> assertPager: aPager columnCharacterPanes: aPanesCollection [
	| aTitlesCollection |
	aTitlesCollection := aPanesCollection collect: [ :each | each collect: #printString ].
	self assertPager: aPager columnPaneTitles: aTitlesCollection
]

{ #category : #'examples - pager' }
GtTreePagerExamples >> assertPager: aPager columnPaneTitles: aPanesCollection [
	"aCollection is an array of arrays. 
	Each array contains tool titles for a particular pane."

	self assert: aPager columns size equals: aPanesCollection size.
	aPanesCollection
		withIndexDo: [ :eachPaneCollection :eachPaneIndex | 
			| aPane |
			aPane := aPager columns at: eachPaneIndex.
			self
				assert: aPane paneModels size = eachPaneCollection size
				description: [ 'Pane {1} has {2} tools, but must have {3} tools: {4} vs. {5}'
						format: {eachPaneIndex.
								aPane toolModels size.
								eachPaneCollection size.
								aPane toolModels collect: #title.
								eachPaneCollection asArray} ].
			eachPaneCollection
				withIndexDo: [ :eachToolTitle :eachToolIndex | 
					| aTool |
					aTool := aPane paneModels at: eachToolIndex.
					self assert: aTool title equals: eachToolTitle ] ]
]

{ #category : #'examples - tree flow builder' }
GtTreePagerExamples >> assertTreeFlowBuilderNonSpawnedCallbacks: aBuilderCallbacks equalsPaneCharacters: aPanesCollection [
	| aTitlesCollection |
	aTitlesCollection := aPanesCollection
			collect: [ :anObject | anObject ifNotNil: #printString ].
	self
		assertTreeFlowBuilderNonSpawnedCallbacks: aBuilderCallbacks
		equalsPaneTitles: aTitlesCollection
]

{ #category : #'examples - tree flow builder' }
GtTreePagerExamples >> assertTreeFlowBuilderNonSpawnedCallbacks: aBuilderCallbacks equalsPaneTitles: aTitlesCollection [
	self
		assert: (aBuilderCallbacks collect: #title as: Array)
		equals: aTitlesCollection
]

{ #category : #'examples - tree flow builder' }
GtTreePagerExamples >> assertTreeFlowBuilderSpawnedCallbacks: aBuilderCallbacks equalsPaneCharacters: aPanesCollection [
	| aTitlesCollection |
	aTitlesCollection := aPanesCollection
			collect: [ :anArray | anArray collect: [ :anObject | anObject ifNotNil: #printString ] ].
	self
		assertTreeFlowBuilderSpawnedCallbacks: aBuilderCallbacks
		equalsPaneTitles: aTitlesCollection
]

{ #category : #'examples - tree flow builder' }
GtTreePagerExamples >> assertTreeFlowBuilderSpawnedCallbacks: aBuilderCallbacks equalsPaneTitles: aTitlesCollection [
	aTitlesCollection
		withIndexDo: [ :eachPaneCollection :eachDepthIndex | 
			eachPaneCollection
				withIndexDo: [ :eachPaneTitle :eachRowIndex | 
					eachPaneTitle
						ifNotNil: [ | someCandidates |
							someCandidates := aBuilderCallbacks
									select: [ :each | (each at: 1) title = eachPaneTitle ].

							self
								assert: someCandidates size = 1
								description: [ someCandidates size isZero
										ifTrue: [ 'Could not find {1} pane title: {2}'
												format: {eachPaneTitle.
														aBuilderCallbacks} ]
										ifFalse: [ 'Too many candidates for {1} pane title: {2}'
												format: {eachPaneTitle.
														aBuilderCallbacks} ] ].
							self assert: (someCandidates anyOne at: 2) equals: eachRowIndex.
							self assert: (someCandidates anyOne at: 3) equals: eachDepthIndex ] ] ]
]

{ #category : #'examples - pager ui' }
GtTreePagerExamples >> basicPagerElement [
	<gtExample>
	| aPagerElement |
	aPagerElement := GtTreePager new.

	^ aPagerElement
]

{ #category : #'examples - pager' }
GtTreePagerExamples >> basicPagerModel [
	<gtExample>
	| aModel |
	aModel := GtTreePagerModel new.

	^ aModel
]

{ #category : #'examples - panes' }
GtTreePagerExamples >> basicPaneModel [
	<gtExample>
	| aModel |
	aModel := GtTreePagerPaneModel new.

	^ aModel
]

{ #category : #'examples - followings' }
GtTreePagerExamples >> followingsUpdaterWithCFromCollapsedFPane [
	<gtExample>
	| aPager anUpdater aPane somePanes |
	aPager := self pagerWithCollapsedFCPanes.
	aPane := aPager detectPaneModel: [ :each | each title = $B printString ].

	anUpdater := GtTreePagerPaneFollowingsElementUpdater new paneModel: aPane.
	somePanes := anUpdater linksToDisplay.
	self assert: somePanes size equals: 3.
	self assert: (somePanes collect: #title) equals: #('$C' '$F' '$D').
	self assert: anUpdater linkElementsToDisplay size equals: 4.

	^ anUpdater
]

{ #category : #'examples - followings' }
GtTreePagerExamples >> followingsUpdaterWithCFromFivePanes [
	<gtExample>
	| aPager anUpdater aPane somePanes |
	aPager := self pagerWithFivePanes.
	aPane := aPager detectPaneModel: [ :each | each title = $C printString ].

	anUpdater := GtTreePagerPaneFollowingsElementUpdater new paneModel: aPane.
	somePanes := anUpdater linksToDisplay.
	self assert: somePanes size equals: 2.
	self assert: (somePanes collect: #title) equals: #('$E' '$F' ).
	self assert: anUpdater linkElementsToDisplay size equals: 2.

	^ anUpdater
]

{ #category : #'examples - followings' }
GtTreePagerExamples >> followingsUpdaterWithFFromFivePanes [
	<gtExample>
	| aPager anUpdater aPane somePanes |
	aPager := self pagerWithFivePanes.
	aPane := aPager detectPaneModel: [ :each | each title = $F printString ].

	anUpdater := GtTreePagerPaneFollowingsElementUpdater new paneModel: aPane.
	somePanes := anUpdater linksToDisplay.
	self assert: somePanes size equals: 1.
	self assert: somePanes anyOne title equals: $G printString.
	self assert: anUpdater linkElementsToDisplay size equals: 1.

	^ anUpdater
]

{ #category : #'examples - followings' }
GtTreePagerExamples >> followingsUpdaterWithGFromFivePanes [
	<gtExample>
	| aPager anUpdater aPane somePanes |
	aPager := self pagerWithFivePanes.
	aPane := aPager detectPaneModel: [ :each | each title = $G printString ].

	anUpdater := GtTreePagerPaneFollowingsElementUpdater new paneModel: aPane.
	somePanes := anUpdater linksToDisplay.
	self assert: somePanes isEmpty.
	self assert: anUpdater linkElementsToDisplay isEmpty.

	^ anUpdater
]

{ #category : #'examples - pager ui' }
GtTreePagerExamples >> pagerElementWithFiveColumns [
	<gtExample>
	| aPagerElement aPagerModel |
	aPagerElement := self basicPagerElement.
	aPagerModel := self pagerWithFivePanes.
	aPagerElement pagerModel: aPagerModel.

	(aPagerElement childAt: aPagerElement childrenCount) layoutDo: [ :l | l numberOfVisibleColumns: 5 ].

	^ aPagerElement
]

{ #category : #'examples - pager' }
GtTreePagerExamples >> pagerWithAWithFollowingHPane [
	<gtExample>
	| aPager aPaneA aPaneH |
	aPager := self pagerWithFivePanes.
	aPaneA := aPager detectPaneModel: [ :each | each title = '$A' ].
	self assert: aPaneA isExpanded.

	aPaneH := self paneModelWithPhlowBuilderFor: $H.
	aPaneA spawnPane: aPaneH.

	self assert: aPaneA followingPanes size equals: 1.

	^ aPager
]

{ #category : #'examples - pager' }
GtTreePagerExamples >> pagerWithCWithFollowingEFHPanes [
	<gtExample>
	| aPager aPaneC aPaneH |
	aPager := self pagerWithFivePanes.
	aPaneC := aPager detectPaneModel: [ :each | each title = '$C' ].
	self assert: aPaneC title equals: '$C'.
	self assert: aPaneC isExpanded.

	aPaneH := self paneModelWithPhlowBuilderFor: $H.
	aPaneC inactivateLink.
	aPaneC spawnPane: aPaneH.

	self assert: aPaneC followingPanes size equals: 3.

	^ aPager
]

{ #category : #'examples - pager' }
GtTreePagerExamples >> pagerWithCWithFollowingHFPanes [
	<gtExample>
	| aPager aPaneC aPaneH aLinkF |
	aPager := self pagerWithFivePanes.
	aPaneC := aPager detectPaneModel: [ :each | each title = '$C' ].
	self assert: aPaneC isExpanded.

	aPaneH := self paneModelWithPhlowBuilderFor: $H.
	aLinkF := aPaneC followingLinks second.
	self assert: aLinkF title equals: '$F'.
	aLinkF beActiveLink.
	self assert: aPaneC activeLink equals: aLinkF.
	aPaneC spawnPane: aPaneH.

	self assert: aPaneC followingPanes size equals: 2.

	^ aPager
]

{ #category : #'examples - pager' }
GtTreePagerExamples >> pagerWithCWithFollowingHPane [
	<gtExample>
	| aPager aPaneC aPaneH |
	aPager := self pagerWithFivePanes.
	aPaneC := aPager detectPaneModel: [ :each | each title = '$C' ].
	self assert: aPaneC isExpanded.

	aPaneH := self paneModelWithPhlowBuilderFor: $H.
	aPaneC spawnPane: aPaneH.

	self assert: aPaneC followingPanes size equals: 2.

	^ aPager
]

{ #category : #'examples - pager' }
GtTreePagerExamples >> pagerWithCollapsedCNewlyExpandedFPanes [
	<gtExample>
	| aPager aPaneF |
	aPager := self pagerWithCollapsedFCPanes.
	aPaneF := aPager detectPaneModel: [ :each | each title = '$F' ].
	self assert: aPaneF isCollapsed.
	aPaneF expand.
	self assert: aPaneF isExpanded.

	^ aPager
]

{ #category : #'examples - pager' }
GtTreePagerExamples >> pagerWithCollapsedFCPanes [
	<gtExample>
	| aPager aPaneC |
	aPager := self pagerWithCollapsedFPane.
	aPaneC := aPager detectPaneModel: [ :each | each title = '$C' ].
	self assert: aPaneC isSpawned.
	self assert: aPaneC isExpanded.
	aPaneC collapse.
	self assert: aPaneC isCollapsed.
	self assert: aPaneC isSpawned not.
	self assert: aPaneC isActive not.

	^ aPager
]

{ #category : #'examples - pager' }
GtTreePagerExamples >> pagerWithCollapsedFCPanes_similarPaneCopy [
	<gtExample>
	| aPager aLinkC aLinkF copyOfPaneC anotherPager copyOfLinkF |
	aPager := self pagerWithCollapsedFCPanes.
	aLinkC := aPager detectLinkModel: [ :each | each title = '$C' ].
	aLinkF := aPager detectLinkModel: [ :each | each title = '$F' ].
	self assert: aLinkC isCollapsed.
	self assert: aLinkF isCollapsed.

	copyOfPaneC := aLinkC similarPaneCopy.
	copyOfLinkF := copyOfPaneC detectLinkModel: [ :each | each title = '$F' ].

	self assert: (aLinkC paneModel == copyOfPaneC) not.
	self assert: (copyOfPaneC isKindOf: GtTreePagerPaneModel).
	self assert: copyOfPaneC withAllFollowingPanes size equals: 4.
	self assert: copyOfPaneC isCollapsed not.
	self assert: copyOfPaneC isSpawned.
	self assert: copyOfPaneC isActive.

	self assert: copyOfLinkF isCollapsed.
	
	anotherPager := self basicPagerModel.
	anotherPager paneModel: copyOfPaneC.

	self assert: copyOfPaneC isCollapsed not.
	self assert: copyOfPaneC isSpawned.
	self assert: copyOfPaneC isActive.

	^ anotherPager
]

{ #category : #'examples - pager' }
GtTreePagerExamples >> pagerWithCollapsedFPane [
	<gtExample>
	| aPager aPaneF |
	aPager := self pagerWithFivePanes.
	aPaneF := aPager detectPaneModel: [ :each | each title = '$F' ].
	self assert: aPaneF isSpawned.
	self assert: aPaneF isExpanded.
	aPaneF collapse.
	self assert: aPaneF isCollapsed.
	self assert: aPaneF isSpawned not.

	^ aPager
]

{ #category : #'examples - pager' }
GtTreePagerExamples >> pagerWithDWithFollowingHPane [
	<gtExample>
	| aPager aPaneD aPaneH aPagerAnnouncements aPaneDAnnouncements |
	aPagerAnnouncements := OrderedCollection new.
	aPaneDAnnouncements := OrderedCollection new.
	aPager := self pagerWithFivePanes.
	aPaneD := aPager detectPaneModel: [ :each | each title = '$D' ].
	self assert: aPaneD isExpanded.
	
	aPager announcer weak when: Announcement send: #add: to: aPagerAnnouncements.
	aPaneD announcer weak when: Announcement send: #add: to: aPaneDAnnouncements.

	aPaneH := self paneModelWithPhlowBuilderFor: $H.
	aPaneD spawnPane: aPaneH.
	
	self assert: aPagerAnnouncements size equals: 1.
	self assert: aPaneDAnnouncements size equals: 2.

	^ aPager
]

{ #category : #'examples - pager' }
GtTreePagerExamples >> pagerWithEActiveLink [
	<gtExample>
	| aPager aPaneC aPagerAnnouncements aPaneCAnnouncements aLinkE aLinkF aLinkEAnnouncements aLinkFAnnouncements |
	aPagerAnnouncements := OrderedCollection new.
	aPaneCAnnouncements := OrderedCollection new.
	aLinkEAnnouncements := OrderedCollection new.
	aLinkFAnnouncements := OrderedCollection new.

	aPager := self pagerWithFivePanes.
	aPaneC := aPager detectPaneModel: [ :each | each title = '$C' ].
	self assert: aPaneC isSpawned.
	aLinkE := aPaneC followingLinks detect: [ :each | each title = '$E' ].
	aLinkF := aPaneC followingLinks detect: [ :each | each title = '$F' ].
	self assert: aLinkE isActive not.
	self assert: aLinkF isActive.

	aPager announcer weak
		when: Announcement
		send: #add:
		to: aPagerAnnouncements.
	aPaneC announcer weak
		when: Announcement
		send: #add:
		to: aPaneCAnnouncements.
	aLinkE announcer weak
		when: Announcement
		send: #add:
		to: aLinkEAnnouncements.
	aLinkF announcer weak
		when: Announcement
		send: #add:
		to: aLinkFAnnouncements.

	aLinkE activate.
	self assert: aLinkE isActive.
	self assert: aLinkF isActive not.

	self assert: aPagerAnnouncements size equals: 2.
	self assert: aPaneCAnnouncements size equals: 2.
	self assert: aLinkEAnnouncements size equals: 1.
	self assert: aLinkFAnnouncements size equals: 1.

	^ aPager
]

{ #category : #'examples - pager' }
GtTreePagerExamples >> pagerWithFivePanes [
	<gtExample>
	| aPager aPane |
	aPager := self basicPagerModel.
	aPane := self paneModelWithThreeFollowingLevels.
	aPager paneModel: aPane.
	
	^ aPager
]

{ #category : #'examples - pager' }
GtTreePagerExamples >> pagerWithHiddenCPaneCollapsedFPane [
	<gtExample>
	| aPager aPaneC |
	aPager := self pagerWithCollapsedFPane.
	aPaneC := aPager detectPaneModel: [ :each | each title = '$C' ].
	self assert: aPaneC isSpawned.
	self assert: aPaneC isExpanded.
	self assert: aPaneC isHidden not.
	aPaneC hide.
	self assert: aPaneC isHidden.
	self assert: aPaneC isCollapsed not.
	self assert: aPaneC isSpawned not.

	^ aPager
]

{ #category : #'examples - pager' }
GtTreePagerExamples >> pagerWithNewlyExpandedFPane [
	<gtExample>
	| aPager aPaneF |
	aPager := self pagerWithCollapsedFPane.
	aPaneF := aPager detectPaneModel: [ :each | each title = '$F' ].
	self assert: aPaneF isCollapsed.
	aPaneF expand.
	self assert: aPaneF isExpanded.

	^ aPager
]

{ #category : #'examples - panes' }
GtTreePagerExamples >> paneElementWithIndex: anInteger [
	<gtExample>
	^ BrFrame new
		matchParent;
		background: BlTheme default default appBackground;
		addChild: (BrLabel new
				alignCenter;
				beHugeSize;
				aptitude: BrGlamorousLabelAptitude;
				text: anInteger asString;
				constraintsDo: [ :c | 
					c frame horizontal alignCenter.
					c frame vertical alignCenter ])
]

{ #category : #'examples - panes' }
GtTreePagerExamples >> paneModelWithColumnedListInspector [
	<gtExample>
	| aPaneModel |
	aPaneModel := GtTreePagerPaneModel new
			object: BrExamplesShowroom new columnedList.

	self assert: (aPaneModel asElement isKindOf: BlElement).
	self assert: aPaneModel isCollapsed not.

	^ aPaneModel
]

{ #category : #'examples - panes' }
GtTreePagerExamples >> paneModelWithElementIndexOne [
	<gtExample>
	| aToolModel |
	aToolModel := GtTreePagerPaneModel new
			phlowTool: (GtPhlowExplicitTool new stencil: [ self paneElementWithIndex: 1 ]).

	self assert: (aToolModel asElement isKindOf: BlElement).

	^ aToolModel
]

{ #category : #'examples - panes' }
GtTreePagerExamples >> paneModelWithIntegerInspector [
	<gtExample>
	| aToolModel |
	aToolModel := self basicPaneModel object: 108.

	self assert: (aToolModel asElement isKindOf: BlElement).
	self assert: aToolModel isCollapsed not.

	^ aToolModel
]

{ #category : #'examples - panes' }
GtTreePagerExamples >> paneModelWithOneFollowingTool [
	<gtExample>
	| aToolTwo aToolOne |
	aToolOne := self paneModelWithColumnedListInspector.
	aToolTwo := self paneModelWithIntegerInspector.

	aToolOne spawnSiblingPane: aToolTwo.

	self assert: aToolOne followingPanes size equals: 1.
	self assert: aToolOne followingPanes first equals: aToolTwo.
	self assert: aToolTwo previousPane equals: aToolOne.

	^ aToolOne
]

{ #category : #'examples - panes' }
GtTreePagerExamples >> paneModelWithPhlowBuilderFor: anObject [
	<gtExample>
	| aToolModel |
	aToolModel := self basicPaneModel.
	aToolModel object: anObject.

	self assert: aToolModel phlowTool object equals: anObject.
	self assert: (aToolModel asElement isKindOf: BlElement).
	self assert: aToolModel isCollapsed not.

	^ aToolModel
]

{ #category : #'examples - panes' }
GtTreePagerExamples >> paneModelWithThreeFollowingLevels [
	<gtExample>
	| aPaneA aPaneB aPaneC aPaneD aPaneE aPaneF aPaneG |
	aPaneA := self paneModelWithPhlowBuilderFor: $A.
	aPaneB := self paneModelWithPhlowBuilderFor: $B.
	aPaneC := self paneModelWithPhlowBuilderFor: $C.
	aPaneD := self paneModelWithPhlowBuilderFor: $D.
	aPaneE := self paneModelWithPhlowBuilderFor: $E.
	aPaneF := self paneModelWithPhlowBuilderFor: $F.
	aPaneG := self paneModelWithPhlowBuilderFor: $G.

	aPaneA spawnSiblingPane: aPaneB.
	aPaneB spawnSiblingPane: aPaneC.
	aPaneB spawnSiblingPane: aPaneD.
	aPaneC spawnSiblingPane: aPaneE.
	aPaneC spawnSiblingPane: aPaneF.
	aPaneF spawnSiblingPane: aPaneG.

	self assert: aPaneA followingPanes size equals: 1.
	self assert: aPaneB followingPanes size equals: 2.
	self assert: aPaneC followingPanes size equals: 2.
	self assert: aPaneD followingPanes size equals: 0.
	self assert: aPaneE followingPanes size equals: 0.
	self assert: aPaneF followingPanes size equals: 1.
	self assert: aPaneG followingPanes size equals: 0.

	^ aPaneA
]

{ #category : #'examples - panes' }
GtTreePagerExamples >> paneModelWithTwoFollowingTools [
	<gtExample>
	| aToolTwo aToolOne aToolThree |
	aToolOne := self paneModelWithColumnedListInspector.
	aToolTwo := self paneModelWithIntegerInspector.
	aToolThree := self paneModelWithPhlowBuilderFor: 42 / 108.

	aToolOne spawnSiblingPane: aToolTwo.
	aToolOne spawnSiblingPane: aToolThree.

	self assert: aToolOne followingPanes size equals: 2.
	self assert: aToolOne followingPanes first equals: aToolTwo.
	self assert: aToolTwo previousPane equals: aToolOne.
	self assert: aToolOne followingPanes second equals: aToolThree.
	self assert: aToolThree previousPane equals: aToolOne.

	^ aToolOne
]

{ #category : #'examples - tree flow builder' }
GtTreePagerExamples >> treeFlowBuilderWithCollapsedFCPanes [
	<gtExample>
	| aPager allSpawnedCallbacks allNonSpawnedCallbacks |
	aPager := self pagerWithCollapsedFCPanes.
	allSpawnedCallbacks := OrderedCollection new.
	allNonSpawnedCallbacks := OrderedCollection new.

	GtTreePagerHorizontalTreeFlowBuilder new
		linkModels: aPager linkModels;
		nonSpawnedLinkModelBlock: [ :aLinkModel | allNonSpawnedCallbacks add: aLinkModel ];
		spawnedLinkModelBlock: [ :aLinkModel :aRowIndex :aDepthIndex :aSpanIndex | 
			allSpawnedCallbacks
				add: {aLinkModel.
						aRowIndex.
						aDepthIndex.
						aSpanIndex} ];
		build.

	self
		assertTreeFlowBuilderSpawnedCallbacks: allSpawnedCallbacks
		equalsPaneCharacters: #(#($A) #($B) #($E $G $D)).
	self
		assertTreeFlowBuilderNonSpawnedCallbacks: allNonSpawnedCallbacks
		equalsPaneCharacters: #($C $F).
	^ allSpawnedCallbacks
]

{ #category : #'examples - tree flow builder' }
GtTreePagerExamples >> treeFlowBuilderWithCollapsedFPane [
	<gtExample>
	| aPager allCallbacks allNonSpawnedCallbacks |
	aPager := self pagerWithCollapsedFPane.
	allCallbacks := OrderedCollection new.
	allNonSpawnedCallbacks := OrderedCollection new.

	GtTreePagerHorizontalTreeFlowBuilder new
		linkModels: aPager linkModels;
		nonSpawnedLinkModelBlock: [ :aLinkModel | allNonSpawnedCallbacks add: aLinkModel ];
		spawnedLinkModelBlock: [ :aPaneModel :aRowIndex :aDepthIndex :aSpanIndex | 
			allCallbacks
				add: {aPaneModel.
						aRowIndex.
						aDepthIndex.
						aSpanIndex} ];
		build.

	self
		assertTreeFlowBuilderSpawnedCallbacks: allCallbacks
		equalsPaneCharacters: #(#($A) #($B) #($C $D) #($E $G)).
	self
		assertTreeFlowBuilderNonSpawnedCallbacks: allNonSpawnedCallbacks
		equalsPaneCharacters: #($F).
	^ allCallbacks
]

{ #category : #'examples - tree flow builder' }
GtTreePagerExamples >> treeFlowBuilderWithFivePanes [
	<gtExample>
	| aPager allCallbacks allNonSpawnedCallbacks |
	aPager := self pagerWithFivePanes.
	allCallbacks := OrderedCollection new.
	allNonSpawnedCallbacks := OrderedCollection new.

	GtTreePagerHorizontalTreeFlowBuilder new
		linkModels: aPager linkModels;
		nonSpawnedLinkModelBlock: [ :aLinkModel | allNonSpawnedCallbacks add: aLinkModel ];
		spawnedLinkModelBlock: [ :aPaneModel :aRowIndex :aDepthIndex :aSpanIndex | 
			allCallbacks
				add: {aPaneModel.
						aRowIndex.
						aDepthIndex.
						aSpanIndex} ];
		build.

	self
		assertTreeFlowBuilderSpawnedCallbacks: allCallbacks
		equalsPaneCharacters: #(#($A) #($B) #($C $D) #($E $F) #($G)).
	self
		assertTreeFlowBuilderNonSpawnedCallbacks: allNonSpawnedCallbacks
		equalsPaneCharacters: #().

	^ allCallbacks
]

{ #category : #'examples - tree flow builder' }
GtTreePagerExamples >> treeFlowBuilderWithHiddenCPaneCollapsedFPane [
	<gtExample>
	| aPager allSpawnedCallbacks allNonSpawnedCallbacks |
	aPager := self pagerWithHiddenCPaneCollapsedFPane.
	allSpawnedCallbacks := OrderedCollection new.
	allNonSpawnedCallbacks := OrderedCollection new.

	GtTreePagerHorizontalTreeFlowBuilder new
		linkModels: aPager linkModels;
		nonSpawnedLinkModelBlock: [ :aLinkModel | allNonSpawnedCallbacks add: aLinkModel ];
		spawnedLinkModelBlock: [ :aLinkModel :aRowIndex :aDepthIndex :aSpanIndex | 
			allSpawnedCallbacks
				add: {aLinkModel.
						aRowIndex.
						aDepthIndex.
						aSpanIndex} ];
		build.

	self
		assertTreeFlowBuilderSpawnedCallbacks: allSpawnedCallbacks
		equalsPaneCharacters: #(#($A) #($B) #($D)).
	self
		assertTreeFlowBuilderNonSpawnedCallbacks: allNonSpawnedCallbacks
		equalsPaneCharacters: #($C $E $F $G).
	^ allSpawnedCallbacks
]
