Trait {
	#name : #TGtTreePagerWithPaneModel,
	#instVars : [
		'paneModel'
	],
	#category : #'GToolkit-TreePager-Model'
}

{ #category : #'api - pane model' }
TGtTreePagerWithPaneModel >> hasPaneModel [
	^ paneModel isNotNil
]

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
