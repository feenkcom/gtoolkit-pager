Trait {
	#name : #TGtTreePagerWithColumnModel,
	#instVars : [
		'columnModel'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'api - pane model' }
TGtTreePagerWithColumnModel >> onColumnModelChanged [
]

{ #category : #'api - pane model' }
TGtTreePagerWithColumnModel >> paneModel [
	<return: #GtTreePagerColumnModel>
	^ columnModel
]

{ #category : #'api - pane model' }
TGtTreePagerWithColumnModel >> paneModel: aColumnModel [
	columnModel = aColumnModel ifTrue: [ ^ self ].

	columnModel := aColumnModel.
	self onColumnModelChanged
]
