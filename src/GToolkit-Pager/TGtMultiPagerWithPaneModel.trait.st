Trait {
	#name : #TGtMultiPagerWithPaneModel,
	#instVars : [
		'paneModel'
	],
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #'api - pane model' }
TGtMultiPagerWithPaneModel >> onPaneModelChanged [
]

{ #category : #'api - pane model' }
TGtMultiPagerWithPaneModel >> paneModel [
	<return: #GtMultiPagerPaneModel>
	^ paneModel
]

{ #category : #'api - pane model' }
TGtMultiPagerWithPaneModel >> paneModel: aPaneModel [
	paneModel = aPaneModel ifTrue: [ ^ self ].

	paneModel := aPaneModel.
	self onPaneModelChanged
]
