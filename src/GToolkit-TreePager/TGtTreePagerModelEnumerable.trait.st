Trait {
	#name : #TGtTreePagerModelEnumerable,
	#category : #'GToolkit-TreePager-Model'
}

{ #category : #'api - enumeration' }
TGtTreePagerModelEnumerable >> allLinkModelsBreadthFirstDo: aBlock [
	| aQueue |
	aQueue := LinkedList withAll: self enumerableLinkModels.
	[ aQueue notEmpty ]
		whileTrue: [ | aLinkModel aResult |
			aLinkModel := aQueue removeFirst.
			aResult := aBlock value: aLinkModel.
			(aResult isBoolean and: [ aResult not ]) ifFalse: [
				aQueue addAll: aLinkModel enumerableLinkModels ] ]
]

{ #category : #'api - enumeration' }
TGtTreePagerModelEnumerable >> allLinkModelsDepthFirstDo: aBlock [
	self enumerableLinkModels
		do: [ :each | each allLinkModelsDepthFirstDo: aBlock ].
	self enumerableLinkModels do: aBlock
]

{ #category : #'api - enumeration' }
TGtTreePagerModelEnumerable >> allPaneModelsBreadthFirstDo: aBlock [
	| aQueue |
	aQueue := LinkedList withAll: self enumerablePaneModels.
	[ aQueue notEmpty ]
		whileTrue: [ | aPaneModel aResult |
			aPaneModel := aQueue removeFirst.
			aResult := aBlock value: aPaneModel.
			(aResult isBoolean and: [ aResult not ]) ifFalse: [
				aQueue addAll: aPaneModel enumerablePaneModels ] ]
]

{ #category : #'api - enumeration' }
TGtTreePagerModelEnumerable >> allPaneModelsDepthFirstDo: aBlock [
	self enumerablePaneModels
		do: [ :each | each allPaneModelsDepthFirstDo: aBlock ].
	self enumerablePaneModels do: aBlock
]

{ #category : #'api - enumeration' }
TGtTreePagerModelEnumerable >> detectLinkModel: aDetectBlock [
	^ self
		detectLinkModel: aDetectBlock
		ifNone: [ NotFound signalFor: aDetectBlock in: self enumerableLinkModels ]
]

{ #category : #'api - enumeration' }
TGtTreePagerModelEnumerable >> detectLinkModel: aDetectBlock ifFound: aFoundBlock ifNone: aNoneBlock [
	self
		allLinkModelsBreadthFirstDo: [ :eachPaneModel | 
			(aDetectBlock value: eachPaneModel)
				ifTrue: [ ^ aFoundBlock value: eachPaneModel ] ].

	^ aNoneBlock value
]

{ #category : #'api - enumeration' }
TGtTreePagerModelEnumerable >> detectLinkModel: aDetectBlock ifNone: aNoneBlock [
	^ self
		detectLinkModel: aDetectBlock
		ifFound: [ :aPaneModel | aPaneModel ]
		ifNone: aNoneBlock
]

{ #category : #'api - enumeration' }
TGtTreePagerModelEnumerable >> detectPaneModel: aDetectBlock [
	^ self
		detectPaneModel: aDetectBlock
		ifNone: [ NotFound signalFor: aDetectBlock in: self enumerablePaneModels ]
]

{ #category : #'api - enumeration' }
TGtTreePagerModelEnumerable >> detectPaneModel: aDetectBlock ifFound: aFoundBlock ifNone: aNoneBlock [
	self
		allPaneModelsBreadthFirstDo: [ :eachPaneModel | 
			(aDetectBlock value: eachPaneModel)
				ifTrue: [ ^ aFoundBlock value: eachPaneModel ] ].

	^ aNoneBlock value
]

{ #category : #'api - enumeration' }
TGtTreePagerModelEnumerable >> detectPaneModel: aDetectBlock ifNone: aNoneBlock [
	^ self
		detectPaneModel: aDetectBlock
		ifFound: [ :aPaneModel | aPaneModel ]
		ifNone: aNoneBlock
]

{ #category : #'api - enumeration' }
TGtTreePagerModelEnumerable >> enumerableLinkModels [
	<return: #Collection of: #TGtTreePagerLinkModel>
	^ self explicitRequirement
]

{ #category : #'api - enumeration' }
TGtTreePagerModelEnumerable >> enumerablePaneModels [
	<return: #Collection of: #GtTreePagerPaneModel>
	^ self explicitRequirement
]
