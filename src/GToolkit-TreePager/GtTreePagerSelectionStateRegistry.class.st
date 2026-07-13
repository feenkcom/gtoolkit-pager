Class {
	#name : #GtTreePagerSelectionStateRegistry,
	#superclass : #Object,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#category : #'GToolkit-TreePager-Settings'
}

{ #category : #selection }
GtTreePagerSelectionStateRegistry >> emptySelection [
	<gtSelectionStateRegistryItem>
	^ GtTreePagerSelectionStateRegistryItem new
		priority: 100;
		name: 'No selection';
		description: 'I do not store nor apply selections';
		selectionState: [ GtPhlowToolEmptySelectionStateHandler new ]
]

{ #category : #accessing }
GtTreePagerSelectionStateRegistry >> items [
	| somePragmas someItems |
	somePragmas := Pragma
			allNamed: #gtSelectionStateRegistryItem
			from: self class
			to: GtTreePagerSelectionStateRegistry.

	someItems := somePragmas
			collect: [ :eachPragma | 
				[ self perform: eachPragma methodSelector ]
					onErrorDo: [ :anError | 
						GtSystemUtility
							reportCatchedException: anError
							named: 'Selection state registries'.
							
						self emptySelection ] ].

	GtPhlowUtility sortByPriority: someItems.

	^ someItems
]

{ #category : #selection }
GtTreePagerSelectionStateRegistry >> perPaneCircular [
	<gtSelectionStateRegistryItem>
	^ GtTreePagerSelectionStateRegistryItem new
		priority: 30;
		name: 'Pane circular selection';
		description: 'I store and apply selection states for individual panels';
		selectionState: [ GtPhlowToolCircularSelectionStateHandler new maxSelectionStates: 1 ]
]

{ #category : #selection }
GtTreePagerSelectionStateRegistry >> simpleSelection [
	<gtSelectionStateRegistryItem>
	^ GtTreePagerSelectionStateRegistryItem new
		priority: 70;
		name: 'Pager simple selection';
		description: 'I store and apply one selection per pager (for all panes)';
		selectionState: [ GtPhlowToolSelectionStateHandler new ]
]
