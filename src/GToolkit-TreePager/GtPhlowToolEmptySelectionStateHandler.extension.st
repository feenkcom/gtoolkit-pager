Extension { #name : #GtPhlowToolEmptySelectionStateHandler }

{ #category : #'*GToolkit-TreePager' }
GtPhlowToolEmptySelectionStateHandler >> asTreePagerPerPaneSelectionStateLabel [
	^ 'No selection'
]

{ #category : #'*GToolkit-TreePager' }
GtPhlowToolEmptySelectionStateHandler >> asTreePagerPerPaneSelectionStateTooltipLabel [
	^ 'I do not store neither apply any tool and tab selection'
]

{ #category : #'*GToolkit-TreePager' }
GtPhlowToolEmptySelectionStateHandler >> asTreePagerSettingsItemElement [
	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude new;
		fitContent;
		text: 'No selection'
]
