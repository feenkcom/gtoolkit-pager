Class {
	#name : #GtTreePagerPaneMaximizedContextMenuBuilder,
	#superclass : #GtTreePagerPaneAbstractContextMenuBuilder,
	#category : #'GToolkit-TreePager-Support'
}

{ #category : #'menu items' }
GtTreePagerPaneMaximizedContextMenuBuilder >> newCollapseOrSelectPaneActionItem [
	^ nil
]

{ #category : #'menu items' }
GtTreePagerPaneMaximizedContextMenuBuilder >> newHideLinkActionItem [
	^ nil
]

{ #category : #'menu items' }
GtTreePagerPaneMaximizedContextMenuBuilder >> newMaximizePaneActionItem [
	^ nil
]

{ #category : #'menu items' }
GtTreePagerPaneMaximizedContextMenuBuilder >> newRemoveLinkActionItem [
	^ nil
]

{ #category : #visiting }
GtTreePagerPaneMaximizedContextMenuBuilder >> visitGtTreePagerLinkActiveSpawnedState: aState [
	menu addItem: self newMinimizePaneActionItem.
	super visitGtTreePagerLinkActiveSpawnedState: aState
]

{ #category : #visiting }
GtTreePagerPaneMaximizedContextMenuBuilder >> visitGtTreePagerLinkInactiveSpawnedState: aState [
	menu addItem: self newMinimizePaneActionItem.
	super visitGtTreePagerLinkInactiveSpawnedState: aState
]
