Class {
	#name : #GtTreePagerModel,
	#superclass : #Object,
	#traits : 'TGtTreePagerPaneModelEnumerable + TGtOptions + TGtAnnouncer',
	#classTraits : 'TGtTreePagerPaneModelEnumerable classTrait + TGtOptions classTrait + TGtAnnouncer classTrait',
	#instVars : [
		'paneModels',
		'announcer'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'api - pane model' }
GtTreePagerModel >> activeLink [
	^ nil
]

{ #category : #'api - panes' }
GtTreePagerModel >> allFollowingPanes [
	^ Array
		streamContents: [ :aStream | self allPanesBreadthFirstDo: [ :eachPane | aStream nextPut: eachPane ] ]
]

{ #category : #'api - pane model' }
GtTreePagerModel >> allPreviousPanesDo: aFullBlockClosure [
	"Do nothing."

	
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
	paneModels ifNil: [ ^ aView empty ].
	^ aView columnedTree
		title: 'Panes';
		items: [ paneModels ];
		children: #children;
		expandUpTo: 10;
		column: 'Value' text: [ :each | each gtDisplayString ]
]

{ #category : #initialization }
GtTreePagerModel >> initialize [
	super initialize.

	announcer := Announcer new.
	paneModels := Array empty
]

{ #category : #'api - panes' }
GtTreePagerModel >> paneModel: aPaneModel [
	self paneModels: {aPaneModel}
]

{ #category : #'api - panes' }
GtTreePagerModel >> paneModels [
	^ paneModels
]

{ #category : #'api - panes' }
GtTreePagerModel >> paneModels: aCollection [
	paneModels = aCollection ifTrue: [ ^ self ].
	
	aCollection do: [ :eachPane | eachPane previousPane: self ].
	paneModels := aCollection
]
