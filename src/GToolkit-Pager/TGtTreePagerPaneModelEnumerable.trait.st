Trait {
	#name : #TGtTreePagerPaneModelEnumerable,
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'api - enumeration' }
TGtTreePagerPaneModelEnumerable >> allPanesBreadthFirstDo: aBlock [
	| aQueue |
	aQueue := LinkedList withAll: self enumerablePaneModels.
	[ aQueue notEmpty ]
		whileTrue: [ | aPaneModel |
			aPaneModel := aQueue removeFirst.
			aBlock value: aPaneModel.
			aQueue addAll: aPaneModel enumerablePaneModels ]
]

{ #category : #'api - enumeration' }
TGtTreePagerPaneModelEnumerable >> detectPaneModel: aDetectBlock [
	^ self
		detectPaneModel: aDetectBlock
		ifNone: [ NotFound signalFor: aDetectBlock in: self enumerablePaneModels ]
]

{ #category : #'api - enumeration' }
TGtTreePagerPaneModelEnumerable >> detectPaneModel: aDetectBlock ifFound: aFoundBlock ifNone: aNoneBlock [
	self
		allPanesBreadthFirstDo: [ :eachPaneModel | 
			(aDetectBlock value: eachPaneModel)
				ifTrue: [ ^ aFoundBlock value: eachPaneModel ] ].

	^ aNoneBlock value
]

{ #category : #'api - enumeration' }
TGtTreePagerPaneModelEnumerable >> detectPaneModel: aDetectBlock ifNone: aNoneBlock [
	^ self
		detectPaneModel: aDetectBlock
		ifFound: [ :aPaneModel | aPaneModel ]
		ifNone: aNoneBlock
]

{ #category : #'api - enumeration' }
TGtTreePagerPaneModelEnumerable >> enumerablePaneModels [
	<return: #Collection of: #GtTreePagerPaneModel>
	^ self explicitRequirement
]
