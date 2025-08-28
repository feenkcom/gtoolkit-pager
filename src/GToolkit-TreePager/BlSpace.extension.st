Extension { #name : #BlSpace }

{ #category : #'*GToolkit-TreePager' }
BlSpace >> paneInTreePager: aPaneModel [
	"Add a pager element with a given pane model."

	self panesInTreePager: { aPaneModel } settings: nil
]

{ #category : #'*GToolkit-TreePager' }
BlSpace >> paneInTreePager: aPaneModel settings: aPagerSettings [
	"Add a pager element with a given pane model."

	self panesInTreePager: { aPaneModel } settings: aPagerSettings
]

{ #category : #'*GToolkit-TreePager' }
BlSpace >> panesInTreePager: somePaneModels settings: aPagerSettings [
	"Add a pager element with a given pane models."

	| aTitleBuilder aPagerModel |
	aTitleBuilder := GtPhlowTitleLabelBuilder longLabel: [ somePaneModels anyOne title ].
	self title: aTitleBuilder build.
	somePaneModels anyOne icon ifNotNil: [ :anIcon | self icon: anIcon ].

	aPagerModel := GtTreePagerModel new.
	aPagerSettings ifNotNil: [
		aPagerModel settings copySettingsFrom: aPagerSettings ].
	aPagerModel paneModels: somePaneModels.

	self addChild: (GtTreePager new pagerModel: aPagerModel)
]
