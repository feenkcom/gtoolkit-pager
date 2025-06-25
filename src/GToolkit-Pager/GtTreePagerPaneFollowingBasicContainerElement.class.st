Class {
	#name : #GtTreePagerPaneFollowingBasicContainerElement,
	#superclass : #GtTreePagerPaneBasicElement,
	#instVars : [
		'expandedElement',
		'collapsedElement'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #factory }
GtTreePagerPaneFollowingBasicContainerElement class >> collapsed [
	^ self new
		addChild: (GtTreePagerPaneFollowingCollapsedElement new
				constraintsDo: [ :c | 
					c margin: (BlInsets left: 10).
					c frame vertical alignCenter.
					c frame horizontal alignLeft ])
]

{ #category : #factory }
GtTreePagerPaneFollowingBasicContainerElement class >> triangle [
	^ self new
		addChild: (GtTreePagerPaneFollowingOutputElement new
				beNormalSize;
				constraintsDo: [ :c | 
					c frame vertical alignCenter.
					c frame horizontal alignLeft ])
]

{ #category : #initialization }
GtTreePagerPaneFollowingBasicContainerElement >> defaultLayout [
	^ BlFrameLayout new
]

{ #category : #initialization }
GtTreePagerPaneFollowingBasicContainerElement >> initialize [
	super initialize.
	self
		vMatchParent;
		hFitContent
]

{ #category : #'api - pane model' }
GtTreePagerPaneFollowingBasicContainerElement >> onPaneModelChanged [
	self children do: [ :eachChild | 
		eachChild paneModel: self paneModel ]
]
