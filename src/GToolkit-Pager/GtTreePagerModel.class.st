Class {
	#name : #GtTreePagerModel,
	#superclass : #Object,
	#traits : 'TGtTreePagerPaneModelEnumerable',
	#classTraits : 'TGtTreePagerPaneModelEnumerable classTrait',
	#instVars : [
		'paneModels'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

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
	
	"aCollection do: [ :eachPane | eachPane pagerModel: self ]."
	paneModels := aCollection
]
