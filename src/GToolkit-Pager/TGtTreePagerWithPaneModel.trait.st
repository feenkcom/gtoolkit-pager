Trait {
	#name : #TGtTreePagerWithPaneModel,
	#instVars : [
		'paneModel'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'api - pane model' }
TGtTreePagerWithPaneModel >> onPaneModelChanged [
]

{ #category : #'api - pane model' }
TGtTreePagerWithPaneModel >> paneModel [
	^ paneModel
]

{ #category : #'api - pane model' }
TGtTreePagerWithPaneModel >> paneModel: aToolModel [
	paneModel = aToolModel ifTrue: [ ^ self ].

	paneModel ifNotNil: [ self unsubscribeFromPaneModel ].

	paneModel := aToolModel.
	self onPaneModelChanged.
	self subscribeToPaneModel
]

{ #category : #'api - pane model' }
TGtTreePagerWithPaneModel >> subscribeToPaneModel [
]

{ #category : #'api - pane model' }
TGtTreePagerWithPaneModel >> unsubscribeFromPaneModel [
]
