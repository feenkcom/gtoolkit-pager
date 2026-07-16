Extension { #name : #GtPhlowToolCircularSelectionStateHandler }

{ #category : #'*GToolkit-TreePager' }
GtPhlowToolCircularSelectionStateHandler >> asTreePagerPerPaneSelectionStateLabel [
	^ 'Per pane selections'
]

{ #category : #'*GToolkit-TreePager' }
GtPhlowToolCircularSelectionStateHandler >> asTreePagerPerPaneSelectionStateTooltipLabel [
	^ 'I store and apply tool and tab selections per pager pane'
]

{ #category : #'*GToolkit-TreePager' }
GtPhlowToolCircularSelectionStateHandler >> asTreePagerSettingsItemElement [
	^ GtTreePagerToolCircularSelectionStateHandlerElement new
		selectionStateHandler: self
]

{ #category : #'*GToolkit-TreePager' }
GtPhlowToolCircularSelectionStateHandler >> asTreePagerSettingsItemElementForPerPaneHandler: aPerPaneSelectionStateHandler [
	^ GtTreePagerToolPerPaneWithCircularSelectionStateHandlerElement new
		selectionStateHandler: aPerPaneSelectionStateHandler
]
