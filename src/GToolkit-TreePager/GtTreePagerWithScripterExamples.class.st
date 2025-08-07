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
	| aPager aScripter aPaneA |
	aScripter := self pagerWithFourPanesInFourColumns.
	aPager := aScripter model.
	aPaneA := aPager detectPaneModel: [ :each | each title = $A printString ].

	aScripter treePager
		assertNumberOfPaneElements: 4;
		assertNumberOfVisiblePanes: 2;
		increaseNumberOfVisibleColumns;
		closeConfigurationDropdownMenu;
		assertNumberOfVisiblePanes: 3;
		assertPaneModel: aPaneA
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
