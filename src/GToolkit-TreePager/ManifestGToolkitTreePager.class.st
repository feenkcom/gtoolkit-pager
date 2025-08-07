Class {
	#name : #ManifestGToolkitTreePager,
	#superclass : #PackageManifest,
	#category : #'GToolkit-TreePager-Manifest'
}

{ #category : #accessing }
ManifestGToolkitTreePager class >> mustNotDependOn [
	^ {'GToolkit-Pager'.
		'GToolkit-Inspector'}
]
