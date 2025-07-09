Class {
	#name : #GtTreePagerModel,
	#superclass : #Object,
	#traits : 'TGtTreePagerPaneModelEnumerable + TGtOptions + TGtAnnouncer',
	#classTraits : 'TGtTreePagerPaneModelEnumerable classTrait + TGtOptions classTrait + TGtAnnouncer classTrait',
	#instVars : [
		'announcer',
		'paneLinks'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'api - panes' }
GtTreePagerModel >> allFollowingPanes [
	^ Array
		streamContents: [ :aStream | self allPanesBreadthFirstDo: [ :eachPane | aStream nextPut: eachPane ] ]
]

{ #category : #announcer }
GtTreePagerModel >> announcer [
	<return: #Announcer>
	^ announcer
]

{ #category : #'api - panes' }
GtTreePagerModel >> children [
	^ self paneModels
]

{ #category : #'api - enumeration' }
GtTreePagerModel >> enumerablePaneModels [
	<return: #Collection of: #GtTreePagerPaneModel>
	^ self paneModels
]

{ #category : #views }
GtTreePagerModel >> gtDefaultInspectorTool [
	^ GtPhlowCompositeTool new
		addTool: (GtPhlowExplicitTool new
				name: 'pager';
				icon: BrGlamorousIcons tree;
				stencil: [ GtTreePagerElement new pagerModel: self ]);
		addTool: super gtDefaultInspectorTool
]

{ #category : #views }
GtTreePagerModel >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 10;
		stencil: [ GtTreePagerElement new pagerModel: self ]
]

{ #category : #views }
GtTreePagerModel >> gtPanesFor: aView [
	<gtView>
	paneLinks ifNil: [ ^ aView empty ].
	^ aView columnedTree
		title: 'Panes';
		items: [ paneLinks ];
		children: #children;
		expandUpTo: 10;
		column: 'Value' text: [ :each | each gtDisplayString ];
		column: 'Value' text: [ :each | each previousLink state gtDisplayString ];
		column: 'Active'
			text: [ :each | 
				each isActive
					ifTrue: [ 'yes' ]
					ifFalse: [ 'no' asRopedText foreground: BlTheme default button disabledTextColor ] ]
			width: 50;
		column: 'Spawned'
			text: [ :each | 
				each isDisplayed
					ifTrue: [ 'yes' ]
					ifFalse: [ 'no' asRopedText foreground: BlTheme default button disabledTextColor ] ]
			width: 70;
		column: 'Hidden'
			text: [ :each | 
				each isHidden
					ifTrue: [ 'yes' ]
					ifFalse: [ 'no' asRopedText foreground: BlTheme default button disabledTextColor ] ]
			width: 60;
		column: 'Collapsed'
			text: [ :each | 
				each isCollapsed
					ifTrue: [ 'yes' ]
					ifFalse: [ 'no' asRopedText foreground: BlTheme default button disabledTextColor ] ]
			width: 70
]

{ #category : #initialization }
GtTreePagerModel >> initialize [
	super initialize.

	announcer := Announcer new.
	paneLinks := Array empty
]

{ #category : #'api - panes' }
GtTreePagerModel >> paneLinks [
	<return: #Collection of: #GtTreePagerModelLinkAdaptor>
	^ paneLinks
]

{ #category : #'api - panes' }
GtTreePagerModel >> paneLinks: aCollection [
	self assert: [ aCollection allSatisfy: [ :each | 
		each isKindOf: GtTreePagerModelLinkAdaptor ] ].
	
	paneLinks = aCollection ifTrue: [ ^ self ].

	aCollection do: [ :eachLink | eachLink pagerModel: self ].
	paneLinks := aCollection
]

{ #category : #'api - panes' }
GtTreePagerModel >> paneModel: aPaneModel [
	self paneModels: {aPaneModel}
]

{ #category : #'api - panes' }
GtTreePagerModel >> paneModels [
	^ self paneLinks collect: #paneModel
]

{ #category : #'api - panes' }
GtTreePagerModel >> paneModels: aCollection [
	self
		paneLinks: (aCollection
				collect: [ :eachPane | GtTreePagerModelLinkAdaptor new paneModel: eachPane ])
]
