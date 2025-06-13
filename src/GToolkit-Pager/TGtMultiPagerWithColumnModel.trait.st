Trait {
	#name : #TGtMultiPagerWithColumnModel,
	#instVars : [
		'columnModel'
	],
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #'api - pane model' }
TGtMultiPagerWithColumnModel >> onColumnModelChanged [
]

{ #category : #'api - pane model' }
TGtMultiPagerWithColumnModel >> paneModel [
	<return: #GtMultiPagerColumnModel>
	^ columnModel
]

{ #category : #'api - pane model' }
TGtMultiPagerWithColumnModel >> paneModel: aColumnModel [
	columnModel = aColumnModel ifTrue: [ ^ self ].

	columnModel := aColumnModel.
	self onColumnModelChanged
]
