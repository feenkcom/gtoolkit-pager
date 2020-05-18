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

{ #category : #opening }
TGtPagerPageInstantiator >> createInPager [
	<return: #GtPager>
	^ self createInPagerWithTitle: self pagerWindowTitle
]

{ #category : #opening }
TGtPagerPageInstantiator >> createInPagerWithTitle: aTitle [
	<return: #GtPager>
	^ GtPager createOn: self asPagerPageElement
]

{ #category : #'instance creation' }
TGtPagerPageInstantiator >> newEmbellisher [
	^ GtPagerPageEmbellisher new extension: self newEmbellisherExtension
]

{ #category : #'instance creation' }
TGtPagerPageInstantiator >> newEmbellisherExtension [
	^ GtPagerPageEmbellisherExtension null
]

{ #category : #opening }
TGtPagerPageInstantiator >> openInPager [
	<return: #GtPager>
	^ self openInPagerWithTitle: self pagerWindowTitle.
]

{ #category : #opening }
TGtPagerPageInstantiator >> openInPagerFrom: aSourceElement [
	<return: #GtPager>
	^ self 
		openInPagerWithTitle: self pagerWindowTitle
		from: aSourceElement
]

{ #category : #opening }
TGtPagerPageInstantiator >> openInPagerWithTitle: aTitle [
	<return: #GtPager>
	^ GtPager 
		openOn: self asPagerPageElement 
		title: aTitle
]

{ #category : #opening }
TGtPagerPageInstantiator >> openInPagerWithTitle: aTitle from: aSourceElement [
	<return: #GtPager>
	^ GtPager 
		openOn: self asPagerPageElement 
		title: aTitle
		from: aSourceElement.
]

{ #category : #opening }
TGtPagerPageInstantiator >> pagerWindowTitle [
	<return: #String>
	^ self printString
]
