Extension { #name : #TBlDevScripterActionStep }

{ #category : #'*GToolkit-TreePager' }
TBlDevScripterActionStep >> treePager [
	<scripterActionStep>

	^ self
		addStep: (GtTreePagerStep new
				label: 'Tree pager';
				referenceSender;
				onParentStepTarget: self)
]
