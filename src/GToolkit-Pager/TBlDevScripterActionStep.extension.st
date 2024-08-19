Extension { #name : #TBlDevScripterActionStep }

{ #category : #'*GToolkit-Pager' }
TBlDevScripterActionStep >> pager [
	^ self
		addStep: (GtPagerStep new
				label: 'Pager';
				referenceSender;
				onParentStepTarget: self;
				onThisOrBreadthFirstChildOfKind: GtPager)
]
