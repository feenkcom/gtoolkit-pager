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
	^ GtPagerSettings usedPager createOn: self
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
	| aSpace |
	aSpace := BlSpace new
			inPager: self;
			withCommonSettings;
			title: aTitle;
			show.

	^ aSpace root childAt: 1
]

{ #category : #opening }
TGtPagerPageInstantiator >> openInPagerWithTitle: aTitle from: aSourceElement [
	<return: #GtPager>
	| aSpace |
	aSpace := BlSpace new
			inPager: self;
			withCommonSettings;
			title: aTitle;
			showFrom: aSourceElement.

	^ aSpace root childAt: 1
]

{ #category : #opening }
TGtPagerPageInstantiator >> pagerWindowTitle [
	<return: #String>
	^ self printString
]
