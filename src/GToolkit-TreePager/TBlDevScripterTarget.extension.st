Extension { #name : #TBlDevScripterTarget }

{ #category : #'*GToolkit-TreePager' }
TBlDevScripterTarget >> onPaneModel: aPaneModel [
	self
		// GtTreePagerFlowPanesElement;
		// GtTreePagerPaneElement;
		@ [ :each | each paneModel = aPaneModel ]
]

{ #category : #'*GToolkit-TreePager' }
TBlDevScripterTarget >> onTreePagerPaneColumn: aColumn [
	self onTreePagerPaneColumn: aColumn row: 1
]

{ #category : #'*GToolkit-TreePager' }
TBlDevScripterTarget >> onTreePagerPaneColumn: aColumn row: aRow [
	self
		// GtTreePagerPaneElement;
		@ [ :eachPaneElement | 
			eachPaneElement constraints horizontalTreeFlow depth = aColumn
				and: [ eachPaneElement constraints horizontalTreeFlow row = aRow ] ]
]
