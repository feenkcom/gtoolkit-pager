Extension { #name : #GtPhlowToolSelectionStateHandler }

{ #category : #'*GToolkit-TreePager' }
GtPhlowToolSelectionStateHandler >> asTreePagerPerPaneSelectionStateLabel [
	^ 'Per pane simple selection'
]

{ #category : #'*GToolkit-TreePager' }
GtPhlowToolSelectionStateHandler >> asTreePagerPerPaneSelectionStateTooltipLabel [
	^ 'I store and apply tool and tab selection per pager pane'
]

{ #category : #'*GToolkit-TreePager' }
GtPhlowToolSelectionStateHandler >> asTreePagerSettingsItemElement [
	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude new;
		fitContent;
		text: 'Simple selection'
]
