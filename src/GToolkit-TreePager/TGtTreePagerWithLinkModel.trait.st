Trait {
	#name : #TGtTreePagerWithLinkModel,
	#instVars : [
		'linkModel'
	],
	#category : #'GToolkit-TreePager-Model Rest'
}

{ #category : #'api - link model' }
TGtTreePagerWithLinkModel >> hasLinkModel [
	^ linkModel isNotNil
]

{ #category : #'api - link model' }
TGtTreePagerWithLinkModel >> linkModel [
	<return: #GtTreePagerLinkModel>
	^ linkModel
]

{ #category : #'api - link model' }
TGtTreePagerWithLinkModel >> linkModel: aLinkModel [
	linkModel = aLinkModel ifTrue: [ ^ self ].

	linkModel ifNotNil: [ self unsubscribeFromLinkModel ].

	linkModel := aLinkModel.
	self onLinkModelChanged.
	self subscribeToLinkModel
]

{ #category : #'api - link model' }
TGtTreePagerWithLinkModel >> onLinkModelChanged [
]

{ #category : #'api - link model' }
TGtTreePagerWithLinkModel >> subscribeToLinkModel [
]

{ #category : #'api - link model' }
TGtTreePagerWithLinkModel >> unsubscribeFromLinkModel [
]
