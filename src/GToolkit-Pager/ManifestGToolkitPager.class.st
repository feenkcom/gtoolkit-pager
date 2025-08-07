Class {
	#name : #ManifestGToolkitPager,
	#superclass : #PackageManifest,
	#category : #'GToolkit-Pager-Manifest'
}

{ #category : #accessing }
ManifestGToolkitPager class >> mustNotDependOn [
	^ {'GToolkit-TreePager'.
		'GToolkit-Inspector'}
]
