Extension { #name : #TGtPhlowToolSelectionStateHandler }

{ #category : #'*GToolkit-TreePager' }
TGtPhlowToolSelectionStateHandler >> applySelectionState: aSelectionState to: aToolElement treePaneContext: aTreePagerPaneSelectionStateContext [
	"Apply an explicitly defined selected state to an element"

	<parameterType: #GtPhlowToolSelectionState>
	<parameterType: #BlElement>
	<parameterType: #GtTreePagerPaneSelectionStateContext>
	<return: #GtPhlowToolSelectionStateResponse>
	^ self applySelectionState: aSelectionState to: aToolElement
]

{ #category : #'*GToolkit-TreePager' }
TGtPhlowToolSelectionStateHandler >> applySelectionStateTo: aToolElement treePaneContext: aTreePagerPaneSelectionStateContext [
	"Apply a stored selected state to an element"

	<parameterType: #BlElement>
	<parameterType: #GtTreePagerPaneSelectionStateContext>
	self applySelectionStateTo: aToolElement
]

{ #category : #'*GToolkit-TreePager' }
TGtPhlowToolSelectionStateHandler >> asTreePagerPerPaneSelectionStateLabel [
	<return: #String>
	^ 'Per pane selection'
]

{ #category : #'*GToolkit-TreePager' }
TGtPhlowToolSelectionStateHandler >> asTreePagerPerPaneSelectionStateTooltipLabel [
	<return: #String>
	^ 'I store and apply tool and tab selections per pager pane'
]

{ #category : #'*GToolkit-TreePager' }
TGtPhlowToolSelectionStateHandler >> asTreePagerSelectionStateHandlerRegistryItem [
	^ self explicitRequirement
]

{ #category : #'*GToolkit-TreePager' }
TGtPhlowToolSelectionStateHandler >> asTreePagerSettingsItemElement [
	<return: #BlElement>
	^ self explicitRequirement
]

{ #category : #'*GToolkit-TreePager' }
TGtPhlowToolSelectionStateHandler >> similarSettingsOption [
	^ self similarSelectionStateHandler
]

{ #category : #'*GToolkit-TreePager' }
TGtPhlowToolSelectionStateHandler >> storeSelectionStateFrom: aToolElement treePaneContext: aTreePagerPaneSelectionStateContext [
	"Store tool element's selected state"

	<parameterType: #BlElement>
	<parameterType: #GtTreePagerPaneSelectionStateContext>
	self storeSelectionStateFrom: aToolElement
]
