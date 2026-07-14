Extension { #name : #GtPhlowToolEmptySelectionStateHandler }

{ #category : #'*GToolkit-TreePager' }
GtPhlowToolEmptySelectionStateHandler >> asTreePagerPerPaneSelectionStateLabel [
	^ 'No selection'
]

{ #category : #'*GToolkit-TreePager' }
GtPhlowToolEmptySelectionStateHandler >> asTreePagerSettingsItemElement [
	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude new;
		fitContent;
		text: 'No selection'
]
