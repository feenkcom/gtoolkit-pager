Class {
	#name : #GtTreePagerPaneAbstractContextMenuBuilder,
	#superclass : #GtTreePagerLinkAbstractContextMenuBuilder,
	#instVars : [
		'paneElement'
	],
	#category : #'GToolkit-TreePager-Support'
}

{ #category : #actions }
GtTreePagerPaneAbstractContextMenuBuilder >> gtOpenInNewWindowActionFor: anAction [
	<gtAction>
	^ anAction button
		tooltip: 'Open pane in new window';
		icon: BrGlamorousVectorIcons link;
		target: GtTreePagerPaneNormalTopRightToolbarTarget default;
		addTarget: GtTreePagerPaneMaximizedTopRightToolbarTarget default;
		action: [ :aButton | 
			BlSpace new
				title: self paneModel title;
				paneInTreePager: self paneModel similarPaneCopy
					settings: self paneModel pagerSettings;
				showInGtWorld ]
]

{ #category : #accessing }
GtTreePagerPaneAbstractContextMenuBuilder >> paneElement [
	^ paneElement
]

{ #category : #accessing }
GtTreePagerPaneAbstractContextMenuBuilder >> paneElement: anObject [
	paneElement := anObject
]

{ #category : #building }
GtTreePagerPaneAbstractContextMenuBuilder >> topRightActionElements [
	<return: #Collection of: #BlElement>
	^ self topRightActions collect: [ :eachPhlowAction | 
		eachPhlowAction
			asCircularElement: [ :anElement | 
				anElement viewModel ifNil: [ anElement viewModel: BrWidgetModel new ].
				anElement ]
			withHostElement: self paneElement ]
]

{ #category : #building }
GtTreePagerPaneAbstractContextMenuBuilder >> topRightActions [
	<return: #Collection of: #GtPhlowAction>
	^ self gtActions select: [ :eachAction | 
		eachAction target isForTarget: GtTreePagerPaneNormalTopRightToolbarTarget default ]
]

{ #category : #visiting }
GtTreePagerPaneAbstractContextMenuBuilder >> visitGtTreePagerLinkActiveSpawnedState: aState [
	self linkModel depthIndex = 1
		ifFalse: [ 
			menu addItem: self newCollapseOrSelectPaneActionItem.
			self mayAddHideLinkActionItem. ].
	self linkModel depthIndex > 1 ifTrue: [ 
		menu addItem: self newRemoveLinkActionItem ].
	menu addItem: self newMaximizePaneActionItem.
	menu addItem: self newWorldTabActionItem.
	menu addItem: self newRebuildPaneToolElementActionItem
]

{ #category : #visiting }
GtTreePagerPaneAbstractContextMenuBuilder >> visitGtTreePagerLinkInactiveSpawnedState: aState [
	self linkModel depthIndex = 1 ifFalse: [ 
		menu addItem: self newCollapseOrSelectPaneActionItem.
		self mayAddHideLinkActionItem. ].
	self linkModel depthIndex > 1 ifTrue: [ 
		menu addItem: self newRemoveLinkActionItem ].
	menu addItem: self newMaximizePaneActionItem.
	menu addItem: self newWorldTabActionItem.
	menu addItem: self newRebuildPaneToolElementActionItem
]

{ #category : #visiting }
GtTreePagerPaneAbstractContextMenuBuilder >> visitGtTreePagerLinkState: aState [
	menu addItem: self newWorldTabActionItem.
	menu addItem: self newRebuildPaneToolElementActionItem.
	self linkModel depthIndex > 1 ifTrue: [
		menu addItem: self newRemoveLinkActionItem ]
]
