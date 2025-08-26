Class {
	#name : #GtTreePagerLinkAbstractContextMenuBuilder,
	#superclass : #Object,
	#traits : 'TGtTreePagerLinkStateVisitor',
	#classTraits : 'TGtTreePagerLinkStateVisitor classTrait',
	#instVars : [
		'linkModel',
		'menu',
		'paneElement'
	],
	#category : #'GToolkit-TreePager-Support'
}

{ #category : #building }
GtTreePagerLinkAbstractContextMenuBuilder >> build [
	menu := BrMenuItems new.
	self visitLinkState: self linkModel state.
	^ menu
]

{ #category : #accessing }
GtTreePagerLinkAbstractContextMenuBuilder >> linkModel [
	^ linkModel
]

{ #category : #accessing }
GtTreePagerLinkAbstractContextMenuBuilder >> linkModel: aLinkModel [
	self assert: [ linkModel isNil ].

	linkModel := aLinkModel
]

{ #category : #'menu items' }
GtTreePagerLinkAbstractContextMenuBuilder >> mayAddHardRemoveLinkActionItem [
	GtTreePagerSettings isDisplayHideMenuItem ifFalse: [ ^ self ].
	self linkModel depthIndex = 1 ifTrue: [ ^ self ].
	menu addItem: self newHardRemoveLinkActionItem
]

{ #category : #'menu items' }
GtTreePagerLinkAbstractContextMenuBuilder >> mayAddHideLinkActionItem [
	GtTreePagerSettings isDisplayHideMenuItem ifFalse: [ ^ self ].
	self linkModel depthIndex = 1 ifTrue: [ ^ self ].
	self linkModel followingSpawnedLinkModels ifEmpty: [ ^ self ].
	menu addItem: self newHideLinkActionItem
]

{ #category : #accessing }
GtTreePagerLinkAbstractContextMenuBuilder >> navigationContext [
	<return: #GtTreePagerPaneNavigationContext>
	^ self paneElement ifNotNil: #navigationContext
]

{ #category : #'menu items' }
GtTreePagerLinkAbstractContextMenuBuilder >> newActivateLinkActionItem [
	^ BrMenuActionItem new
		id: #'menu--activate-link';
		label: 'Activate' preview: [ self linkModel title ];
		action: [ :anElement :aButtonModel :anEvent | self linkModel activate ];
		yourself
]

{ #category : #'menu items' }
GtTreePagerLinkAbstractContextMenuBuilder >> newCollapseLinkActionItem [
	^ BrMenuActionItem new
		id: #'menu--collapse-pane';
		label: 'Collapse pane' preview: [ self linkModel title ];
		action: [ :anElement :aButtonModel :anEvent | self linkModel collapse ];
		yourself
]

{ #category : #'menu items' }
GtTreePagerLinkAbstractContextMenuBuilder >> newCollapseOrSelectPaneActionItem [
	^ BrMenuActionItem new
		id: #'tree-pager--menu-collapse';
		label: 'Collapse pane' preview: [ self linkModel title ];
		action: [ :anElement :aButtonModel :anEvent | self paneModel collapseOrSelect ];
		yourself
]

{ #category : #'menu items' }
GtTreePagerLinkAbstractContextMenuBuilder >> newExpandLinkActionItem [
	^ BrMenuActionItem new
		id: #'menu--expand-pane';
		label: 'Expand pane' preview: [ self linkModel title ];
		action: [ :anElement :aButtonModel :anEvent | self linkModel expand ];
		yourself
]

{ #category : #'menu items' }
GtTreePagerLinkAbstractContextMenuBuilder >> newHardRemoveLinkActionItem [
	^ BrMenuActionItem new
		id: #'tree-pager--menu-permanent-remove';
		label: 'Permanently remove pane' preview: [ self thisAndOtherPanesPreviewString ];
		action: [ :anElement :aButtonModel :anEvent | self linkModel removeFromPreviousPane ];
		yourself
]

{ #category : #'menu items' }
GtTreePagerLinkAbstractContextMenuBuilder >> newHideLinkActionItem [
	^ BrMenuActionItem new
		id: #'tree-pager--menu--hide';
		label: 'Collapse all panes' preview: [ self thisAndOtherPanesPreviewString ];
		action: [ :anElement :aButtonModel :anEvent | self linkModel hide ];
		yourself
]

{ #category : #'menu items' }
GtTreePagerLinkAbstractContextMenuBuilder >> newInactivateLinkActionItem [
	^ BrMenuActionItem new
		id: #'menu--keep-link';
		label: 'Keep' preview: [ self linkModel title ];
		action: [ :anElement :aButtonModel :anEvent | self linkModel inactivate ];
		yourself
]

{ #category : #'menu items' }
GtTreePagerLinkAbstractContextMenuBuilder >> newMaximizePaneActionItem [
	^ BrMenuActionItem new
		id: #'menu--maximize-pane';
		label: 'Maximize pane' preview: [ self linkModel title ];
		action: [ :anElement :aButtonModel :anEvent | self paneModel requestMaximizePane ];
		yourself
]

{ #category : #'menu items' }
GtTreePagerLinkAbstractContextMenuBuilder >> newRebuildPaneToolElementActionItem [
	^ BrMenuActionItem new
		id: #'menu--rebuild-pane-tool-element';
		label: 'Update pane tool' preview: [ self linkModel title ];
		action: [ :anElement :aButtonModel :anEvent | self paneModel requestRebuildPaneTool ];
		yourself
]

{ #category : #'menu items' }
GtTreePagerLinkAbstractContextMenuBuilder >> newRemoveLinkActionItem [
	^ BrMenuActionItem new
		id: #'tree-pager--menu-remove';
		label: 'Remove pane' preview: [ self thisAndOtherPanesPreviewString ];
		action: [ :anElement :aButtonModel :anEvent | self linkModel aboutToRemoveFromPreviousPane ];
		yourself
]

{ #category : #'menu items' }
GtTreePagerLinkAbstractContextMenuBuilder >> newWorldTabActionItem [
	^ BrMenuActionItem new
		id: #'menu--new-world-tab';
		label: 'Open pane in new tab' preview: [ self thisAndOtherPanesPreviewString ];
		action: [ :anElement :aButtonModel :anEvent | 
			BlSpace new
				paneInTreePager: self linkModel similarPaneCopy;
				withSceneDriller;
				showFrom: anElement ];
		yourself
]

{ #category : #accessing }
GtTreePagerLinkAbstractContextMenuBuilder >> paneElement [
	^ paneElement
]

{ #category : #accessing }
GtTreePagerLinkAbstractContextMenuBuilder >> paneElement: anObject [
	paneElement := anObject
]

{ #category : #accessing }
GtTreePagerLinkAbstractContextMenuBuilder >> paneModel [
	^ self linkModel paneModel
]

{ #category : #accessing }
GtTreePagerLinkAbstractContextMenuBuilder >> paneModel: aPaneModel [
	self assert: [ linkModel isNil ].
	self assert: [ aPaneModel previousLink isNotNil ].

	self linkModel: aPaneModel previousLink
]

{ #category : #private }
GtTreePagerLinkAbstractContextMenuBuilder >> thisAndOtherPanesPreviewString [
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
