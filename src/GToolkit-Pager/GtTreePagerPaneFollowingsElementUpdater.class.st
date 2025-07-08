"
I know which {{gtMethod:GtTreePagerPaneModel >> #followingPanes | label=following panes}} should be {gtMethod: GtTreePagerPaneFollowingsElementUpdater>>#panesToDisplay | label=displayed} for a give {{gtMethod: GtTreePagerPaneFollowingsElementUpdater >> #paneModel | label=pane model}}. 
I know update {{gtClass:GtTreePagerPaneFollowingsElement}} children accordingly.
I do not create links between collapsed pane elements.
"
Class {
	#name : #GtTreePagerPaneFollowingsElementUpdater,
	#superclass : #Object,
	#instVars : [
		'followingsElement',
		'paneModel',
		'linksToDisplay'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #private }
GtTreePagerPaneFollowingsElementUpdater >> collectLinkElements: orderedLinks [ 
	^ Array streamContents: [ :aStream | 
		orderedLinks do: [ :eachLinks | 
			self collectLinkElements: eachLinks in: aStream ] ]
]

{ #category : #private }
GtTreePagerPaneFollowingsElementUpdater >> collectLinkElements: aLinkModel in: aStream [
	(self paneModel followingLinks includes: aLinkModel) ifTrue: [
		aStream nextPut: (GtTreePagerLinkFollowingContainerElement triangle 
			linkModel: aLinkModel) ].

	aLinkModel isCollapsed ifTrue: [ 
		aStream nextPut: (GtTreePagerLinkFollowingContainerElement collapsed 
			linkModel: aLinkModel) ]
]

{ #category : #private }
GtTreePagerPaneFollowingsElementUpdater >> collectLinksToDisplay: aLinkModel in: aStream depth: aDepth [
	aDepth = 1
		ifTrue: [ aStream nextPut: aLinkModel ]
		ifFalse: [ aLinkModel isCollapsed ifTrue: [ aStream nextPut: aLinkModel ] ].
		
	aLinkModel isCollapsed
		ifTrue: [ aLinkModel followingLinks
				do: [ :eachLinkModel | 
					self
						collectLinksToDisplay: eachLinkModel
						in: aStream
						depth: aDepth + 1 ] ].
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
GtTreePagerPaneFollowingsElementUpdater >> gtLinkElementsFor: aView [
	<gtView>
	self paneModel ifNil: [ ^ aView empty ].

	^ aView columnedList
		title: 'Link elements';
		tooltip: 'Link elements to display';
		priority: 5;
		items: [ self linkElementsToDisplay ];
		column: 'Element'
			text: [ :eachElement | 
				(eachElement isKindOf: GtTreePagerLinkFollowingContainerElement)
					ifTrue: [ eachElement hasChildren
							ifTrue: [ | aText |
								aText := 'Container with ' asRopedText
										foreground: BlTheme default button disabledTextColor.
								aText append: (eachElement childAt: 1) gtDisplayText.
								aText ]
							ifFalse: [ eachElement gtDisplayString ] ]
					ifFalse: [ eachElement gtDisplayString ] ] weight: 2;
		column: 'Link model' text: [ :eachElement | eachElement linkModel ];
		column: 'Display index'
			text: [ :eachElement | 
				| aDisplayIndex |
				aDisplayIndex := self linksToDisplay indexOf: eachElement linkModel.
				aDisplayIndex isZero ifTrue: [ '' ] ifFalse: [ aDisplayIndex ] ]
			width: 90
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
				aDisplayIndex := self linksToDisplay indexOf: each.
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
GtTreePagerPaneFollowingsElementUpdater >> linkElementsToDisplay [
	"Return link elements that should be displayed as following links (to the right of a given pane)."

	^ self collectLinkElements: self linksToDisplay
]

{ #category : #accessing }
GtTreePagerPaneFollowingsElementUpdater >> linksToDisplay [
	"Return links that should be displayed as following links (to the right of a given pane)."

	^ linksToDisplay
		ifNil: [ linksToDisplay := Array
					streamContents: [ :aStream | 
						self paneModel followingLinks
							do: [ :eachLinkModel | 
								self
									collectLinksToDisplay: eachLinkModel
									in: aStream
									depth: 1 ] ] ]
]

{ #category : #accessing }
GtTreePagerPaneFollowingsElementUpdater >> paneModel [
	^ paneModel ifNil: [ followingsElement ifNotNil: #paneModel ]
]

{ #category : #accessing }
GtTreePagerPaneFollowingsElementUpdater >> paneModel: aPaneModel [
	paneModel := aPaneModel
]

{ #category : #updating }
GtTreePagerPaneFollowingsElementUpdater >> update [
	| orderedElements |
	linksToDisplay := nil.
	orderedElements := self linkElementsToDisplay.

	self followingsElement
		removeChildren;
		addChildren: orderedElements
]
