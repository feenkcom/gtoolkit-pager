Class {
	#name : #GtTreePagerPaneContextMenuBuilder,
	#superclass : #GtTreePagerPaneAbstractContextMenuBuilder,
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'menu items' }
GtTreePagerPaneContextMenuBuilder >> newCollapseOrSelectPaneActionItem [
	^ super newCollapseOrSelectPaneActionItem
		label: 'Collapse'
		preview: [ self linkModel title ]
		shortcut: [ OSPlatform current primaryModifier gtDisplayString, '+Click' ]
]

{ #category : #'menu items' }
GtTreePagerPaneContextMenuBuilder >> newMaximizePaneActionItem [
	^ super newMaximizePaneActionItem
		label: 'Maximize'
		preview: [ self linkModel title ]
		shortcut: [ OSPlatform current primaryModifier gtDisplayString , '+Shift+Click' ]
]
