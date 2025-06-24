Class {
	#name : #GtTreePagerFollowingPaneContextMenuBuilder,
	#superclass : #Object,
	#instVars : [
		'paneElement'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #building }
GtTreePagerFollowingPaneContextMenuBuilder >> build [
	| aMenu anActionItem |
	aMenu := BrMenuItems new.

	self paneModel isActiveLink
		ifTrue: [ anActionItem := BrMenuActionItem new
					id: #'menu--keep-link';
					label: 'Keep' preview: [ self paneModel title ];
					action: [ :anElement :aButtonModel :anEvent | self paneModel beInactiveLink ];
					yourself ]
		ifFalse: [ anActionItem := BrMenuActionItem new
					id: #'menu--activate-link';
					label: 'Activate' preview: [ self paneModel title ];
					action: [ :anElement :aButtonModel :anEvent | self paneModel beActiveLink ];
					yourself ].
	aMenu addItem: anActionItem.

	anActionItem := BrMenuActionItem new
			id: #'menu--collapse-pane';
			label: 'Collapse' preview: [ self paneModel title ];
			action: [ :anElement :aButtonModel :anEvent | self paneModel collapse ];
			yourself.
	aMenu addItem: anActionItem.

	anActionItem := BrMenuActionItem new
			id: #'menu--remove-pane';
			label: 'Remove' preview: [ self paneModel title ];
			action: [ :anElement :aButtonModel :anEvent | self paneModel removeFromPreviousPane ];
			yourself.
	aMenu addItem: anActionItem.

	^ aMenu
]

{ #category : #accessing }
GtTreePagerFollowingPaneContextMenuBuilder >> paneElement [
	^ paneElement
]

{ #category : #accessing }
GtTreePagerFollowingPaneContextMenuBuilder >> paneElement: anObject [
	paneElement := anObject
]

{ #category : #accessing }
GtTreePagerFollowingPaneContextMenuBuilder >> paneModel [
	^ paneElement paneModel
]
