Class {
	#name : #GtTreePagerPaneAbstractContextMenuBuilder,
	#superclass : #GtTreePagerLinkAbstractContextMenuBuilder,
	#category : #'GToolkit-TreePager-Support'
}

{ #category : #visiting }
GtTreePagerPaneAbstractContextMenuBuilder >> visitGtTreePagerLinkActiveSpawnedState: aState [
	menu addItem: self newMaximizePaneActionItem.
	self linkModel depthIndex = 1
		ifFalse: [ 
			menu addItem: self newCollapseOrSelectPaneActionItem.
			self mayAddHideLinkActionItem. ].
	menu addItem: self newWorldTabActionItem.
	menu addItem: self newRebuildPaneToolElementActionItem.
	self linkModel depthIndex > 1
		ifTrue: [ menu addItem: self newRemoveLinkActionItem ]
]

{ #category : #visiting }
GtTreePagerPaneAbstractContextMenuBuilder >> visitGtTreePagerLinkInactiveSpawnedState: aState [
	menu addItem: self newMaximizePaneActionItem.
	self linkModel depthIndex = 1
		ifFalse: [ 
			menu addItem: self newCollapseOrSelectPaneActionItem.
			self mayAddHideLinkActionItem. ].
	menu addItem: self newWorldTabActionItem.
	menu addItem: self newRebuildPaneToolElementActionItem.
	self linkModel depthIndex > 1
		ifTrue: [ menu addItem: self newRemoveLinkActionItem ]
]

{ #category : #visiting }
GtTreePagerPaneAbstractContextMenuBuilder >> visitGtTreePagerLinkState: aState [
	menu addItem: self newWorldTabActionItem.
	menu addItem: self newRebuildPaneToolElementActionItem.
	self linkModel depthIndex > 1 ifTrue: [
		menu addItem: self newRemoveLinkActionItem ]
]
