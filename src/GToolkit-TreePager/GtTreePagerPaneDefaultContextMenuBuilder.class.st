Class {
	#name : #GtTreePagerPaneDefaultContextMenuBuilder,
	#superclass : #GtTreePagerPaneAbstractContextMenuBuilder,
	#category : #'GToolkit-TreePager-Support'
}

{ #category : #'menu items' }
GtTreePagerPaneDefaultContextMenuBuilder >> newCollapseOrSelectPaneActionItem [
	^ super newCollapseOrSelectPaneActionItem
		label: 'Collapse pane'
		preview: [ self linkModel title ]
		shortcut: [ OSPlatform current primaryModifier gtDisplayString, '+Click' ]
]

{ #category : #'menu items' }
GtTreePagerPaneDefaultContextMenuBuilder >> newRemoveLinkActionItem [
	^ super newRemoveLinkActionItem
		label: 'Remove pane'
		preview: [ self thisAndOtherPanesPreviewString ]
		shortcut: [ OSPlatform current primaryModifier gtDisplayString
				, '+Shift+Click' ]
]
