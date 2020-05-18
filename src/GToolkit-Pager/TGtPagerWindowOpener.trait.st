Trait {
	#name : #TGtPagerWindowOpener,
	#traits : 'TGtPagerPageInstantiator',
	#classTraits : 'TGtPagerPageInstantiator classTrait',
	#category : #'GToolkit-Pager-UI'
}

{ #category : #'window creation' }
TGtPagerWindowOpener classSide >> createOn: anObject [
	| aTool |
	aTool :=  self newOn: anObject.
	^ aTool createInPager
]

{ #category : #'instance creation' }
TGtPagerWindowOpener classSide >> newOn: anObject [
	"create a tool element on a given object"
	^ self explicitRequirement
]

{ #category : #'window creation' }
TGtPagerWindowOpener classSide >> openOn: anObject [
	| aTool |
	aTool :=  self newOn: anObject.
	^ aTool openInPager
]

{ #category : #'window creation' }
TGtPagerWindowOpener classSide >> openOn: anObject from: aSourceElement [
	| aTool |
	aTool :=  self newOn: anObject.
	^ aTool openInPagerFrom: aSourceElement
]

{ #category : #'window creation' }
TGtPagerWindowOpener classSide >> openOn: anObject title: aTitle [
	| aTool |
	aTool :=  self newOn: anObject.
	^ aTool openInPagerWithTitle: aTitle
]

{ #category : #'window creation' }
TGtPagerWindowOpener classSide >> openOn: anObject title: aTitle from: aSourceElement [
	| aTool |
	aTool :=  self newOn: anObject.
	^ aTool openInPagerWithTitle: aTitle from: aSourceElement
]
