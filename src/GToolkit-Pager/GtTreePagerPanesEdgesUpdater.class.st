Class {
	#name : #GtTreePagerPanesEdgesUpdater,
	#superclass : #Object,
	#instVars : [
		'panesElement',
		'pagerModel'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #private }
GtTreePagerPanesEdgesUpdater >> collectEdgeFromCollapsed: aFromPane toCollapsedPane: aToPane in: aStream [
	| aFromPaneElement aFromTriangleQuery aFromTriangleElement aLineElement aToCollapsedQuery aToCollapsedElement |
	aFromPaneElement := self panesElement children
			detect: [ :eachElement | 
				eachElement graph isNode
					and: [ eachElement paneModel = aFromPane previousExpandedPane ] ]
			ifFound: [ :anElement | anElement ]
			ifNone: [ NotFound signalFor: aFromPane in: self panesElement children ].

	aFromTriangleQuery := (aFromPaneElement query
			// GtTreePagerPaneFollowingCollapsedElement
			// GtTreePagerPaneFollowingOutputElement)
			@ [ :each | each linkModel paneModel = aToPane ].
	aFromTriangleQuery result
		ifEmpty: [ NotFound signalFor: aToPane in: aFromTriangleQuery ].
	aFromTriangleElement := aFromTriangleQuery result anyOne.

	aToCollapsedQuery := (aFromPaneElement query
			// GtTreePagerPaneFollowingCollapsedElement
			/ GtTreePagerPaneFollowingRectangleElement)
			@ [ :each | each linkModel paneModel = aToPane ].
	aToCollapsedQuery result
		ifEmpty: [ NotFound signalFor: aToPane in: aToCollapsedQuery ].
	aToCollapsedElement := aToCollapsedQuery result anyOne.

	aLineElement := BlManhattanLineElement new
			in: [ :theElement | 
				theElement graph
					beEdge;
					model: aFromPane -> aToPane ];
			zIndex: -1;
			border: (BlBorder paint: self panesElement theme button fadedBackgroundColor);
			beAutomatic;
			fixedDistance: 10;
			cornerRadius: 10;
			fromAnchor: (BlElementBottomCenterAnchor element: aFromTriangleElement);
			toAnchor: (BlElementTopCenterAnchor element: aToCollapsedElement).

	self styleLineElement: aLineElement.

	aStream nextPut: aLineElement
]

{ #category : #private }
GtTreePagerPanesEdgesUpdater >> collectEdgeFromCollapsed: aFromPane toExpandedPane: aToPane in: aStream [
	| aFromElement aToElement aFromTriangleQuery aFromTriangleElement aLineElement |
	aFromElement := self panesElement children
			detect: [ :eachElement | 
				eachElement graph isNode
					and: [ eachElement paneModel = aFromPane previousExpandedPane ] ]
			ifFound: [ :anElement | anElement ]
			ifNone: [ NotFound signalFor: aFromPane in: self panesElement children ].
	aToElement := self panesElement children
			detect: [ :eachElement | eachElement graph isNode and: [ eachElement paneModel = aToPane ] ]
			ifFound: [ :anElement | anElement ]
			ifNone: [ NotFound signalFor: aToPane in: self panesElement children ].

	aFromTriangleQuery := (aFromElement query
			// GtTreePagerPaneFollowingCollapsedElement
			// GtTreePagerPaneFollowingOutputElement)
			@ [ :each | each linkModel paneModel = aToPane ].
	aFromTriangleQuery result
		ifEmpty: [ NotFound signalFor: aToPane in: aFromTriangleQuery ].
	aFromTriangleElement := aFromTriangleQuery result anyOne.

	aLineElement := BlManhattanLineElement new
			in: [ :theElement | 
				theElement graph
					beEdge;
					model: aFromPane -> aToPane ];
			zIndex: -1;
			border: (BlBorder paint: self panesElement theme button fadedBackgroundColor);
			beFixedTo;
			fixedDistance: 10;
			cornerRadius: 10;
			fromAnchor: (BlElementCenterRightAnchor element: aFromTriangleElement);
			toAnchor: (BlElementCenterLeftAnchor element: aToElement).

	self styleLineElement: aLineElement.

	aStream nextPut: aLineElement
]

{ #category : #private }
GtTreePagerPanesEdgesUpdater >> collectEdgeFromTriangle: aFromPane toCollapsedPane: aToPane in: aStream [
	| aFromPaneElement aFromTriangleQuery aFromTriangleElement aLineElement aToCollapsedQuery aToCollapsedElement |
	aFromPaneElement := self panesElement children
			detect: [ :eachElement | eachElement graph isNode and: [ eachElement paneModel = aFromPane ] ]
			ifFound: [ :anElement | anElement ]
			ifNone: [ NotFound signalFor: aFromPane in: self panesElement children ].

	aFromTriangleQuery := (aFromPaneElement query
			// GtTreePagerPaneFollowingOutputElement)
			@ [ :each | each linkModel paneModel = aToPane ].
	aFromTriangleQuery result
		ifEmpty: [ NotFound signalFor: aToPane in: aFromTriangleQuery ].
	aFromTriangleElement := aFromTriangleQuery result anyOne.

	aToCollapsedQuery := (aFromPaneElement query
			// GtTreePagerPaneFollowingCollapsedElement
			/ GtTreePagerPaneFollowingRectangleElement)
			@ [ :each | each linkModel paneModel = aToPane ].
	aToCollapsedQuery result
		ifEmpty: [ NotFound signalFor: aToPane in: aToCollapsedQuery ].
	aToCollapsedElement := aToCollapsedQuery result anyOne.

	aLineElement := BlManhattanLineElement new
			in: [ :theElement | 
				theElement graph
					beEdge;
					model: aFromPane -> aToPane ];
			zIndex: -1;
			border: (BlBorder paint: self panesElement theme button fadedBackgroundColor);
			beAutomatic;
			fixedDistance: 10;
			cornerRadius: 10;
			fromAnchor: (BlElementCenterRightAnchor element: aFromTriangleElement);
			toAnchor: (BlElementTopCenterAnchor element: aToCollapsedElement).

	self styleLineElement: aLineElement.


	aStream nextPut: aLineElement
]

{ #category : #private }
GtTreePagerPanesEdgesUpdater >> collectEdgeFromTriangle: aFromPane toExpandedPane: aToPane in: aStream [
	| aFromElement aToElement aFromTriangleQuery aFromTriangleElement aLineElement |
	aFromElement := self panesElement children
			detect: [ :eachElement | eachElement graph isNode and: [ eachElement paneModel = aFromPane ] ]
			ifFound: [ :anElement | anElement ]
			ifNone: [ NotFound signalFor: aFromPane in: self panesElement children ].
	aToElement := self panesElement children
			detect: [ :eachElement | eachElement graph isNode and: [ eachElement paneModel = aToPane ] ]
			ifFound: [ :anElement | anElement ]
			ifNone: [ NotFound signalFor: aToPane in: self panesElement children ].

	aFromTriangleQuery := (aFromElement query
			// GtTreePagerPaneFollowingOutputElement)
			@ [ :each | each linkModel paneModel = aToPane ].
	aFromTriangleQuery result
		ifEmpty: [ NotFound signalFor: aToPane in: aFromTriangleQuery ].
	aFromTriangleElement := aFromTriangleQuery result anyOne.

	aLineElement := BlManhattanLineElement new
			in: [ :theElement | 
				theElement graph
					beEdge;
					model: aFromPane -> aToPane ];
			zIndex: -1;
			border: (BlBorder paint: self panesElement theme button fadedBackgroundColor);
			beFixedTo;
			fixedDistance: 10;
			cornerRadius: 10;
			fromAnchor: (BlElementCenterRightAnchor element: aFromTriangleElement);
			toAnchor: (BlElementCenterLeftAnchor element: aToElement).
			
	self styleLineElement: aLineElement.
	
	aStream nextPut: aLineElement
]

{ #category : #private }
GtTreePagerPanesEdgesUpdater >> collectEdgesFrom: aFromPane in: aStream [
	aFromPane isCollapsed
		ifTrue: [ self collectEdgesFromCollapsed: aFromPane in: aStream ]
		ifFalse: [ self collectEdgesFromExpanded: aFromPane in: aStream ]
]

{ #category : #private }
GtTreePagerPanesEdgesUpdater >> collectEdgesFromCollapsed: aFromPane in: aStream [
	aFromPane followingPanes
		do: [ :eachToPane | 
			eachToPane isCollapsed
				ifTrue: [ self
						collectEdgeFromCollapsed: aFromPane
						toCollapsedPane: eachToPane
						in: aStream ]
				ifFalse: [ self
						collectEdgeFromCollapsed: aFromPane
						toExpandedPane: eachToPane
						in: aStream ] ]
]

{ #category : #private }
GtTreePagerPanesEdgesUpdater >> collectEdgesFromExpanded: aFromPane in: aStream [
	aFromPane followingPanes
		do: [ :eachToPane | 
			eachToPane isCollapsed
				ifTrue: [ self
						collectEdgeFromTriangle: aFromPane
						toCollapsedPane: eachToPane
						in: aStream ]
				ifFalse: [ self
						collectEdgeFromTriangle: aFromPane
						toExpandedPane: eachToPane
						in: aStream ] ]
]

{ #category : #accessing }
GtTreePagerPanesEdgesUpdater >> edgeElementsToDisplay [
	^ Array
		streamContents: [ :aStream | 
			self pagerModel
				allPanesBreadthFirstDo: [ :eachFromPane | self collectEdgesFrom: eachFromPane in: aStream ] ]
]

{ #category : #accessing }
GtTreePagerPanesEdgesUpdater >> pagerModel [
	^ pagerModel ifNil: [ self panesElement ifNotNil: #pagerModel ]
]

{ #category : #accessing }
GtTreePagerPanesEdgesUpdater >> pagerModel: anObject [
	pagerModel := anObject
]

{ #category : #accessing }
GtTreePagerPanesEdgesUpdater >> panesElement [
	^ panesElement
]

{ #category : #accessing }
GtTreePagerPanesEdgesUpdater >> panesElement: anObject [
	panesElement := anObject
]

{ #category : #private }
GtTreePagerPanesEdgesUpdater >> styleLineElement: aLineElement [
	| anAptitude |
	anAptitude := BrLazyStyleCommonAptitude new
			default: [ :aStyle | aStyle border: aLineElement theme button fadedBackgroundColor ];
			hovered: [ :aStyle | aStyle border: aLineElement theme button focusedFadedBackgroundColor ].

	aLineElement addAptitude: anAptitude
]

{ #category : #building }
GtTreePagerPanesEdgesUpdater >> update [
	| someEdgeElements edgeElementsToRemove |
	someEdgeElements := self edgeElementsToDisplay.

	edgeElementsToRemove := self panesElement children
			collect: [ :eachElement | eachElement graph isEdge ].
	self panesElement children removeAll: edgeElementsToRemove.
	self panesElement addChildren: someEdgeElements
]
