Trait {
	#name : #TGtPagerPageInstantiator,
	#category : #'GToolkit-Pager-UI'
}

{ #category : #converting }
TGtPagerPageInstantiator >> asPagerPageElement [
	<return: #GtPagerWrapperElement>
	^ GtPagerWrapperElement new
		tool: self;
		embellisher: self newEmbellisher
]

{ #category : #'instance creation' }
TGtPagerPageInstantiator >> newEmbellisher [
	^ GtPagerPageEmbellisher new extension: self newEmbellisherExtension
]

{ #category : #'instance creation' }
TGtPagerPageInstantiator >> newEmbellisherExtension [
	^ GtPagerPageEmbellisherExtension null
]
