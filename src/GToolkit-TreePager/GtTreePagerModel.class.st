Class {
	#name : #GtTreePagerModel,
	#superclass : #Object,
	#traits : 'TGtTreePagerModelEnumerable + TGtAnnouncer + TGtOptions + TGtTreePagerLinkModelState',
	#classTraits : 'TGtTreePagerModelEnumerable classTrait + TGtAnnouncer classTrait + TGtOptions classTrait + TGtTreePagerLinkModelState classTrait',
	#instVars : [
		'announcer',
		'linkModels',
		'settings'
	],
	#category : #'GToolkit-TreePager-Model'
}

{ #category : #'api - panes' }
GtTreePagerModel >> allFollowingPanes [
	^ Array
		streamContents: [ :aStream | self allPaneModelsBreadthFirstDo: [ :eachPane | aStream nextPut: eachPane ] ]
]

{ #category : #'api - previous links' }
GtTreePagerModel >> allPreviousLinkAndPanesDo: aBlock [
	"Iterate previous links and panes hierarchy"

	
]

{ #category : #'api - previous links' }
GtTreePagerModel >> allPreviousPanesDo: aFullBlockClosure [
	"Iterate previous panes hierarchy"

	
]

{ #category : #announcer }
GtTreePagerModel >> announcer [
	<return: #Announcer>
	^ announcer
]

{ #category : #converting }
GtTreePagerModel >> asElement [
	^ GtTreePager new pagerModel: self
]

{ #category : #'api - panes' }
GtTreePagerModel >> children [
	<return: #Collection of: #TGtTreePagerLinkModel>
	^ self linkModels
]

{ #category : #'api - enumeration' }
GtTreePagerModel >> enumerableLinkModels [
	<return: #Collection of: #TGtTreePagerLinkModel>
	^ self linkModels
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
				stencil: [ GtTreePager new pagerModel: self ]);
		addTool: super gtDefaultInspectorTool
]

{ #category : #views }
GtTreePagerModel >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 10;
		stencil: [ GtTreePager new pagerModel: self ]
]

{ #category : #views }
GtTreePagerModel >> gtPanesFor: aView [
	<gtView>
	linkModels ifNil: [ ^ aView empty ].
	^ aView columnedTree
		title: 'Panes';
		items: [ linkModels ];
		children: #children;
		expandUpTo: 10;
		column: 'Value' text: [ :eachLink | eachLink gtDisplayString ];
		column: 'State' text: [ :eachLink | eachLink state label ];
		column: 'Active'
			text: [ :eachLink | 
				eachLink isActive
					ifTrue: [ 'yes' ]
					ifFalse: [ 'no' asRopedText foreground: BlTheme default button disabledTextColor ] ]
			width: 50;
		column: 'Spawned'
			text: [ :eachLink | 
				eachLink isSpawned
					ifTrue: [ 'yes' ]
					ifFalse: [ 'no' asRopedText foreground: BlTheme default button disabledTextColor ] ]
			width: 70;
		column: 'Hidden'
			text: [ :eachLink | 
				eachLink isHidden
					ifTrue: [ 'yes' ]
					ifFalse: [ 'no' asRopedText foreground: BlTheme default button disabledTextColor ] ]
			width: 60;
		column: 'Collapsed'
			text: [ :eachLink | 
				eachLink isCollapsed
					ifTrue: [ 'yes' ]
					ifFalse: [ 'no' asRopedText foreground: BlTheme default button disabledTextColor ] ]
			width: 70
]

{ #category : #initialization }
GtTreePagerModel >> initialize [
	super initialize.

	announcer := Announcer new.
	linkModels := Array empty.
	settings := GtTreePagerModelSettings new announcer: announcer.
]

{ #category : #'api - panes' }
GtTreePagerModel >> linkModels [
	<return: #Collection of: #GtTreePagerModelLinkAdaptor>
	^ linkModels
]

{ #category : #'api - panes' }
GtTreePagerModel >> linkModels: aCollection [
	self assert: [ aCollection allSatisfy: [ :each | 
		each isKindOf: GtTreePagerModelLinkAdaptor ] ].
	
	linkModels = aCollection ifTrue: [ ^ self ].

	aCollection do: [ :eachLink | eachLink pagerModel: self ].
	linkModels := aCollection
]

{ #category : #'api - panes' }
GtTreePagerModel >> paneModel: aPaneModel [
	self paneModels: {aPaneModel}
]

{ #category : #'api - panes' }
GtTreePagerModel >> paneModels [
	^ self linkModels collect: #paneModel
]

{ #category : #'api - panes' }
GtTreePagerModel >> paneModels: aCollection [
	self
		linkModels: (aCollection
				collect: [ :eachPane | GtTreePagerModelLinkAdaptor new paneModel: eachPane ])
]

{ #category : #'api - previous links' }
GtTreePagerModel >> previousLink [
	^ nil
]

{ #category : #accessing }
GtTreePagerModel >> settings [
	^ settings
]

{ #category : #'api - state' }
GtTreePagerModel >> state [
	<return: #GtTreePagerLinkState>
	^ GtTreePagerLinkState spawned
]
