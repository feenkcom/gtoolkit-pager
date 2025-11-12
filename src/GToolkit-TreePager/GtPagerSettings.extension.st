Extension { #name : #GtPagerSettings }

{ #category : #'*GToolkit-TreePager' }
GtPagerSettings class >> defaultPager [
	^ GtTreePager
]

{ #category : #'*GToolkit-TreePager' }
GtPagerSettings class >> useTreePager [
	self usedPager: GtTreePager
]
