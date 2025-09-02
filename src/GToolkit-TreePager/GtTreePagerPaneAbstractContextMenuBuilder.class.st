Class {
	#name : #GtTreePagerPaneAbstractContextMenuBuilder,
	#superclass : #GtTreePagerLinkAbstractContextMenuBuilder,
	#instVars : [
		'paneElement'
	],
	#category : #'GToolkit-TreePager-Support'
}

{ #category : #accessing }
GtTreePagerPaneAbstractContextMenuBuilder >> paneElement [
	^ paneElement
]

{ #category : #accessing }
GtTreePagerPaneAbstractContextMenuBuilder >> paneElement: anObject [
	paneElement := anObject
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
