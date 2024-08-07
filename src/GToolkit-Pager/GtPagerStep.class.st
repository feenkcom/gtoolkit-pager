Class {
	#name : #GtPagerStep,
	#superclass : #BlDevScripterToolActionStep,
	#category : #'GToolkit-Pager-Scripter'
}

{ #category : #'steps - checks' }
GtPagerStep >> assertPageCountIs: aNumber [
	^ self assert
		label: ('Assert pager page count is {1}' format: {aNumber});
		value: [ :aPager | aPager pages size ] equals: aNumber;
		referenceSender;
		onParentStepTarget: self;
		onThisOrBreadthFirstChildOfKind: GtPager
]
