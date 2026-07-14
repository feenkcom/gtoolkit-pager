Extension { #name : #GtPhlowToolSelectionStateHandler }

{ #category : #'*GToolkit-TreePager' }
GtPhlowToolSelectionStateHandler >> asTreePagerPerPaneSelectionStateLabel [
	^ 'Per pane simple selection'
]

{ #category : #'*GToolkit-TreePager' }
GtPhlowToolSelectionStateHandler >> asTreePagerSettingsItemElement [
	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude new;
		fitContent;
		text: 'Simple selection'
]
