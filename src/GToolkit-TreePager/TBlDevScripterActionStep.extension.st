Extension { #name : #TBlDevScripterActionStep }

{ #category : #'*GToolkit-TreePager' }
TBlDevScripterActionStep >> treePager [
	^ self
		addStep: (GtTreePagerStep new
				label: 'Tree pager';
				referenceSender;
				onParentStepTarget: self)
]
