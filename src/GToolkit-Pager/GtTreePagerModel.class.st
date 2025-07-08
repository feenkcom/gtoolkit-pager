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

{ #category : #'api - pane model' }
GtTreePagerModel >> depthIndex [
	^ 0
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
	paneModels := Array empty
]

{ #category : #'api - panes' }
GtTreePagerModel >> isActive [
	^ self state isActive
]

{ #category : #'api - panes' }
GtTreePagerModel >> isCollapsed [
	"My pane models are not collapsed"

	^ self state isCollapsed
]

{ #category : #'api - panes' }
GtTreePagerModel >> isDisplayed [
	^ self state isDisplayed
]

{ #category : #'api - panes' }
GtTreePagerModel >> isHidden [
	^ self state isHidden
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
	
	aCollection do: [ :eachPane | eachPane previousLink: self ].
	paneModels := aCollection
]

{ #category : #'api - panes' }
GtTreePagerModel >> previousPane [
	"I am the root of my pane models"

	^ self
]

{ #category : #'api - panes' }
GtTreePagerModel >> state [
	^ GtTreePagerLinkState spawned
]
