Class {
	#name : #GtTreePagerGeometryCountdownAptitude,
	#superclass : #BrCountdownGeometryAptitude,
	#category : #'GToolkit-TreePager-Support'
}

{ #category : #'as yet unclassified' }
GtTreePagerGeometryCountdownAptitude >> newDefaultAnimation [
	^ super newDefaultAnimation
		duration: GtTreePagerConstants replacedLinkRestoration
]

{ #category : #'private - updating' }
GtTreePagerGeometryCountdownAptitude >> startAnimation [
	GtTreePagerAnimationFeatures
		ifEnabled: [ super startAnimation ]
		ifDisabled: [  ]
]
