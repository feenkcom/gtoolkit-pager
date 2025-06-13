Class {
	#name : #GtMultiPagerModelExamples,
	#superclass : #Object,
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #'examples - pager' }
GtMultiPagerModelExamples >> basicPagerModel [
	<gtExample>
	| aModel |
	aModel := GtMultiPagerModel new.

	^ aModel
]

{ #category : #'examples - panes' }
GtMultiPagerModelExamples >> basicPaneModel [
	<gtExample>
	| aPane |
	aPane := GtMultiPagerPaneModel new.

	^ aPane
]

{ #category : #'examples - tools' }
GtMultiPagerModelExamples >> basicToolModel [
	<gtExample>
	| aModel |
	aModel := GtMultiPagerToolModel new.

	^ aModel
]

{ #category : #'examples - pager' }
GtMultiPagerModelExamples >> pagerWithCollapsedCNewlyExpandedFTools [
	<gtExample>
	| aPager aToolF |
	aPager := self pagerWithCollapsedFCTools.
	aToolF := (aPager panes at: 2) toolModels first followingTools first
			followingTools second.
	self assert: aToolF title equals: '$F'.
	self assert: aToolF isCollapsed.
	aToolF expand.
	self assert: aToolF isExpanded.

	self assert: aPager panes size equals: 4.
	self assert: aPager panes first toolModels size equals: 1.
	self assert: aPager panes second toolModels size equals: 1.
	self assert: aPager panes third toolModels size equals: 3.
	self assert: aPager panes fourth toolModels size equals: 1.
	self assert: aPager panes third toolModels second equals: aToolF.

	^ aPager
]

{ #category : #'examples - pager' }
GtMultiPagerModelExamples >> pagerWithCollapsedFCTools [
	<gtExample>
	| aPager aToolC |
	aPager := self pagerWithCollapsedFTool.
	aToolC := (aPager panes at: 3) toolModels first.
	self assert: aToolC title equals: '$C'.
	self assert: aToolC isExpanded.
	aToolC collapse.
	self assert: aToolC isCollapsed.

	self assert: aPager panes size equals: 3.
	self assert: aPager panes first toolModels size equals: 1.
	self assert: aPager panes second toolModels size equals: 1.
	self assert: aPager panes third toolModels size equals: 3.

	^ aPager
]

{ #category : #'examples - pager' }
GtMultiPagerModelExamples >> pagerWithCollapsedFTool [
	<gtExample>
	| aPager aToolF |
	aPager := self pagerWithFivePanes.
	aToolF := (aPager panes at: 4) toolModels second.
	self assert: aToolF title equals: '$F'.
	self assert: aToolF isExpanded.
	aToolF collapse.
	self assert: aToolF isCollapsed.

	self assert: aPager panes size equals: 4.
	self assert: aPager panes first toolModels size equals: 1.
	self assert: aPager panes second toolModels size equals: 1.
	self assert: aPager panes third toolModels size equals: 2.
	self assert: aPager panes fourth toolModels size equals: 2.
	self
		assert: aPager panes fourth toolModels second
		equals: aToolF followingTools anyOne.

	^ aPager
]

{ #category : #'examples - pager' }
GtMultiPagerModelExamples >> pagerWithFivePanes [
	<gtExample>
	| aPager aTool |
	aPager := self basicPagerModel.
	aTool := self toolModelWithThreeFollowingLevels.
	aPager fromToolModel: aTool.
	
	self assert: aPager panes size equals: 5.
	self assert: aPager panes first toolModels size equals: 1.
	self assert: aPager panes second toolModels size equals: 1.
	self assert: aPager panes third toolModels size equals: 2.
	self assert: aPager panes fourth toolModels size equals: 2.
	self assert: aPager panes fifth toolModels size equals: 1.
	
	^ aPager
]

{ #category : #'examples - pager' }
GtMultiPagerModelExamples >> pagerWithNewlyExpandedFTool [
	<gtExample>
	| aPager aToolF |
	aPager := self pagerWithCollapsedFTool.
	aToolF := (aPager panes at: 3) toolModels first followingTools second.
	self assert: aToolF title equals: '$F'.
	self assert: aToolF isCollapsed.
	aToolF expand.
	self assert: aToolF isExpanded.

	self assert: aPager panes size equals: 5.
	self assert: aPager panes first toolModels size equals: 1.
	self assert: aPager panes second toolModels size equals: 1.
	self assert: aPager panes third toolModels size equals: 2.
	self assert: aPager panes fourth toolModels size equals: 2.
	self assert: aPager panes fifth toolModels size equals: 1.
	self assert: aPager panes fourth toolModels second equals: aToolF.

	^ aPager
]

{ #category : #'examples - pager' }
GtMultiPagerModelExamples >> pagerWithOnePaneWithTwoTools [
	<gtExample>
	| aPager aPane |
	aPager := self basicPagerModel.
	aPane := self paneModelWithTwoTools.
	aPager panes: { aPane }.

	^ aPager
]

{ #category : #'examples - panes' }
GtMultiPagerModelExamples >> paneModelWithOneElementIndexOneTool [
	<gtExample>
	| aPane |
	aPane := self basicPaneModel.
	aPane
		title: 'Pane 1';
		toolModel: self toolModelWithElementIndexOne.

	^ aPane
]

{ #category : #'examples - panes' }
GtMultiPagerModelExamples >> paneModelWithOneFollowingTool [
	<gtExample>
	| aPane |
	aPane := self basicPaneModel.
	aPane
		title: 'Pane 1';
		toolModel: self toolModelWithOneFollowingTool.

	^ aPane
]

{ #category : #'examples - panes' }
GtMultiPagerModelExamples >> paneModelWithTwoFollowingTools [
	<gtExample>
	| aPane |
	aPane := self basicPaneModel.
	aPane
		title: 'Pane 1';
		toolModel: self toolModelWithTwoFollowingTools.
		
	aPane toolModels first followingTools second collapse.
	self assert: aPane toolModels first followingTools second isCollapsed.

	^ aPane
]

{ #category : #'examples - panes' }
GtMultiPagerModelExamples >> paneModelWithTwoTools [
	<gtExample>
	| aPane |
	aPane := self basicPaneModel.
	aPane
		title: 'Pane 1';
		toolModel: self toolModelWithElementIndexOne;
		toolModel: self toolModelWithIntegerInspector.

	^ aPane
]

{ #category : #'examples - tools' }
GtMultiPagerModelExamples >> toolBuilderWithColumnedListInspector [
	<gtExample>
	| aToolBuilder |
	aToolBuilder := GtMultiPagerPhlowToolBuilder new
			object: BrExamplesShowroom new columnedList.

	self assert: (aToolBuilder asElement isKindOf: BlElement).

	^ aToolBuilder
]

{ #category : #'examples - tools' }
GtMultiPagerModelExamples >> toolBuilderWithElementIndexOne [
	<gtExample>
	| aToolBuilder |
	aToolBuilder := GtMultiPagerExplicitToolBuilder new
			stencil: [ self toolElementWithIndex: 1 ].

	self assert: (aToolBuilder asElement isKindOf: BlElement).

	^ aToolBuilder
]

{ #category : #'examples - tools' }
GtMultiPagerModelExamples >> toolBuilderWithIntegerInspector [
	<gtExample>
	| aToolBuilder |
	aToolBuilder := GtMultiPagerPhlowToolBuilder new
			object: 108.

	self assert: (aToolBuilder asElement isKindOf: BlElement).

	^ aToolBuilder
]

{ #category : #'examples - tools' }
GtMultiPagerModelExamples >> toolElementWithIndex: anInteger [
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

{ #category : #'examples - tools' }
GtMultiPagerModelExamples >> toolModelWithColumnedListInspector [
	<gtExample>
	| aToolModel |
	aToolModel := GtMultiPagerToolModel new
			toolBuilder: self toolBuilderWithColumnedListInspector.

	self assert: (aToolModel asElement isKindOf: BlElement).
	self assert: aToolModel isCollapsed not.

	^ aToolModel
]

{ #category : #'examples - tools' }
GtMultiPagerModelExamples >> toolModelWithElementIndexOne [
	<gtExample>
	| aToolModel |
	aToolModel := GtMultiPagerToolModel new
			toolBuilder: self toolBuilderWithElementIndexOne.

	self assert: (aToolModel asElement isKindOf: BlElement).

	^ aToolModel
]

{ #category : #'examples - tools' }
GtMultiPagerModelExamples >> toolModelWithIntegerInspector [
	<gtExample>
	| aToolModel |
	aToolModel := self basicToolModel
			toolBuilder: self toolBuilderWithIntegerInspector.

	self assert: (aToolModel asElement isKindOf: BlElement).
	self assert: aToolModel isCollapsed not.

	^ aToolModel
]

{ #category : #'examples - tools' }
GtMultiPagerModelExamples >> toolModelWithOneFollowingTool [
	<gtExample>
	| aToolTwo aToolOne |
	aToolOne := self toolModelWithColumnedListInspector.
	aToolTwo := self toolModelWithIntegerInspector.

	aToolOne addFollowingTool: aToolTwo.

	self assert: aToolOne followingTools size equals: 1.
	self assert: aToolOne followingTools first equals: aToolTwo.
	self assert: aToolTwo previousTool equals: aToolOne.

	^ aToolOne
]

{ #category : #'examples - tools' }
GtMultiPagerModelExamples >> toolModelWithPhlowBuilderFor: anObject [
	<gtExample>
	| aToolModel aBuilder |
	aToolModel := self basicToolModel.
	aBuilder := self toolPhlowBuilderFor: anObject.
	aToolModel toolBuilder: aBuilder.

	self assert: aToolModel toolBuilder equals: aBuilder.
	self assert: (aToolModel asElement isKindOf: BlElement).
	self assert: aToolModel isCollapsed not.

	^ aToolModel
]

{ #category : #'examples - tools' }
GtMultiPagerModelExamples >> toolModelWithThreeFollowingLevels [
	<gtExample>
	| aToolB aToolA aToolC aToolD aToolE aToolF aToolG |
	aToolA := self toolModelWithPhlowBuilderFor: $A.
	aToolB := self toolModelWithPhlowBuilderFor: $B.
	aToolC := self toolModelWithPhlowBuilderFor: $C.
	aToolD := self toolModelWithPhlowBuilderFor: $D.
	aToolE := self toolModelWithPhlowBuilderFor: $E.
	aToolF := self toolModelWithPhlowBuilderFor: $F.
	aToolG := self toolModelWithPhlowBuilderFor: $G.

	aToolA addFollowingTool: aToolB.
	aToolB addFollowingTool: aToolC.
	aToolB addFollowingTool: aToolD.
	aToolC addFollowingTool: aToolE.
	aToolC addFollowingTool: aToolF.
	aToolF addFollowingTool: aToolG.

	self assert: aToolA followingTools size equals: 1.
	self assert: aToolB followingTools size equals: 2.
	self assert: aToolC followingTools size equals: 2.
	self assert: aToolD followingTools size equals: 0.
	self assert: aToolE followingTools size equals: 0.
	self assert: aToolF followingTools size equals: 1.
	self assert: aToolG followingTools size equals: 0.

	^ aToolA
]

{ #category : #'examples - tools' }
GtMultiPagerModelExamples >> toolModelWithTwoFollowingTools [
	<gtExample>
	| aToolTwo aToolOne aToolThree |
	aToolOne := self toolModelWithColumnedListInspector.
	aToolTwo := self toolModelWithIntegerInspector.
	aToolThree := self toolModelWithPhlowBuilderFor: 42 / 108.

	aToolOne addFollowingTool: aToolTwo.
	aToolOne addFollowingTool: aToolThree.

	self assert: aToolOne followingTools size equals: 2.
	self assert: aToolOne followingTools first equals: aToolTwo.
	self assert: aToolTwo previousTool equals: aToolOne.
	self assert: aToolOne followingTools second equals: aToolThree.
	self assert: aToolThree previousTool equals: aToolOne.

	^ aToolOne
]

{ #category : #'examples - tools' }
GtMultiPagerModelExamples >> toolPhlowBuilderFor: anObject [
	<gtExample>
	| aBuilder |
	aBuilder := GtMultiPagerPhlowToolBuilder new object: anObject.

	self assert: (aBuilder asElement isKindOf: BlElement).

	^ aBuilder
]
