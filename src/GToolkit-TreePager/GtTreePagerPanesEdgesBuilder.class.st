Class {
	#name : #GtTreePagerPanesEdgesBuilder,
	#superclass : #Object,
	#traits : 'TGtTreePagerLinkStateVisitor',
	#classTraits : 'TGtTreePagerLinkStateVisitor classTrait',
	#instVars : [
		'panesElement',
		'pagerModel',
		'elementsStream',
		'displayedPaneElements',
		'incomingLinkElements',
		'currentLinkElement'
	],
	#category : #'GToolkit-TreePager-Support'
}

{ #category : #building }
GtTreePagerPanesEdgesBuilder >> build [
	| outgoingLinkElements |
	outgoingLinkElements := self displayedPaneElements
			flatCollect: [ :eachPaneElement | eachPaneElement outgoingLinkElements ].
	incomingLinkElements := self displayedPaneElements
			flatCollect: [ :eachPaneElement | eachPaneElement incomingLinkElements ].

	outgoingLinkElements do: [ :anElement | 
		anElement userData 
			removeKey: #outgoingLineElement 
			ifAbsent: [ nil ] ].

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
	self visitLinkState: aLinkElement linkModel state.
	currentLinkElement := nil.
]

{ #category : #private }
GtTreePagerPanesEdgesBuilder >> collectEdgeToIncomingLink [
	| anIncomingElement aLineElement |
	anIncomingElement := self currentLinkIncomingElement.
	anIncomingElement ifNil: [ ^ self ].

	aLineElement := BlLineElement new
			in: [ :theElement | 
				theElement graph
					beEdge;
					model: currentLinkElement linkModel ];
			zIndex: -2;
			fromAnchor: (BlElementCenterRightAnchor element: currentLinkElement);
			toAnchor: (BlElementTopCenterAnchor element: anIncomingElement).
	self styleLineElement: aLineElement.

	currentLinkElement userData
		at: #outgoingLineElement
		ifPresent: [ :aCollection | aCollection add: aLineElement ]
		ifAbsentPut: [ OrderedCollection with: aLineElement ].
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
			zIndex: -2;
			cornerRadius: GtTreePagerConstants edgeCornerRadius;
			fromAnchor: (BlElementCenterRightAnchor element: currentLinkElement);
			toAnchor: (BlElementCenterLeftAnchor element: aPaneElement contentElement).
	self styleLineElement: aLineElement.
	currentLinkElement userData
		at: #outgoingLineElement
		ifPresent: [ :aCollection | aCollection add: aLineElement ]
		ifAbsentPut: [ OrderedCollection with: aLineElement ].
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
			default: [ :aStyle | aStyle border: aLineElement theme default backdropEmphasisBackground ];
			hovered: [ :aStyle | 
				aStyle border: aLineElement theme button focusedFadedBackgroundColor.
				aStyle
					do: [ :aWidget | aWidget zIndex: -1 ]
					after: [ :aWidget | aWidget zIndex: -2 ] ].

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
