Extension { #name : #GtPhlowToolCircularSelectionStateHandler }

{ #category : #'*GToolkit-TreePager' }
GtPhlowToolCircularSelectionStateHandler >> asTreePagerPerPaneSelectionStateLabel [
	^ 'Per pane selections'
]

{ #category : #'*GToolkit-TreePager' }
GtPhlowToolCircularSelectionStateHandler >> asTreePagerSettingsItemElement [
	^ GtTreePagerToolCircularSelectionStateHandlerElement new
		selectionStateHandler: self
]
