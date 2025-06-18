Class {
	#name : #GtTreePagerFollowingContainerElement,
	#superclass : #GtTreePagerPaneBasicElement,
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #initialization }
GtTreePagerFollowingContainerElement >> defaultLayout [
	^ BlFrameLayout new
]

{ #category : #initialization }
GtTreePagerFollowingContainerElement >> initialize [
	super initialize.
	self
		vMatchParent;
		hFitContent;
		addChild: (GtTreePagerFollowingTriangleElement new
				constraintsDo: [ :c | 
					c frame vertical alignCenter.
					c frame horizontal alignLeft ])
]

{ #category : #'api - pane model' }
GtTreePagerFollowingContainerElement >> onPaneModelChanged [
	(self childAt: 1) paneModel: self paneModel
]
