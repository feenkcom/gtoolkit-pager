Class {
	#name : #GtMultiPagerExamples,
	#superclass : #Object,
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #'examples - pager' }
GtMultiPagerExamples >> assertPager: aPager columnCharacterPanes: aPanesCollection [
	| aTitlesCollection |
	aTitlesCollection := aPanesCollection collect: [ :each | each collect: #printString ].
	self assertPager: aPager columnPaneTitles: aTitlesCollection
]

{ #category : #'examples - pager' }
GtMultiPagerExamples >> assertPager: aPager columnPaneTitles: aPanesCollection [
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

{ #category : #'examples - columns' }
GtMultiPagerExamples >> basicColumnModel [
	<gtExample>
	| aColumn |
	aColumn := GtMultiPagerColumnModel new.

	^ aColumn
]

{ #category : #'examples - pager ui' }
GtMultiPagerExamples >> basicPagerElement [
	<gtExample>
	| aPagerElement |
	aPagerElement := GtMultiPagerElement new.

	^ aPagerElement
]

{ #category : #'examples - pager' }
GtMultiPagerExamples >> basicPagerModel [
	<gtExample>
	| aModel |
	aModel := GtMultiPagerModel new.

	^ aModel
]

{ #category : #'examples - panes' }
GtMultiPagerExamples >> basicPaneModel [
	<gtExample>
	| aModel |
	aModel := GtMultiPagerPaneModel new.

	^ aModel
]

{ #category : #'examples - columns' }
GtMultiPagerExamples >> columnModelWithOneElementIndexOnePane [
	<gtExample>
	| aColumn |
	aColumn := self basicColumnModel.
	aColumn
		title: 'Pane 1';
		paneModel: self paneModelWithElementIndexOne.

	^ aColumn
]

{ #category : #'examples - columns' }
GtMultiPagerExamples >> columnModelWithOneFollowingPane [
	<gtExample>
	| aPane |
	aPane := self basicColumnModel.
	aPane
		title: 'Pane 1';
		paneModel: self paneModelWithOneFollowingTool.

	^ aPane
]

{ #category : #'examples - columns' }
GtMultiPagerExamples >> columnModelWithTwoFollowingPanes [
	<gtExample>
	| aColumn |
	aColumn := self basicColumnModel.
	aColumn
		title: 'Pane 1';
		paneModel: self paneModelWithTwoFollowingTools.

	aColumn paneModels first followingPanes second collapse.
	self assert: aColumn paneModels first followingPanes second isCollapsed.

	^ aColumn
]

{ #category : #'examples - columns' }
GtMultiPagerExamples >> columnModelWithTwoPanes [
	<gtExample>
	| aPane |
	aPane := self basicColumnModel.
	aPane
		title: 'Pane 1';
		paneModel: self paneModelWithElementIndexOne;
		paneModel: self paneModelWithIntegerInspector.

	^ aPane
]

{ #category : #'examples - pager ui' }
GtMultiPagerExamples >> pagerElementWithFiveColumns [
	<gtExample>
	| aPagerElement aPagerModel |
	aPagerElement := self basicPagerElement.
	aPagerModel := self pagerWithFivePanes.
	aPagerElement pagerModel: aPagerModel.

	^ aPagerElement
]

{ #category : #'examples - pager' }
GtMultiPagerExamples >> pagerWithAWithFollowingHPane [
	<gtExample>
	| aPager aPaneA aPaneH |
	aPager := self pagerWithFivePanes.
	aPaneA := (aPager columns at: 1) paneModels first.
	self assert: aPaneA title equals: '$A'.
	self assert: aPaneA isExpanded.

	aPaneH := self paneModelWithPhlowBuilderFor: $H.
	aPaneA replaceFollowingPaneBy: aPaneH.

	self assertPager: aPager columnCharacterPanes: #(#($A) #($H)).
	self assert: aPaneA followingPanes size equals: 1.

	^ aPager
]

{ #category : #'examples - pager' }
GtMultiPagerExamples >> pagerWithCWithFollowingEFHPanes [
	<gtExample>
	| aPager aPaneC aPaneH |
	aPager := self pagerWithFivePanes.
	aPaneC := (aPager columns at: 3) paneModels first.
	self assert: aPaneC title equals: '$C'.
	self assert: aPaneC isExpanded.

	aPaneH := self paneModelWithPhlowBuilderFor: $H.
	aPaneC followingPanes do: [ :each | each fasten ].
	aPaneC replaceFollowingPaneBy: aPaneH.

	self
		assertPager: aPager
		columnCharacterPanes: #(#($A) #($B) #($C $D) #($E $F $H) #($G)).
	self assert: aPaneC followingPanes size equals: 3.

	^ aPager
]

{ #category : #'examples - pager' }
GtMultiPagerExamples >> pagerWithCWithFollowingHFPanes [
	<gtExample>
	| aPager aPaneC aPaneH aPaneF |
	aPager := self pagerWithFivePanes.
	aPaneC := (aPager columns at: 3) paneModels first.
	self assert: aPaneC title equals: '$C'.
	self assert: aPaneC isExpanded.

	aPaneH := self paneModelWithPhlowBuilderFor: $H.
	aPaneF := aPaneC followingPanes second.
	self assert: aPaneF title equals: '$F'.
	self assert: aPaneF isUnfastened.
	aPaneF fasten.
	self assert: aPaneF isFastened.
	aPaneC replaceFollowingPaneBy: aPaneH.

	self
		assertPager: aPager
		columnCharacterPanes: #(#($A) #($B) #($C $D) #($H $F) #($G)).
	self assert: aPaneC followingPanes size equals: 2.

	^ aPager
]

{ #category : #'examples - pager' }
GtMultiPagerExamples >> pagerWithCWithFollowingHPane [
	<gtExample>
	| aPager aPaneC aPaneH |
	aPager := self pagerWithFivePanes.
	aPaneC := (aPager columns at: 3) paneModels first.
	self assert: aPaneC title equals: '$C'.
	self assert: aPaneC isExpanded.

	aPaneH := self paneModelWithPhlowBuilderFor: $H.
	aPaneC replaceFollowingPaneBy: aPaneH.

	self assertPager: aPager columnCharacterPanes: #(#($A) #($B) #($C $D) #($E $H)).
	self assert: aPaneC followingPanes size equals: 2.

	^ aPager
]

{ #category : #'examples - pager' }
GtMultiPagerExamples >> pagerWithCollapsedCNewlyExpandedFPanes [
	<gtExample>
	| aPager aPaneF |
	aPager := self pagerWithCollapsedFCPanes.
	aPaneF := (aPager columns at: 2) paneModels first followingPanes first
			followingPanes second.
	self assert: aPaneF title equals: '$F'.
	self assert: aPaneF isCollapsed.
	aPaneF expand.
	self assert: aPaneF isExpanded.

	self assertPager: aPager columnCharacterPanes: #(#($A) #($B) #($E $F $D) #($G)).
	self assert: aPager columns third paneModels second equals: aPaneF.

	^ aPager
]

{ #category : #'examples - pager' }
GtMultiPagerExamples >> pagerWithCollapsedFCPanes [
	<gtExample>
	| aPager aPaneC |
	aPager := self pagerWithCollapsedFPane.
	aPaneC := (aPager columns at: 3) paneModels first.
	self assert: aPaneC title equals: '$C'.
	self assert: aPaneC isExpanded.
	aPaneC collapse.
	self assert: aPaneC isCollapsed.

	self assertPager: aPager columnCharacterPanes: #(#($A) #($B) #($E $G $D)).

	^ aPager
]

{ #category : #'examples - pager' }
GtMultiPagerExamples >> pagerWithCollapsedFPane [
	<gtExample>
	| aPager aPaneF |
	aPager := self pagerWithFivePanes.
	aPaneF := (aPager columns at: 4) paneModels second.
	self assert: aPaneF title equals: '$F'.
	self assert: aPaneF isExpanded.
	aPaneF collapse.
	self assert: aPaneF isCollapsed.

	self assertPager: aPager columnCharacterPanes: #(#($A) #($B) #($C $D) #($E $G)).
	self
		assert: aPager columns fourth paneModels second
		equals: aPaneF followingPanes anyOne.

	^ aPager
]

{ #category : #'examples - pager' }
GtMultiPagerExamples >> pagerWithDWithFollowingHPane [
	<gtExample>
	| aPager aPaneD aPaneH |
	aPager := self pagerWithFivePanes.
	aPaneD := (aPager columns at: 3) paneModels second.
	self assert: aPaneD title equals: '$D'.
	self assert: aPaneD isExpanded.

	aPaneH := self paneModelWithPhlowBuilderFor: $H.
	aPaneD followingPanes do: [ :each | each fasten ].
	aPaneD replaceFollowingPaneBy: aPaneH.

	self
		assertPager: aPager
		columnCharacterPanes: #(#($A) #($B) #($C $D) #($E $F $H) #($G)).

	^ aPager
]

{ #category : #'examples - pager' }
GtMultiPagerExamples >> pagerWithFivePanes [
	<gtExample>
	| aPager aPane |
	aPager := self basicPagerModel.
	aPane := self paneModelWithThreeFollowingLevels.
	aPager fromPaneModel: aPane.
	
	self assertPager: aPager columnCharacterPanes: #(#($A) #($B) #($C $D) #($E $F) #($G)).
	
	^ aPager
]

{ #category : #'examples - pager' }
GtMultiPagerExamples >> pagerWithNewlyExpandedFPane [
	<gtExample>
	| aPager aPaneF |
	aPager := self pagerWithCollapsedFPane.
	aPaneF := (aPager columns at: 3) paneModels first followingPanes second.
	self assert: aPaneF title equals: '$F'.
	self assert: aPaneF isCollapsed.
	aPaneF expand.
	self assert: aPaneF isExpanded.

	self
		assertPager: aPager
		columnCharacterPanes: #(#($A) #($B) #($C $D) #($E $F) #($G)).
	self assert: aPager columns fourth paneModels second equals: aPaneF.

	^ aPager
]

{ #category : #'examples - pager' }
GtMultiPagerExamples >> pagerWithOnePaneWithTwoTools [
	<gtExample>
	| aPager aPane |
	aPager := self basicPagerModel.
	aPane := self columnModelWithTwoPanes.
	aPager columns: {aPane}.

	^ aPager
]

{ #category : #'examples - panes' }
GtMultiPagerExamples >> paneElementWithIndex: anInteger [
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
GtMultiPagerExamples >> paneModelWithColumnedListInspector [
	<gtExample>
	| aPaneModel |
	aPaneModel := GtMultiPagerPaneModel new
			toolBuilder: self toolBuilderWithColumnedListInspector.

	self assert: (aPaneModel asElement isKindOf: BlElement).
	self assert: aPaneModel isCollapsed not.

	^ aPaneModel
]

{ #category : #'examples - panes' }
GtMultiPagerExamples >> paneModelWithElementIndexOne [
	<gtExample>
	| aToolModel |
	aToolModel := GtMultiPagerPaneModel new
			toolBuilder: self toolBuilderWithElementIndexOne.

	self assert: (aToolModel asElement isKindOf: BlElement).

	^ aToolModel
]

{ #category : #'examples - panes' }
GtMultiPagerExamples >> paneModelWithIntegerInspector [
	<gtExample>
	| aToolModel |
	aToolModel := self basicPaneModel
			toolBuilder: self toolBuilderWithIntegerInspector.

	self assert: (aToolModel asElement isKindOf: BlElement).
	self assert: aToolModel isCollapsed not.

	^ aToolModel
]

{ #category : #'examples - panes' }
GtMultiPagerExamples >> paneModelWithOneFollowingTool [
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
GtMultiPagerExamples >> paneModelWithPhlowBuilderFor: anObject [
	<gtExample>
	| aToolModel aBuilder |
	aToolModel := self basicPaneModel.
	aBuilder := self toolPhlowBuilderFor: anObject.
	aToolModel toolBuilder: aBuilder.

	self assert: aToolModel toolBuilder equals: aBuilder.
	self assert: (aToolModel asElement isKindOf: BlElement).
	self assert: aToolModel isCollapsed not.

	^ aToolModel
]

{ #category : #'examples - panes' }
GtMultiPagerExamples >> paneModelWithThreeFollowingLevels [
	<gtExample>
	| aToolB aToolA aToolC aToolD aToolE aToolF aToolG |
	aToolA := self paneModelWithPhlowBuilderFor: $A.
	aToolB := self paneModelWithPhlowBuilderFor: $B.
	aToolC := self paneModelWithPhlowBuilderFor: $C.
	aToolD := self paneModelWithPhlowBuilderFor: $D.
	aToolE := self paneModelWithPhlowBuilderFor: $E.
	aToolF := self paneModelWithPhlowBuilderFor: $F.
	aToolG := self paneModelWithPhlowBuilderFor: $G.

	aToolA addFollowingPane: aToolB.
	aToolB addFollowingPane: aToolC.
	aToolB addFollowingPane: aToolD.
	aToolC addFollowingPane: aToolE.
	aToolC addFollowingPane: aToolF.
	aToolF addFollowingPane: aToolG.

	self assert: aToolA followingPanes size equals: 1.
	self assert: aToolB followingPanes size equals: 2.
	self assert: aToolC followingPanes size equals: 2.
	self assert: aToolD followingPanes size equals: 0.
	self assert: aToolE followingPanes size equals: 0.
	self assert: aToolF followingPanes size equals: 1.
	self assert: aToolG followingPanes size equals: 0.

	^ aToolA
]

{ #category : #'examples - panes' }
GtMultiPagerExamples >> paneModelWithTwoFollowingTools [
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

{ #category : #'examples - panes' }
GtMultiPagerExamples >> toolBuilderWithColumnedListInspector [
	<gtExample>
	| aToolBuilder |
	aToolBuilder := GtMultiPagerPhlowToolBuilder new
			object: BrExamplesShowroom new columnedList.

	self assert: (aToolBuilder asElement isKindOf: BlElement).

	^ aToolBuilder
]

{ #category : #'examples - panes' }
GtMultiPagerExamples >> toolBuilderWithElementIndexOne [
	<gtExample>
	| aToolBuilder |
	aToolBuilder := GtMultiPagerExplicitToolBuilder new
			stencil: [ self paneElementWithIndex: 1 ].

	self assert: (aToolBuilder asElement isKindOf: BlElement).

	^ aToolBuilder
]

{ #category : #'examples - panes' }
GtMultiPagerExamples >> toolBuilderWithIntegerInspector [
	<gtExample>
	| aToolBuilder |
	aToolBuilder := GtMultiPagerPhlowToolBuilder new
			object: 108.

	self assert: (aToolBuilder asElement isKindOf: BlElement).

	^ aToolBuilder
]

{ #category : #'examples - panes' }
GtMultiPagerExamples >> toolPhlowBuilderFor: anObject [
	<gtExample>
	| aBuilder |
	aBuilder := GtMultiPagerPhlowToolBuilder new object: anObject.

	self assert: (aBuilder asElement isKindOf: BlElement).

	^ aBuilder
]
