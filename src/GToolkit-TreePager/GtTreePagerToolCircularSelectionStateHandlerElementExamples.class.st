Class {
	#name : #GtTreePagerToolCircularSelectionStateHandlerElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-TreePager-Examples'
}

{ #category : #examples }
GtTreePagerToolCircularSelectionStateHandlerElementExamples >> elementDecreaseButtonUpdatesHandlerAndLabel [
	<gtExample>
	<return: #GtTreePagerToolCircularSelectionStateHandlerElement>
	| aHandler anElement |
	aHandler := GtPhlowToolCircularSelectionStateHandler new maxSelectionStates: 2.
	aHandler
		addSelectionState: (GtPhlowTabbedToolSelectionState new
				tabIdentifier: (GtPhlowTabName new string: 'Preview'));
		addSelectionState: (GtPhlowTabbedToolSelectionState new
				tabIdentifier: (GtPhlowTabName new string: 'Items')).
	anElement := GtTreePagerToolCircularSelectionStateHandlerElement new
			selectionStateHandler: aHandler.

	anElement onDecreaseMaxSelectionStatesFrom: nil.
	self assert: aHandler maxSelectionStates equals: 1.
	self assert: aHandler numberOfSelectionStates equals: 1.
	self
		assert: (anElement
				childWithId: #'tree-pager--tool-circular-selection-state-handler-value')
				text asString
		equals: '1/1'.
	^ anElement
]

{ #category : #examples }
GtTreePagerToolCircularSelectionStateHandlerElementExamples >> elementUpdatesOnMaxSelectionStatesAnnouncement [
	<gtExample>
	<return: #GtTreePagerToolCircularSelectionStateHandlerElement>
	| aHandler anElement aLabel |
	aHandler := GtPhlowToolCircularSelectionStateHandler new maxSelectionStates: 3.
	aHandler
		addSelectionState: (GtPhlowTabbedToolSelectionState new
				tabIdentifier: (GtPhlowTabName new string: 'Preview'));
		addSelectionState: (GtPhlowTabbedToolSelectionState new
				tabIdentifier: (GtPhlowTabName new string: 'Items')).
	anElement := GtTreePagerToolCircularSelectionStateHandlerElement new
			selectionStateHandler: aHandler.
	aLabel := anElement
			childWithId: #'tree-pager--tool-circular-selection-state-handler-value'.
	self assert: aLabel text asString equals: '2/3'.

	aHandler maxSelectionStates: 5.
	self assert: aLabel text asString equals: '2/5'.
	^ anElement
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
