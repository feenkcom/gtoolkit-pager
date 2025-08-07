Class {
	#name : #GtTreePagerPaneNavigationContext,
	#superclass : #Object,
	#traits : 'TGtPagerNavigationContext',
	#classTraits : 'TGtPagerNavigationContext classTrait',
	#instVars : [
		'pagerElement',
		'paneElement',
		'previousContext'
	],
	#category : #'GToolkit-TreePager-Support'
}

{ #category : #'api - navigation' }
GtTreePagerPaneNavigationContext >> allPreviousContextsDo: aBlock [
	self previousContext ifNotNil: [ :aContext | 
		aContext withAllNavigationContextsDo: aBlock ]
]

{ #category : #private }
GtTreePagerPaneNavigationContext >> findPreviousContext [
	self paneModel ifNil: [ ^ nil ].
	self paneModel allPreviousPanesDo: [ :eachPaneModel | 
		self pagerElement
			usedOrCachedChildNodeForPaneModel: eachPaneModel
			ifFound: [ :aPaneElement | 
				aPaneElement contentElementDo: [ :aContentElement | 
					(eachPaneModel = self paneModel previousPane) ifTrue: [ 
						previousContext := aContentElement navigationContext ].
					^ aContentElement navigationContext ] ]
			ifNone: [  ] ].

	^ nil
]

{ #category : #accessing }
GtTreePagerPaneNavigationContext >> pagerElement [
	^ pagerElement
]

{ #category : #accessing }
GtTreePagerPaneNavigationContext >> pagerElement: aPagerElement [
	pagerElement := aPagerElement
]

{ #category : #accessing }
GtTreePagerPaneNavigationContext >> paneElement [
	^ paneElement
]

{ #category : #accessing }
GtTreePagerPaneNavigationContext >> paneElement: aPaneElement [
	paneElement := aPaneElement
]

{ #category : #accessing }
GtTreePagerPaneNavigationContext >> paneModel [
	^ self paneElement paneModel
]

{ #category : #'api - phlow' }
GtTreePagerPaneNavigationContext >> phlowViewModel [
	<return: #TGtPhlowToolViewModel>
	self paneElement realToolElementDo: [ :aToolElement |
		^ aToolElement phlow toolViewModel ].
		
	^ nil
]

{ #category : #accessing }
GtTreePagerPaneNavigationContext >> previousContext [
	<return: #GtTreePagerPaneNavigationContext or: nil>
	^ previousContext ifNil: [ self findPreviousContext ]
]
