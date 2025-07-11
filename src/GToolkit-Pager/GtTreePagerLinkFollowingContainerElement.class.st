Class {
	#name : #GtTreePagerLinkFollowingContainerElement,
	#superclass : #GtTreePagerLinkBasicElement,
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #factory }
GtTreePagerLinkFollowingContainerElement class >> collapsed [
	^ self new
		addChild: (GtTreePagerLinkFollowingCollapsedElement new
				constraintsDo: [ :c | 
					c margin: (BlInsets left: 10).
					c frame vertical alignCenter.
					c frame horizontal alignLeft ])
]

{ #category : #factory }
GtTreePagerLinkFollowingContainerElement class >> triangle [
	^ self new
		addChild: (GtTreePagerLinkFollowingOutputElement new
				beNormalSize;
				constraintsDo: [ :c | 
					c frame vertical alignCenter.
					c frame horizontal alignLeft ])
]

{ #category : #initialization }
GtTreePagerLinkFollowingContainerElement >> defaultLayout [
	^ BlFrameLayout new
]

{ #category : #'accessing - ui' }
GtTreePagerLinkFollowingContainerElement >> incomingLinkElements [
	^ self children flatCollect: #incomingLinkElements
]

{ #category : #initialization }
GtTreePagerLinkFollowingContainerElement >> initialize [
	super initialize.
	self
		vMatchParent;
		hFitContent
]

{ #category : #'api - pane model' }
GtTreePagerLinkFollowingContainerElement >> onLinkModelChanged [
	self children do: [ :eachChild | 
		eachChild linkModel: self linkModel ]
]

{ #category : #'accessing - ui' }
GtTreePagerLinkFollowingContainerElement >> outgoingLinkElements [
	^ self children flatCollect: #outgoingLinkElements
]
