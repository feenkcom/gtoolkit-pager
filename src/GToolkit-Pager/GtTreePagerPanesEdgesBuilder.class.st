Class {
	#name : #GtTreePagerPanesEdgesBuilder,
	#superclass : #Object,
	#traits : 'TGtTreePagerLinkStateVisitor',
	#classTraits : 'TGtTreePagerLinkStateVisitor classTrait',
	#instVars : [
		'panesElement',
		'pagerModel',
		'elementsStream',
		'currentFromLink',
		'displayedPaneElements',
		'incomingLinkElements',
		'currentLinkElement'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #building }
GtTreePagerPanesEdgesBuilder >> build [
	| outgoingLinkElements |
	outgoingLinkElements := self displayedPaneElements
			flatCollect: [ :eachPaneElement | eachPaneElement outgoingLinkElements ].
	incomingLinkElements := self displayedPaneElements
			flatCollect: [ :eachPaneElement | eachPaneElement incomingLinkElements ].

	^ Array
		streamContents: [ :aStream | 
			elementsStream := aStream.
			outgoingLinkElements
				do: [ :eachLinkElement | self collectEdgeFromOutgoingLink: eachLinkElement ].
			elementsStream := nil ]
]

{ #category : #building }
GtTreePagerPanesEdgesBuilder >> collectEdgeFromOutgoingLink: aLinkElement [ 
	currentLinkElement := aLinkElement.
	self visitLinkState: aLinkElement linkModel state
]

{ #category : #private }
GtTreePagerPanesEdgesBuilder >> collectEdgeToIncomingLink [
	| anIncomingElement aLineElement |
	anIncomingElement := self currentLinkIncomingElement.
	anIncomingElement ifNil: [ ^ self ].

	aLineElement := BlManhattanLineElement new
			in: [ :theElement | 
				theElement graph
					beEdge;
					model: currentLinkElement linkModel ];
			zIndex: -1;
			border: (BlBorder paint: self panesElement theme button fadedBackgroundColor);
			beAutomatic;
			fixedDistance: 10;
			cornerRadius: 10;
			fromAnchor: (BlElementCenterRightAnchor element: currentLinkElement);
			toAnchor: (BlElementTopCenterAnchor element: anIncomingElement).
	self styleLineElement: aLineElement.
	elementsStream nextPut: aLineElement
]

{ #category : #private }
GtTreePagerPanesEdgesBuilder >> collectEdgeToSpawnedPane [
	| aPaneElement aLineElement |
	aPaneElement := self currentLinkPaneElement.
	aPaneElement ifNil: [ ^ self ].

	aLineElement := BlManhattanLineElement new
			in: [ :theElement | 
				theElement graph
					beEdge;
					model: currentLinkElement linkModel ];
			zIndex: -1;
			border: (BlBorder paint: self panesElement theme button fadedBackgroundColor);
			beFixedTo;
			fixedDistance: 10;
			cornerRadius: 10;
			fromAnchor: (BlElementCenterRightAnchor element: currentLinkElement);
			toAnchor: (BlElementCenterLeftAnchor element: aPaneElement).
	self styleLineElement: aLineElement.
	elementsStream nextPut: aLineElement
]

{ #category : #private }
GtTreePagerPanesEdgesBuilder >> currentLinkIncomingElement [
	^ incomingLinkElements
		detect: [ :eachElement | eachElement linkModel = currentLinkElement linkModel ]
		ifNone: [ nil ]
]

{ #category : #private }
GtTreePagerPanesEdgesBuilder >> currentLinkPaneElement [
	^ displayedPaneElements
		detect: [ :eachElement | eachElement paneModel = currentLinkElement linkModel paneModel ]
		ifNone: [ nil ]
]

{ #category : #accessing }
GtTreePagerPanesEdgesBuilder >> displayedPaneElements [
	^ displayedPaneElements
]

{ #category : #accessing }
GtTreePagerPanesEdgesBuilder >> displayedPaneElements: someElements [
	displayedPaneElements := someElements
]

{ #category : #accessing }
GtTreePagerPanesEdgesBuilder >> pagerModel [
	^ pagerModel ifNil: [ self panesElement ifNotNil: #pagerModel ]
]

{ #category : #accessing }
GtTreePagerPanesEdgesBuilder >> pagerModel: anObject [
	pagerModel := anObject
]

{ #category : #accessing }
GtTreePagerPanesEdgesBuilder >> panesElement [
	^ panesElement
]

{ #category : #accessing }
GtTreePagerPanesEdgesBuilder >> panesElement: anObject [
	panesElement := anObject
]

{ #category : #private }
GtTreePagerPanesEdgesBuilder >> styleLineElement: aLineElement [
	| anAptitude |
	anAptitude := BrLazyStyleCommonAptitude new
			default: [ :aStyle | aStyle border: aLineElement theme button fadedBackgroundColor ];
			hovered: [ :aStyle | aStyle border: aLineElement theme button focusedFadedBackgroundColor ].

	aLineElement addAptitude: anAptitude
]

{ #category : #visiting }
GtTreePagerPanesEdgesBuilder >> visitGtTreePagerLinkActiveSpawnedState: aState [
	self collectEdgeToSpawnedPane
]

{ #category : #visiting }
GtTreePagerPanesEdgesBuilder >> visitGtTreePagerLinkInactiveCollapsedState: aState [
	self collectEdgeToIncomingLink
]

{ #category : #visiting }
GtTreePagerPanesEdgesBuilder >> visitGtTreePagerLinkInactiveSpawnedState: aState [
	self collectEdgeToSpawnedPane
]
