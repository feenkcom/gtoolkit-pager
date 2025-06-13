Trait {
	#name : #TGtMultiPagerWithModel,
	#instVars : [
		'pagerModel'
	],
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #'api - pager model' }
TGtMultiPagerWithModel >> onPagerModelChanged [
]

{ #category : #'api - pager model' }
TGtMultiPagerWithModel >> pagerModel [
	^ pagerModel
]

{ #category : #'api - pager model' }
TGtMultiPagerWithModel >> pagerModel: aPagerModel [
	pagerModel = aPagerModel ifTrue: [ ^ self ].
	
	pagerModel := aPagerModel.
	self onPagerModelChanged.
]
