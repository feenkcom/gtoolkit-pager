Class {
	#name : #GtTreePagerWithScripterExamples,
	#superclass : #Object,
	#category : #'GToolkit-TreePager-Examples'
}

{ #category : #'examples - pager' }
GtTreePagerWithScripterExamples >> pagerWithFourPanesInFourColumns [
	<gtExample>
	| aPager aScripter aPaneA |
	aPager := GtTreePagerExamples new pagerWithFourPanesInFourColumns.
	aPaneA := aPager detectPaneModel: [ :each | each title = $A printString ].

	aScripter := BlScripter new
			model: aPager;
			element: aPager asElement.

	aScripter treePager
		assertNumberOfPaneElements: 4;
		assertNumberOfVisiblePanes: 2;
		assertPaneModel: aPaneA
			position: GtTreePagerConstants cellSpacing @ GtTreePagerConstants cellSpacing;
		play.
		
	^ aScripter
]

{ #category : #'examples - pager' }
GtTreePagerWithScripterExamples >> pagerWithFourPanesInFourColumns_BCDVisiblePanes [
	<gtExample>
	| aPager aScripter aPaneA aPaneB |
	aScripter := self pagerWithFourPanesInFourColumns.
	aPager := aScripter model.
	aPaneA := aPager detectPaneModel: [ :each | each title = $A printString ].
	aPaneB := aPager detectPaneModel: [ :each | each title = $B printString ].

	aScripter treePager
		assertNumberOfPaneElements: 4;
		assertNumberOfVisiblePanes: 2;
		increaseNumberOfVisibleColumns;
		closeConfigurationDropdownMenu;
		assertNumberOfVisiblePanes: 3;
		assertPaneModel: aPaneA
			position: GtTreePagerConstants cellSpacing @ GtTreePagerConstants cellSpacing;
		previewScrollToPane: aPaneB;
		assertPaneModel: aPaneB
			position: GtTreePagerConstants cellSpacing @ GtTreePagerConstants cellSpacing;
		play.

	^ aScripter
]

{ #category : #'examples - pager' }
GtTreePagerWithScripterExamples >> pagerWithFourPanesInFourColumns_spawnFromB [
	<gtExample>
	| aPager aScripter aPaneA aPaneB |
	aScripter := self pagerWithFourPanesInFourColumns_BCDVisiblePanes.
	aPager := aScripter model.
	aPaneA := aPager detectPaneModel: [ :each | each title = $A printString ].
	aPaneB := aPager detectPaneModel: [ :each | each title = $B printString ].

	aScripter inspectorStep
		clickOnBrowseButton;
		onPaneElement: aPaneB;
		play.

	aScripter treePager
		assertNumberOfPaneElements: 3;
		assertNumberOfVisiblePanes: 3;
		flag: 'TODO: We want Pane B to remain in its position (only B and the newly spawned pane should be visible)';
		assertPaneModel: (false ifTrue: [ aPaneB ] ifFalse: [ aPaneA ])
			position: GtTreePagerConstants cellSpacing @ GtTreePagerConstants cellSpacing;
		play.

	^ aScripter
]

{ #category : #'examples - pager' }
GtTreePagerWithScripterExamples >> pagerWithSevenPanesInFiveColumns [
	<gtExample>
	| aPager aScripter aPaneA |
	aPager := GtTreePagerExamples new pagerWithSevenPanesInFiveColumns.
	aPaneA := aPager detectPaneModel: [ :each | each title = $A printString ].

	aScripter := BlScripter new
			model: aPager;
			element: aPager asElement.

	aScripter treePager
		assertNumberOfPaneElements: 7;
		assertNumberOfVisiblePanes: 2;
		assertPaneModel: aPaneA
			position: GtTreePagerConstants cellSpacing @ GtTreePagerConstants cellSpacing;
		play.

	^ aScripter
]
