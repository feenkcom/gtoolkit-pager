Trait {
	#name : #TGtTreePagerWithModel,
	#instVars : [
		'pagerModel'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'api - pager model' }
TGtTreePagerWithModel >> onPagerModelChanged [
]

{ #category : #'api - pager model' }
TGtTreePagerWithModel >> pagerModel [
	^ pagerModel
]

{ #category : #'api - pager model' }
TGtTreePagerWithModel >> pagerModel: aPagerModel [
	pagerModel = aPagerModel ifTrue: [ ^ self ].
	
	pagerModel := aPagerModel.
	self onPagerModelChanged.
]
