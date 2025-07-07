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
GtTreePagerExamples >> assertTreeFlowBuilderCallbacks: aBuilderCallbacks equalsPaneCharacters: aPanesCollection [
	| aTitlesCollection |
	aTitlesCollection := aPanesCollection
			collect: [ :anArray | anArray collect: [ :anObject | anObject ifNotNil: #printString ] ].
	self
		assertTreeFlowBuilderCallbacks: aBuilderCallbacks
		equalsPaneTitles: aTitlesCollection
]

{ #category : #'examples - tree flow builder' }
GtTreePagerExamples >> assertTreeFlowBuilderCallbacks: aBuilderCallbacks equalsPaneTitles: aTitlesCollection [
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
	aPagerElement := GtTreePagerElement new.

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
	aPaneA spawnFollowingPane: aPaneH.

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
	aPaneC spawnFollowingPane: aPaneH.

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
	aPaneC spawnFollowingPane: aPaneH.

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
	aPaneC spawnFollowingPane: aPaneH.

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
	self assert: aPaneC isExpanded.
	aPaneC collapse.
	self assert: aPaneC isCollapsed.

	^ aPager
]

{ #category : #'examples - pager' }
GtTreePagerExamples >> pagerWithCollapsedFPane [
	<gtExample>
	| aPager aPaneF |
	aPager := self pagerWithFivePanes.
	aPaneF := aPager detectPaneModel: [ :each | each title = '$F' ].
	self assert: aPaneF isExpanded.
	aPaneF collapse.
	self assert: aPaneF isCollapsed.

	^ aPager
]

{ #category : #'examples - pager' }
GtTreePagerExamples >> pagerWithDWithFollowingHPane [
	<gtExample>
	| aPager aPaneD aPaneH |
	aPager := self pagerWithFivePanes.
	aPaneD := aPager detectPaneModel: [ :each | each title = '$D' ].
	self assert: aPaneD isExpanded.

	aPaneH := self paneModelWithPhlowBuilderFor: $H.
	aPaneD followingPanes do: [ :each | each fasten ].
	aPaneD spawnFollowingPane: aPaneH.

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

	aToolOne addFollowingPane: aToolTwo.

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

	aPaneA addFollowingPane: aPaneB.
	aPaneB addFollowingPane: aPaneC.
	aPaneB addFollowingPane: aPaneD.
	aPaneC addFollowingPane: aPaneE.
	aPaneC addFollowingPane: aPaneF.
	aPaneF addFollowingPane: aPaneG.

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

	aToolOne addFollowingPane: aToolTwo.
	aToolOne addFollowingPane: aToolThree.

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
	| aPager allCallbacks |
	aPager := self pagerWithCollapsedFCPanes.
	allCallbacks := OrderedCollection new.

	GtTreePagerHorizontalTreeFlowBuilder new
		paneModels: aPager paneModels;
		forEachPaneModelDo: [ :aPaneModel :aRowIndex :aDepthIndex :aSpanIndex | 
			allCallbacks
				add: {aPaneModel.
						aRowIndex.
						aDepthIndex.
						aSpanIndex} ];
		build.

	self
		assertTreeFlowBuilderCallbacks: allCallbacks
		equalsPaneCharacters: #(#($A) #($B) #(nil $E $G $D)).
	^ allCallbacks
]

{ #category : #'examples - tree flow builder' }
GtTreePagerExamples >> treeFlowBuilderWithCollapsedFPane [
	<gtExample>
	| aPager allCallbacks |
	aPager := self pagerWithCollapsedFPane.
	allCallbacks := OrderedCollection new.

	GtTreePagerHorizontalTreeFlowBuilder new
		paneModels: aPager paneModels;
		forEachPaneModelDo: [ :aPaneModel :aRowIndex :aDepthIndex :aSpanIndex | 
			allCallbacks
				add: {aPaneModel.
						aRowIndex.
						aDepthIndex.
						aSpanIndex} ];
		build.

	self
		assertTreeFlowBuilderCallbacks: allCallbacks
		equalsPaneCharacters: #(#($A) #($B) #($C $D) #($E $G)).
	^ allCallbacks
]

{ #category : #'examples - tree flow builder' }
GtTreePagerExamples >> treeFlowBuilderWithFivePanes [
	<gtExample>
	| aPager allCallbacks |
	aPager := self pagerWithFivePanes.
	allCallbacks := OrderedCollection new.

	GtTreePagerHorizontalTreeFlowBuilder new
		paneModels: aPager paneModels;
		forEachPaneModelDo: [ :aPaneModel :aRowIndex :aDepthIndex :aSpanIndex | 
			allCallbacks
				add: {aPaneModel.
						aRowIndex.
						aDepthIndex.
						aSpanIndex} ];
		build.

	self
		assertTreeFlowBuilderCallbacks: allCallbacks
		equalsPaneCharacters: #(#($A) #($B) #($C $D) #($E $F) #(nil $G)).

	^ allCallbacks
]
