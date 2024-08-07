Extension { #name : #TBlDevScripterActionStep }

{ #category : #'*GToolkit-Pager' }
TBlDevScripterActionStep >> inspectorStep [
	^ self
		addStep: (GtInspectorStep new
				label: 'Inspector';
				referenceSender)
]

{ #category : #'*GToolkit-Pager' }
TBlDevScripterActionStep >> pager [
	^ self
		addStep: (GtPagerStep new
				label: 'Pager';
				referenceSender;
				onParentStepTarget: self;
				onThisOrBreadthFirstChildOfKind: GtPager)
]
