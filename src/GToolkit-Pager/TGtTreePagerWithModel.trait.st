Trait {
	#name : #TGtTreePagerWithModel,
	#instVars : [
		'pagerModel'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'api - pager model' }
TGtTreePagerWithModel >> hasPagerModel [
	^ pagerModel isNotNil
]

{ #category : #'api - pager model' }
TGtTreePagerWithModel >> onPagerModelChanged [
]

{ #category : #'api - pager model' }
TGtTreePagerWithModel >> pagerModel [
	<return: #GtTreePagerModel>
	^ pagerModel
]

{ #category : #'api - pager model' }
TGtTreePagerWithModel >> pagerModel: aPagerModel [
	pagerModel = aPagerModel ifTrue: [ ^ self ].
	
	pagerModel ifNotNil: [ self unsubscribeFromPagerModel ].
	
	pagerModel := aPagerModel.
	self onPagerModelChanged.
	self subscribeToPagerModel
]

{ #category : #'api - pager model' }
TGtTreePagerWithModel >> subscribeToPagerModel [
]

{ #category : #'api - pager model' }
TGtTreePagerWithModel >> unsubscribeFromPagerModel [
]
