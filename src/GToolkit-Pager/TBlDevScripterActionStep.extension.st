Extension { #name : #TBlDevScripterActionStep }

{ #category : #'*GToolkit-Pager' }
TBlDevScripterActionStep >> pager [
	<scripterActionStep>
	
	^ self
		addStep: (GtPagerStep new
				label: 'Pager';
				referenceSender;
				onParentStepTarget: self;
				onThisOrBreadthFirstChildOfKind: GtPager)
]
