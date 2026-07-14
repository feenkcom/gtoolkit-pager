Class {
	#name : #GtTreePagerPerPaneSelectionStateHandlerElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-TreePager-Examples'
}

{ #category : #examples }
GtTreePagerPerPaneSelectionStateHandlerElementExamples >> element [
	<gtExample>
	<return: #GtTreePagerPerPaneSelectionStateHandlerElement>
	| aSelectionStateHandler anElement aLabel aChildElement anInspectButton aScripter |
	aSelectionStateHandler := self selectionStateHandler.
	anElement := GtTreePagerPerPaneSelectionStateHandlerElement new
		selectionStateHandler: aSelectionStateHandler.

	self assert: anElement selectionStateHandler equals: aSelectionStateHandler.
	self assert: anElement hasSelectionStateHandler.
	self assert: anElement children size equals: 3.

	aLabel := anElement childWithId: #'tree-pager--per-pane-selection-state-handler-label'.
	self assert: aLabel text asString equals: 'Per pane selections'.

	aChildElement := anElement children third.
	self
		assert: aChildElement class
		equals: GtTreePagerToolCircularSelectionStateHandlerElement.

	anInspectButton := anElement childWithId: #'tree-pager--per-pane-selection-state-handler-inspect-button'.
	self assert: anInspectButton notNil.

	aScripter := BlScripter new
		model: aSelectionStateHandler;
		element: anElement.

	^ aScripter
]

{ #category : #examples }
GtTreePagerPerPaneSelectionStateHandlerElementExamples >> selectionStateHandler [
	<gtExample>
	<return: #GtTreePagerPerPaneSelectionStateHandler>
	^ GtTreePagerPerPaneSelectionStateHandler new
]
