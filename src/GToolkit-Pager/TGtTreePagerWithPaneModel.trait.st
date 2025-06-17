Trait {
	#name : #TGtTreePagerWithPaneModel,
	#instVars : [
		'paneModel'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'api - tool model' }
TGtTreePagerWithPaneModel >> onPaneModelChanged [
]

{ #category : #'api - tool model' }
TGtTreePagerWithPaneModel >> paneModel [
	^ paneModel
]

{ #category : #'api - tool model' }
TGtTreePagerWithPaneModel >> paneModel: aToolModel [
	paneModel = aToolModel ifTrue: [ ^ self ].

	paneModel ifNotNil: [ self unsubscribeFromPaneModel ].

	paneModel := aToolModel.
	self onPaneModelChanged.
	self subscribeToPaneModel
]

{ #category : #'api - tool model' }
TGtTreePagerWithPaneModel >> subscribeToPaneModel [
]

{ #category : #'api - tool model' }
TGtTreePagerWithPaneModel >> unsubscribeFromPaneModel [
]
