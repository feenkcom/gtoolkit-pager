Trait {
	#name : #TGtPagerPageInstantiator,
	#category : #'GToolkit-Pager-UI'
}

{ #category : #converting }
TGtPagerPageInstantiator >> asPagerPageElement [
	<return: #GtPagerWrapperElement>
	^ GtPagerWrapperElement new
		tool: self;
		embellisher: self newEmbelisher
]

{ #category : #'instance creation' }
TGtPagerPageInstantiator >> newEmbelisher [
	^ GtPagerPageEmbellisher new extension: self newEmbelisherExtension
]

{ #category : #'instance creation' }
TGtPagerPageInstantiator >> newEmbelisherExtension [
	^ GtPagerPageEmbellisherExtension null
]
