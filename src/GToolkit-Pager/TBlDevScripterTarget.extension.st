Extension { #name : #TBlDevScripterTarget }

{ #category : #'*GToolkit-Pager' }
TBlDevScripterTarget >> onPagerPaneWithIndex: anInteger [
	self // (GtPagerPageElementId indexed: anInteger)
]

{ #category : #'*GToolkit-Pager' }
TBlDevScripterTarget >> onPagerToolElement [
	self 
		// GtPagerToolWrapperElementId;
		id: #tool
]
