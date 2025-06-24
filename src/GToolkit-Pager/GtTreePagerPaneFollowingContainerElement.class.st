Class {
	#name : #GtTreePagerPaneFollowingContainerElement,
	#superclass : #GtTreePagerPaneBasicElement,
	#instVars : [
		'expandedElement',
		'collapsedElement'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #initialization }
GtTreePagerPaneFollowingContainerElement >> defaultLayout [
	^ BlFrameLayout new
]

{ #category : #initialization }
GtTreePagerPaneFollowingContainerElement >> initialize [
	super initialize.
	self
		vMatchParent;
		hFitContent.

	expandedElement := GtTreePagerPaneFollowingTriangleElement new
			constraintsDo: [ :c | 
				c frame vertical alignCenter.
				c frame horizontal alignLeft ].

	collapsedElement := GtTreePagerPaneFollowingCollapsedElement new
			visibility: BlVisibility gone;
			constraintsDo: [ :c | 
				c frame vertical alignCenter.
				c frame horizontal alignLeft ].

	self
		addChildren: {expandedElement.
				collapsedElement}
]

{ #category : #'private - event handling' }
GtTreePagerPaneFollowingContainerElement >> onGtTreePagerPaneModelExpansionChanged: anAnnouncement [
	anAnnouncement paneModel = self paneModel ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'api - pane model' }
GtTreePagerPaneFollowingContainerElement >> onPaneModelChanged [
	expandedElement paneModel: self paneModel.
	collapsedElement paneModel: self paneModel.
	self updateElement
]

{ #category : #'api - pane model' }
GtTreePagerPaneFollowingContainerElement >> subscribeToPaneModel [
	self paneModel announcer weak
		when: GtTreePagerPaneModelExpansionChanged
		send: #onGtTreePagerPaneModelExpansionChanged:
		to: self
]

{ #category : #'api - pane model' }
GtTreePagerPaneFollowingContainerElement >> unsubscribeFromPaneModel [
	self paneModel unsubscribe: self
]

{ #category : #'api - pane model' }
GtTreePagerPaneFollowingContainerElement >> updateElement [
	self paneModel isCollapsed
		ifTrue: [ collapsedElement visibility: BlVisibility visible.
			expandedElement visibility: BlVisibility gone ]
		ifFalse: [ collapsedElement visibility: BlVisibility gone.
			expandedElement visibility: BlVisibility visible ]
]
