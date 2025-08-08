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
		label: 'Collapse' preview: [ self linkModel title ];
		action: [ :anElement :aButtonModel :anEvent | self linkModel collapse ];
		yourself
]

{ #category : #'menu items' }
GtTreePagerLinkAbstractContextMenuBuilder >> newCollapseOrSelectPaneActionItem [
	^ BrMenuActionItem new
		id: #'tree-pager--menu-collapse';
		label: 'Collapse' preview: [ self linkModel title ];
		action: [ :anElement :aButtonModel :anEvent | self paneModel collapseOrSelect ];
		yourself
]

{ #category : #'menu items' }
GtTreePagerLinkAbstractContextMenuBuilder >> newExpandLinkActionItem [
	^ BrMenuActionItem new
		id: #'menu--expand-pane';
		label: 'Expand' preview: [ self linkModel title ];
		action: [ :anElement :aButtonModel :anEvent | self linkModel expand ];
		yourself
]

{ #category : #'menu items' }
GtTreePagerLinkAbstractContextMenuBuilder >> newHideLinkActionItem [
	^ BrMenuActionItem new
		id: #'menu--hide-link';
		label: 'Hide' preview: [ self thisAndOtherPanesPreviewString ];
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
		label: 'Maximize' preview: [ self linkModel title ];
		action: [ :anElement :aButtonModel :anEvent | self paneModel requestMaximizePane ];
		yourself
]

{ #category : #'menu items' }
GtTreePagerLinkAbstractContextMenuBuilder >> newRebuildPaneToolElementActionItem [
	^ BrMenuActionItem new
		id: #'menu--rebuild-pane-tool-element';
		label: 'Update tool' preview: [ self linkModel title ];
		action: [ :anElement :aButtonModel :anEvent | self paneModel requestRebuildPaneTool ];
		yourself
]

{ #category : #'menu items' }
GtTreePagerLinkAbstractContextMenuBuilder >> newRemoveLinkActionItem [
	^ BrMenuActionItem new
		id: #'menu--remove-pane';
		label: 'Remove' preview: [ self thisAndOtherPanesPreviewString ];
		action: [ :anElement :aButtonModel :anEvent | self linkModel removeFromPreviousPane ];
		yourself
]

{ #category : #'menu items' }
GtTreePagerLinkAbstractContextMenuBuilder >> newWorldTabActionItem [
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
