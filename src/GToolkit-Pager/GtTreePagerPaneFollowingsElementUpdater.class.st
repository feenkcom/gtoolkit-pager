Class {
	#name : #GtTreePagerPaneFollowingsElementUpdater,
	#superclass : #Object,
	#instVars : [
		'followingsElement',
		'paneModel',
		'panesToDisplay'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #private }
GtTreePagerPaneFollowingsElementUpdater >> collectPaneElements: orderedPanes [ 
	^ Array streamContents: [ :aStream | 
		orderedPanes do: [ :eachPane | 
			self collectPaneElements: eachPane in: aStream ] ]
]

{ #category : #private }
GtTreePagerPaneFollowingsElementUpdater >> collectPaneElements: aPaneModel in: aStream [
	aPaneModel isCollapsed ifTrue: [ 
		aStream nextPut: (GtTreePagerPaneFollowingBasicContainerElement collapsed 
			paneModel: aPaneModel) ].

	aStream nextPut: (GtTreePagerPaneFollowingBasicContainerElement triangle 
		paneModel: aPaneModel)
]

{ #category : #private }
GtTreePagerPaneFollowingsElementUpdater >> collectPanesToDisplay: aPaneModel in: aStream depth: aDepth [
	aPaneModel isCollapsed
		ifTrue: [ aPaneModel followingPanes
				do: [ :eachPaneModel | 
					self
						collectPanesToDisplay: eachPaneModel
						in: aStream
						depth: aDepth + 1 ] ].

	aDepth = 1
		ifTrue: [ aStream nextPut: aPaneModel ]
		ifFalse: [ aPaneModel isCollapsed ifTrue: [ aStream nextPut: aPaneModel ] ]
]

{ #category : #accessing }
GtTreePagerPaneFollowingsElementUpdater >> followingsElement [
	^ followingsElement
]

{ #category : #accessing }
GtTreePagerPaneFollowingsElementUpdater >> followingsElement: anObject [
	followingsElement := anObject
]

{ #category : #views }
GtTreePagerPaneFollowingsElementUpdater >> gtPaneModelFor: aView [
	<gtView>
	^ aView forward
		title: 'Pane element';
		priority: 30;
		object: [ self paneModel ];
		view: #gtLiveFor:
]

{ #category : #views }
GtTreePagerPaneFollowingsElementUpdater >> gtPanesFor: aView [
	<gtView>
	self paneModel ifNil: [ ^ aView empty ].

	^ aView columnedTree
		title: 'Panes';
		priority: 10;
		items: [ {self paneModel} ];
		children: #children;
		expandUpTo: 10;
		column: 'Value' text: [ :each | each gtDisplayString ];
		column: 'Display index'
			text: [ :each | 
				| aDisplayIndex |
				aDisplayIndex := self panesToDisplay indexOf: each.
				aDisplayIndex isZero ifTrue: [ '' ] ifFalse: [ aDisplayIndex ] ] width: 90
]

{ #category : #views }
GtTreePagerPaneFollowingsElementUpdater >> gtRootPanesFor: aView [
	<gtView>
	self paneModel ifNil: [ ^ aView empty ].

	^ aView columnedTree
		title: 'Root pane';
		items: [ {self paneModel topPreviousPane} ];
		children: #children;
		expandUpTo: 10;
		column: 'Value'
			text: [ :each | 
				| aString |
				aString := each gtDisplayString.
				each = self paneModel
					ifTrue: [ aString asRopedText bold ]
					ifFalse: [ aString ] ];
		send: [ :each | self class new paneModel: each ];
		contextItemLabel: 'Inspect pane model'
			action: [ :anElement :aNode | anElement phlow spawnObject: aNode value ];
		contextItemLabel: 'Inspect pane model followings updater'
			action: [ :anElement :aNode | anElement phlow spawnObject: (self class new paneModel: aNode value) ]
]

{ #category : #accessing }
GtTreePagerPaneFollowingsElementUpdater >> paneModel [
	^ paneModel ifNil: [ followingsElement ifNotNil: #paneModel ]
]

{ #category : #accessing }
GtTreePagerPaneFollowingsElementUpdater >> paneModel: aPaneModel [
	paneModel := aPaneModel
]

{ #category : #accessing }
GtTreePagerPaneFollowingsElementUpdater >> panesToDisplay [
	"Return panes that should be displayed as following panes (to the right of a given pane)."

	^ panesToDisplay
		ifNil: [ panesToDisplay := Array
					streamContents: [ :aStream | 
						self paneModel followingPanes
							do: [ :eachPaneModel | 
								self
									collectPanesToDisplay: eachPaneModel
									in: aStream
									depth: 1 ] ] ]
]

{ #category : #updating }
GtTreePagerPaneFollowingsElementUpdater >> update [
	| orderedPanes orderedElements |
	orderedPanes := self panesToDisplay.
	orderedElements := self collectPaneElements: orderedPanes.

	self followingsElement
		removeChildren;
		addChildren: orderedElements
]
