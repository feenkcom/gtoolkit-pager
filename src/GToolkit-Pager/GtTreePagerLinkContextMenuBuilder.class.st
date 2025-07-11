Class {
	#name : #GtTreePagerLinkContextMenuBuilder,
	#superclass : #Object,
	#traits : 'TGtTreePagerLinkStateVisitor',
	#classTraits : 'TGtTreePagerLinkStateVisitor classTrait',
	#instVars : [
		'linkModel',
		'menu'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #building }
GtTreePagerLinkContextMenuBuilder >> build [
	menu := BrMenuItems new.
	self visitLinkState: self linkModel state.
	^ menu
]

{ #category : #accessing }
GtTreePagerLinkContextMenuBuilder >> linkModel [
	^ linkModel
]

{ #category : #accessing }
GtTreePagerLinkContextMenuBuilder >> linkModel: aLinkModel [
	self assert: [ linkModel isNil ].

	linkModel := aLinkModel
]

{ #category : #private }
GtTreePagerLinkContextMenuBuilder >> newActivateLinkActionItem [
	^ BrMenuActionItem new
		id: #'menu--activate-link';
		label: 'Activate' preview: [ self linkModel title ];
		action: [ :anElement :aButtonModel :anEvent | self linkModel activate ];
		yourself
]

{ #category : #private }
GtTreePagerLinkContextMenuBuilder >> newCollapseLinkActionItem [
	^ BrMenuActionItem new
		id: #'menu--collapse-pane';
		label: 'Collapse' preview: [ self linkModel title ];
		action: [ :anElement :aButtonModel :anEvent | self linkModel collapse ];
		yourself
]

{ #category : #private }
GtTreePagerLinkContextMenuBuilder >> newExpandLinkActionItem [
	^ BrMenuActionItem new
		id: #'menu--expand-pane';
		label: 'Expand' preview: [ self linkModel title ];
		action: [ :anElement :aButtonModel :anEvent | self linkModel expand ];
		yourself
]

{ #category : #private }
GtTreePagerLinkContextMenuBuilder >> newHideLinkActionItem [
	^ BrMenuActionItem new
		id: #'menu--hide-link';
		label: 'Hide' preview: [ self thisAndOtherPanesPreviewString ];
		action: [ :anElement :aButtonModel :anEvent | self linkModel hide ];
		yourself
]

{ #category : #private }
GtTreePagerLinkContextMenuBuilder >> newInactivateLinkActionItem [
	^ BrMenuActionItem new
		id: #'menu--keep-link';
		label: 'Keep' preview: [ self linkModel title ];
		action: [ :anElement :aButtonModel :anEvent | self linkModel inactivate ];
		yourself
]

{ #category : #private }
GtTreePagerLinkContextMenuBuilder >> newRemoveLinkActionItem [
	^ BrMenuActionItem new
		id: #'menu--remove-pane';
		label: 'Remove' preview: [ self thisAndOtherPanesPreviewString ];
		action: [ :anElement :aButtonModel :anEvent | self linkModel removeFromPreviousPane ];
		yourself
]

{ #category : #private }
GtTreePagerLinkContextMenuBuilder >> newWorldTabActionItem [
	^ BrMenuActionItem new
		id: #'menu--new-world-tab';
		label: 'Open in new tab' preview: [ self thisAndOtherPanesPreviewString ];
		action: [ :anElement :aButtonModel :anEvent | 
			BlSpace new
				paneInTreePager: self linkModel similarPaneCopy;
				withSceneDriller;
				showFrom: anElement ];
		yourself
]

{ #category : #private }
GtTreePagerLinkContextMenuBuilder >> thisAndOtherPanesPreviewString [
	^ '{1}{2}'
		format: {self linkModel title.
				self linkModel allFollowingPanesCount
					ifNotNil: [ :aCount | 
						aCount isZero
							ifTrue: [ '' ]
							ifFalse: [ ' and {1} other {2}'
									format: {aCount.
											'pane' asPluralBasedOn: aCount} ] ]
					ifNil: [ '' ]}
]

{ #category : #visiting }
GtTreePagerLinkContextMenuBuilder >> visitGtTreePagerLinkActiveSelectedState: aState [
	menu addItem: self newInactivateLinkActionItem.
	menu addItem: self newExpandLinkActionItem.
	menu addItem: self newWorldTabActionItem.
	menu addItem: self newRemoveLinkActionItem
]

{ #category : #visiting }
GtTreePagerLinkContextMenuBuilder >> visitGtTreePagerLinkActiveSpawnedState: aState [
	menu addItem: self newInactivateLinkActionItem.
	menu addItem: self newCollapseLinkActionItem.
	menu addItem: self newHideLinkActionItem.
	menu addItem: self newWorldTabActionItem.
	menu addItem: self newRemoveLinkActionItem
]

{ #category : #visiting }
GtTreePagerLinkContextMenuBuilder >> visitGtTreePagerLinkInactiveCollapsedState: aState [
	menu addItem: self newExpandLinkActionItem.
	menu addItem: self newHideLinkActionItem.
	menu addItem: self newWorldTabActionItem.
	menu addItem: self newRemoveLinkActionItem
]

{ #category : #visiting }
GtTreePagerLinkContextMenuBuilder >> visitGtTreePagerLinkInactiveHiddenState: aState [
	menu addItem: self newExpandLinkActionItem.
	menu addItem: self newWorldTabActionItem.
	menu addItem: self newRemoveLinkActionItem
]

{ #category : #visiting }
GtTreePagerLinkContextMenuBuilder >> visitGtTreePagerLinkInactiveSpawnedState: aState [
	menu addItem: self newActivateLinkActionItem.
	menu addItem: self newCollapseLinkActionItem.
	menu addItem: self newHideLinkActionItem.
	menu addItem: self newWorldTabActionItem.
	menu addItem: self newRemoveLinkActionItem
]

{ #category : #visiting }
GtTreePagerLinkContextMenuBuilder >> visitGtTreePagerLinkState: aState [
	menu addItem: self newWorldTabActionItem.
	menu addItem: self newRemoveLinkActionItem
]
