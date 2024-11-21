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

{ #category : #'steps - interactions' }
GtPagerStep >> setPageAt: aPageIndex widthInSpaceRatio: aRatioNumber [
	"Set pager page width to `aSpace width * aRatioNumber`.
	aRatioNumber is a number between 0.0 and 1.0"

	^ self do
		block: [ :aPage :aUserData :aScripter | 
			aPage width: (aScripter space width * aRatioNumber) asFloat ];
		// (GtPagerPageElementId indexed: aPageIndex)
]
