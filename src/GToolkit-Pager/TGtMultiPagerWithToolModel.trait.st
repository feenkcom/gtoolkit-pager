Trait {
	#name : #TGtMultiPagerWithToolModel,
	#instVars : [
		'toolModel'
	],
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #'api - tool model' }
TGtMultiPagerWithToolModel >> onToolModelChanged [
]

{ #category : #'api - tool model' }
TGtMultiPagerWithToolModel >> subscribeToToolModel [
]

{ #category : #'api - tool model' }
TGtMultiPagerWithToolModel >> toolModel [
	^ toolModel
]

{ #category : #'api - tool model' }
TGtMultiPagerWithToolModel >> toolModel: aToolModel [
	toolModel = aToolModel ifTrue: [ ^ self ].

	toolModel ifNotNil: [ self unsubscribeFromToolModel ].

	toolModel := aToolModel.
	self onToolModelChanged.
	self subscribeToToolModel
]

{ #category : #'api - tool model' }
TGtMultiPagerWithToolModel >> unsubscribeFromToolModel [
]
