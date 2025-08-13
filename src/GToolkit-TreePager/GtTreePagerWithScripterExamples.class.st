Class {
	#name : #GtTreePagerWithScripterExamples,
	#superclass : #Object,
	#instVars : [
		'semaphore'
	],
	#category : #'GToolkit-TreePager-Examples'
}

{ #category : #'as yet unclassified' }
GtTreePagerWithScripterExamples >> closePageWithPendingFuture [
	<gtExample>
	<after: #signalSemaphor>
	<return: #BlScripter>
	| scripter paneModel paneElement childElement toolElement eventHandler future futureStarted futureScheduled futureResult hasEventHandler |
	scripter := self pagerWithFourPanesInFourColumns.

	futureResult := nil.
	futureStarted := false.
	futureScheduled := false.
	semaphore := Semaphore new.

	future := [ futureStarted := true.
		semaphore wait.
		true ] asAsyncFuture.
	paneModel := scripter model detectPaneModel: [ :eachPane | eachPane title = $B printString].
	paneElement := (scripter element query // GtTreePagerPaneElement @ [ :eachElement | eachElement paneModel = paneModel ]) anyOne.
	childElement := (paneElement query // GtPhlowCompositeViewElementId) anyOne.

	childElement
		withAsyncFutureDo: [ :anElementFuture | 
			anElementFuture
				shouldFireScheduledEvent: true;
				whenSuccess: [ :anElement :aFutureResult | futureResult := aFutureResult ];
				whenPending: [ :anElement :anInitialValue | futureResult := anInitialValue ];
				whenError: [ :anElement :anError | futureResult := anError ] ].

	paneElement
		when: BrAsyncElementFutureScheduledEvent
		do: [ futureScheduled := true ].

	scripter do
		action: [ childElement asyncFuture future: future ];
		playNoPulse.

	[ 20 milliSeconds wait.
	futureStarted and: [ futureScheduled ] ] whileFalse: [ scripter pulse ].

	toolElement := paneElement toolElement.
	hasEventHandler := toolElement eventDispatcher hasEventHandlerSuchThat: [ :eachEventHandler | 
		| result |
		result := eachEventHandler class = BrAsyncElementFutureScheduledEventHandler.
		result ifTrue: [ eventHandler := eachEventHandler ].
		result ].
	self assert: hasEventHandler.
	scripter userData at: #pendingFuturePromises put: eventHandler pendingFuturePromises.
	self assert: eventHandler pendingFuturePromises size equals: 1.

	scripter doStep: [ :s | s action: [ :anElement | paneModel removeFromPreviousPane ] ].

	self assert: eventHandler pendingFuturePromises size equals: 0.
	
	"because an element was removed from the scene graph, an update is not scheduled, therefore
	whenError: block is not executed, it is expected and actually quite nice"
	self assert: futureResult isNil.
	semaphore signal.

	^ scripter
]

{ #category : #'examples - pager' }
GtTreePagerWithScripterExamples >> pagerWithFourPanesInFourColumns [
	<gtExample>
	| aPager aScripter aPaneA aPaneB |
	aPager := GtTreePagerExamples new pagerWithFourPanesInFourColumns.
	aPaneA := aPager detectPaneModel: [ :each | each title = $A printString ].
	aPaneB := aPager detectPaneModel: [ :each | each title = $B printString ].

	aScripter := BlScripter new
			model: aPager;
			element: aPager asElement.

	aScripter treePager
		assertNumberOfPaneElements: 4;
		assertNumberOfVisiblePanes: 2;
		assertPaneModel: aPaneA position: GtTreePagerConstants cellSpacing;
		assertNumberOfEdgeElements: 3;
		assertNumberOfCollapsedRectangleLinkElements: 0;
		assertNumberOfCollapsedTriangleLinkElements: 0;
		assertNumberOfSpawnedTriangleLinkElements: 3;
		assertNumberOfSpawnedNormalTriangleLinkElements: 3;
		assertNumberOfSpawnedSmallTriangleLinkElements: 0;
		assertSpawnedTriangleLinkModel: aPaneB previousLink;
		assertEdgeElementsPositions;
		play.

	^ aScripter
]

{ #category : #'examples - pager' }
GtTreePagerWithScripterExamples >> pagerWithFourPanesInFourColumns_BCDVisiblePanes [
	<gtExample>
	| aPager aScripter aPaneA aPaneB aPaneC |
	aScripter := self pagerWithFourPanesInFourColumns.
	aPager := aScripter model.
	aPaneA := aPager detectPaneModel: [ :each | each title = $A printString ].
	aPaneB := aPager detectPaneModel: [ :each | each title = $B printString ].
	aPaneC := aPager detectPaneModel: [ :each | each title = $C printString ].

	aScripter treePager
		assertNumberOfPaneElements: 4;
		assertNumberOfVisiblePanes: 2;
		increaseNumberOfVisibleColumns;
		closeConfigurationDropdownMenu;
		assertNumberOfVisiblePanes: 3;
		assertPaneModel: aPaneA position: GtTreePagerConstants cellSpacing;
		assertEdgeElementsPositions;
		previewScrollToPane: aPaneB;
		assertPaneModel: aPaneB position: GtTreePagerConstants cellSpacing;
		assertNumberOfEdgeElements: 3;
		assertNumberOfCollapsedRectangleLinkElements: 0;
		assertNumberOfCollapsedTriangleLinkElements: 0;
		assertNumberOfSpawnedTriangleLinkElements: 3;
		assertNumberOfSpawnedNormalTriangleLinkElements: 3;
		assertNumberOfSpawnedSmallTriangleLinkElements: 0;
		assertSpawnedTriangleLinkModel: aPaneB previousLink;
		assertSpawnedTriangleLinkModel: aPaneC previousLink;
		assertEdgeElementsPositions;
		play.

	^ aScripter
]

{ #category : #'examples - pager' }
GtTreePagerWithScripterExamples >> pagerWithFourPanesInFourColumns_collapseC [
	<gtExample>
	| aPager aScripter aPaneA aPaneB aPaneC |
	aScripter := self pagerWithFourPanesInFourColumns_BCDVisiblePanes.
	aPager := aScripter model.
	aPaneA := aPager detectPaneModel: [ :each | each title = $A printString ].
	aPaneB := aPager detectPaneModel: [ :each | each title = $B printString ].
	aPaneC := aPager detectPaneModel: [ :each | each title = $C printString ].

	aScripter treePager
		hoverPaneModel: aPaneC;
		openDropdownPaneModel: aPaneC;
		clickDropdownCollapseMenuItem;
		assertNumberOfPaneElements: 3;
		assertNumberOfVisiblePanes: 3;
		flag: 'TODO: We want Pane B to remain in its position (only B and D should be visible)';
		assertPaneModel: (false ifTrue: [ aPaneB ] ifFalse: [ aPaneA ])
			position: GtTreePagerConstants cellSpacing;
		assertNumberOfEdgeElements: 2;
		assertNumberOfCollapsedRectangleLinkElements: 1;
		assertNumberOfCollapsedTriangleLinkElements: 1;
		assertNumberOfSpawnedTriangleLinkElements: 2;
		assertNumberOfSpawnedNormalTriangleLinkElements: 1;
		assertNumberOfSpawnedSmallTriangleLinkElements: 1;
		assertCollapsedRectangleLinkModel: aPaneC previousLink;
		assertSpawnedTriangleLinkModel: aPaneB previousLink;
		assertEdgeElementsPositions;
		play.

	^ aScripter
]

{ #category : #'examples - pager' }
GtTreePagerWithScripterExamples >> pagerWithFourPanesInFourColumns_collapseD [
	<gtExample>
	| aPager aScripter aPaneA aPaneB aPaneD |
	aScripter := self pagerWithFourPanesInFourColumns_BCDVisiblePanes.
	aPager := aScripter model.
	aPaneA := aPager detectPaneModel: [ :each | each title = $A printString ].
	aPaneB := aPager detectPaneModel: [ :each | each title = $B printString ].
	aPaneD := aPager detectPaneModel: [ :each | each title = $D printString ].

	aScripter treePager
		hoverPaneModel: aPaneD;
		openDropdownPaneModel: aPaneD;
		clickDropdownCollapseMenuItem;
		assertNumberOfPaneElements: 3;
		assertNumberOfVisiblePanes: 3;
		flag: 'TODO: We want Pane B to remain in its position (only B and C should be visible)';
		assertPaneModel: (false ifTrue: [ aPaneB ] ifFalse: [ aPaneA ])
			position: GtTreePagerConstants cellSpacing;
		assertNumberOfEdgeElements: 2;
		assertNumberOfCollapsedRectangleLinkElements: 1;
		assertNumberOfCollapsedTriangleLinkElements: 1;
		assertNumberOfSpawnedTriangleLinkElements: 2;
		assertCollapsedRectangleLinkModel: aPaneD previousLink;
		assertEdgeElementsPositions;
		play.

	^ aScripter
]

{ #category : #'examples - pager' }
GtTreePagerWithScripterExamples >> pagerWithFourPanesInFourColumns_dropdownIcon [
	<gtExample>
	<noTest>
	| aPager aScripter aPaneA aPaneB aPaneC |
	aScripter := self pagerWithFourPanesInFourColumns.
	aPager := aScripter model.
	aPaneA := aPager detectPaneModel: [ :each | each title = $A printString ].
	aPaneB := aPager detectPaneModel: [ :each | each title = $B printString ].
	aPaneC := aPager detectPaneModel: [ :each | each title = $C printString ].

	aScripter treePager
		hoverPaneModel: aPaneB;
		assertDropdownButtonIsHiddenInPaneModel: aPaneA;
		assertDropdownButtonIsVisibleInPaneModel: aPaneB;
		assertDropdownButtonHasDefaultIconInPaneModel: aPaneB;
		play.

	aScripter keyDown
		key: BlKeyboardKey primaryLeft;
		play.

	aScripter treePager
		assertDropdownButtonHasCollapseIconInPaneModel: aPaneB;
		play.

	aScripter keyDown
		key: BlKeyboardKey shiftLeft;
		play.

	aScripter treePager
		assertDropdownButtonHasMaximizeIconInPaneModel: aPaneB;
		play.
		
	aScripter keyUp
		key: BlKeyboardKey shiftLeft;
		play.
		
	aScripter treePager
		assertDropdownButtonHasCollapseIconInPaneModel: aPaneB;
		play.
		
	aScripter keyUp
		key: BlKeyboardKey primaryLeft;
		play.
		
	aScripter treePager
		assertDropdownButtonHasDefaultIconInPaneModel: aPaneB;
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

	GtTreePagerAnimationFeatures
		disableDuring: [ aScripter inspectorStep
				clickOnBrowseButton;
				onPaneModel: aPaneB;
				play ].

	aScripter treePager
		assertNumberOfPaneElements: 3;
		assertNumberOfVisiblePanes: 3;
		flag: 'TODO: We want Pane B to remain in its position (only B and the newly spawned pane should be visible)';
		assertPaneModel: (false ifTrue: [ aPaneB ] ifFalse: [ aPaneA ])
			position: GtTreePagerConstants cellSpacing;
		assertNumberOfEdgeElements: 2;
		assertNumberOfCollapsedRectangleLinkElements: 0;
		assertNumberOfCollapsedTriangleLinkElements: 0;
		assertNumberOfSpawnedTriangleLinkElements: 2;
		assertEdgeElementsPositions;
		play.

	^ aScripter
]

{ #category : #'examples - pager' }
GtTreePagerWithScripterExamples >> pagerWithSevenPanesInFiveColumns [
	<gtExample>
	| aPager aScripter aPaneA aPaneB |
	aPager := GtTreePagerExamples new pagerWithSevenPanesInFiveColumns.
	aPaneA := aPager detectPaneModel: [ :each | each title = $A printString ].
	aPaneB := aPager detectPaneModel: [ :each | each title = $B printString ].

	aScripter := BlScripter new
			model: aPager;
			element: aPager asElement.

	aScripter treePager
		assertNumberOfPaneElements: 7;
		assertNumberOfVisiblePanes: 2;
		assertPaneModel: aPaneA position: GtTreePagerConstants cellSpacing;
		assertNumberOfEdgeElements: 6;
		assertNumberOfCollapsedRectangleLinkElements: 0;
		assertNumberOfCollapsedTriangleLinkElements: 0;
		assertNumberOfSpawnedTriangleLinkElements: 6;
		assertNumberOfSpawnedNormalTriangleLinkElements: 6;
		assertNumberOfSpawnedSmallTriangleLinkElements: 0;
		assertSpawnedTriangleLinkModel: aPaneB previousLink;
		assertEdgeElementsPositions;
		play.

	^ aScripter
]

{ #category : #support }
GtTreePagerWithScripterExamples >> signalSemaphor [
	semaphore ifNotNil: #signal
]
