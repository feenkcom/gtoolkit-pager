Class {
	#name : #GtTreePagerLinkContextMenuBuilder,
	#superclass : #GtTreePagerLinkAbstractContextMenuBuilder,
	#category : #'GToolkit-TreePager-Support'
}

{ #category : #visiting }
GtTreePagerLinkContextMenuBuilder >> visitGtTreePagerLinkActiveSelectedState: aState [
	menu addItem: self newInactivateLinkActionItem.
	menu addItem: self newExpandLinkActionItem.
	menu addItem: self newRemoveLinkActionItem.
	self mayAddHardRemoveLinkActionItem
]

{ #category : #visiting }
GtTreePagerLinkContextMenuBuilder >> visitGtTreePagerLinkActiveSpawnedState: aState [
	self linkModel depthIndex = 1
		ifFalse: [ menu addItem: self newInactivateLinkActionItem.
			menu addItem: self newCollapseLinkActionItem ].
	self linkModel depthIndex = 1
		ifFalse: [ menu addItem: self newRemoveLinkActionItem.
			self mayAddHardRemoveLinkActionItem ]
]

{ #category : #visiting }
GtTreePagerLinkContextMenuBuilder >> visitGtTreePagerLinkInactiveCollapsedState: aState [
	menu addItem: self newExpandLinkActionItem.
	self linkModel depthIndex = 1
		ifFalse: [ menu addItem: self newRemoveLinkActionItem.
			self mayAddHardRemoveLinkActionItem ]
]

{ #category : #visiting }
GtTreePagerLinkContextMenuBuilder >> visitGtTreePagerLinkInactiveHiddenState: aState [
	menu addItem: self newExpandLinkActionItem.
	self linkModel depthIndex = 1
		ifFalse: [ menu addItem: self newRemoveLinkActionItem.
			self mayAddHardRemoveLinkActionItem ]
]

{ #category : #visiting }
GtTreePagerLinkContextMenuBuilder >> visitGtTreePagerLinkInactiveRemovedState: aState [
	menu addItem: self newExpandLinkActionItem.
	self linkModel depthIndex = 1
		ifFalse: [ menu addItem: self newHardRemoveLinkActionItem. ]
]

{ #category : #visiting }
GtTreePagerLinkContextMenuBuilder >> visitGtTreePagerLinkInactiveSpawnedState: aState [
	self linkModel depthIndex = 1
		ifFalse: [ menu addItem: self newActivateLinkActionItem.
			menu addItem: self newCollapseLinkActionItem ].
	self linkModel depthIndex = 1
		ifFalse: [ menu addItem: self newRemoveLinkActionItem.
			self mayAddHardRemoveLinkActionItem ]
]

{ #category : #visiting }
GtTreePagerLinkContextMenuBuilder >> visitGtTreePagerLinkState: aState [
	self linkModel depthIndex = 1
		ifFalse: [ menu addItem: self newRemoveLinkActionItem.
			self mayAddHardRemoveLinkActionItem ]
]
