Extension { #name : #TBlDevScripterTarget }

{ #category : #'*GToolkit-CommonPager' }
TBlDevScripterTarget >> onPager [
	GtPagerSettings isTreePager
		ifFalse: [ self // GtPager ]
		ifTrue: [ self // GtTreePager ]
]

{ #category : #'*GToolkit-CommonPager' }
TBlDevScripterTarget >> onPagerPaneWithIndex: anInteger [
	GtPagerSettings isTreePager
		ifFalse: [ self // (GtPagerPageElementId indexed: anInteger) ]
		ifTrue: [ (self // GtTreePagerPaneElement)
				@ [ :eachPaneElement | 
					eachPaneElement constraints horizontalTreeFlow depth = anInteger
						and: [ eachPaneElement constraints horizontalTreeFlow row = 1 ] ] ]
]
