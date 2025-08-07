Extension { #name : #BlSpace }

{ #category : #'*GToolkit-TreePager' }
BlSpace >> paneInTreePager: aPaneModel [
	"Add a pager element with a given pane model."

	| aTitleBuilder aPagerModel |
	aTitleBuilder := GtPhlowTitleLabelBuilder longLabel: [ aPaneModel title ].
	self title: aTitleBuilder build.
	aPaneModel icon ifNotNil: [ :anIcon | self icon: anIcon ].

	aPagerModel := GtTreePagerModel new paneModel: aPaneModel.

	self addChild: (GtTreePager new pagerModel: aPagerModel)
]
