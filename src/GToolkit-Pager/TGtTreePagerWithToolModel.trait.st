Trait {
	#name : #TGtTreePagerWithToolModel,
	#instVars : [
		'toolModel'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'api - tool model' }
TGtTreePagerWithToolModel >> onToolModelChanged [
]

{ #category : #'api - tool model' }
TGtTreePagerWithToolModel >> subscribeToToolModel [
]

{ #category : #'api - tool model' }
TGtTreePagerWithToolModel >> toolModel [
	^ toolModel
]

{ #category : #'api - tool model' }
TGtTreePagerWithToolModel >> toolModel: aToolModel [
	toolModel = aToolModel ifTrue: [ ^ self ].

	toolModel ifNotNil: [ self unsubscribeFromToolModel ].

	toolModel := aToolModel.
	self onToolModelChanged.
	self subscribeToToolModel
]

{ #category : #'api - tool model' }
TGtTreePagerWithToolModel >> unsubscribeFromToolModel [
]
