Class {
	#name : #GtTreePagerGeometryCountdownAptitude,
	#superclass : #BrCountdownGeometryAptitude,
	#category : #'GToolkit-TreePager-Support'
}

{ #category : #'as yet unclassified' }
GtTreePagerGeometryCountdownAptitude >> newDefaultAnimation [
	^ super newDefaultAnimation
		duration: GtTreePagerSettings replacedLinkRestoration
]

{ #category : #'private - updating' }
GtTreePagerGeometryCountdownAptitude >> startAnimation [
	GtTreePagerAnimationFeatures
		ifEnabled: [ super startAnimation ]
		ifDisabled: [  ]
]
