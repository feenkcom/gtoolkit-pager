Class {
	#name : #GtTreePagerToolCircularSelectionStateHandlerElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-TreePager-Examples'
}

{ #category : #examples }
GtTreePagerToolCircularSelectionStateHandlerElementExamples >> elementAddSelectionStateUpdatesLabel [
	<gtExample>
	<return: #GtTreePagerToolCircularSelectionStateHandlerElement>
	| aHandler anElement aLabel aScripter |
	aHandler := GtPhlowToolCircularSelectionStateHandler new maxSelectionStates: 3.
	anElement := GtTreePagerToolCircularSelectionStateHandlerElement new
			selectionStateHandler: aHandler.
	aScripter := BlScripter new
			model: aHandler;
			element: anElement.
	aLabel := anElement
			childWithId: #'tree-pager--tool-circular-selection-state-handler-value'.

	self assert: aLabel text asString equals: '0/3'.

	aScripter do
		block: [ aHandler
				addSelectionState: (GtPhlowTabbedToolSelectionState new
						tabIdentifier: (GtPhlowTabName new string: 'Preview')) ];
		play.
	self assert: aLabel text asString equals: '1/3'.
	aScripter do
		block: [ aHandler
				addSelectionState: (GtPhlowTabbedToolSelectionState new
						tabIdentifier: (GtPhlowTabName new string: 'Items')) ];
		play.
	self assert: aLabel text asString equals: '2/3'.

	^ aScripter
]

{ #category : #examples }
GtTreePagerToolCircularSelectionStateHandlerElementExamples >> elementDecreaseButtonUpdatesHandlerAndLabel [
	<gtExample>
	<return: #GtTreePagerToolCircularSelectionStateHandlerElement>
	| aHandler anElement aScripter |
	aHandler := GtPhlowToolCircularSelectionStateHandler new maxSelectionStates: 2.
	aHandler
		addSelectionState: (GtPhlowTabbedToolSelectionState new
				tabIdentifier: (GtPhlowTabName new string: 'Preview'));
		addSelectionState: (GtPhlowTabbedToolSelectionState new
				tabIdentifier: (GtPhlowTabName new string: 'Items')).
	anElement := GtTreePagerToolCircularSelectionStateHandlerElement new
			selectionStateHandler: aHandler.
	aScripter := BlScripter new
			model: aHandler;
			element: anElement.

	aScripter do
		block: [ anElement onDecreaseMaxSelectionStatesFrom: nil ];
		play.
	self assert: aHandler maxSelectionStates equals: 1.
	self assert: aHandler numberOfSelectionStates equals: 1.
	self
		assert: (anElement
				childWithId: #'tree-pager--tool-circular-selection-state-handler-value')
				text asString
		equals: '1/1'.
	^ aScripter
]

{ #category : #examples }
GtTreePagerToolCircularSelectionStateHandlerElementExamples >> elementUpdatesOnMaxSelectionStatesAnnouncement [
	<gtExample>
	<return: #GtTreePagerToolCircularSelectionStateHandlerElement>
	| aHandler anElement aLabel aScripter |
	aHandler := GtPhlowToolCircularSelectionStateHandler new maxSelectionStates: 3.
	aHandler
		addSelectionState: (GtPhlowTabbedToolSelectionState new
				tabIdentifier: (GtPhlowTabName new string: 'Preview'));
		addSelectionState: (GtPhlowTabbedToolSelectionState new
				tabIdentifier: (GtPhlowTabName new string: 'Items')).
	anElement := GtTreePagerToolCircularSelectionStateHandlerElement new
			selectionStateHandler: aHandler.
	aScripter := BlScripter new
			model: aHandler;
			element: anElement.

	aLabel := anElement
			childWithId: #'tree-pager--tool-circular-selection-state-handler-value'.
	self assert: aLabel text asString equals: '2/3'.

	aScripter do
		block: [ aHandler maxSelectionStates: 5 ];
		play.
	self assert: aLabel text asString equals: '2/5'.
	^ aScripter
]

{ #category : #examples }
GtTreePagerToolCircularSelectionStateHandlerElementExamples >> handlerShrinksSelectionStatesOnDecrease [
	<gtExample>
	<return: #GtPhlowToolCircularSelectionStateHandler>
	| aHandler |
	aHandler := GtPhlowToolCircularSelectionStateHandler new maxSelectionStates: 3.
	aHandler
		addSelectionState: (GtPhlowTabbedToolSelectionState new
				tabIdentifier: (GtPhlowTabName new string: 'Preview'));
		addSelectionState: (GtPhlowTabbedToolSelectionState new
				tabIdentifier: (GtPhlowTabName new string: 'Items'));
		addSelectionState: (GtPhlowTabbedToolSelectionState new
				tabIdentifier: (GtPhlowTabName new string: 'Integer')).
	self assert: aHandler numberOfSelectionStates equals: 3.

	aHandler maxSelectionStates: 2.
	self assert: aHandler maxSelectionStates equals: 2.
	self assert: aHandler numberOfSelectionStates equals: 2.
	^ aHandler
]
