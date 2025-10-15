Extension { #name : #GtPhlowButtonAction }

{ #category : #'*GToolkit-TreePager' }
GtPhlowButtonAction >> asTreePagerToolbarElement: aBlock withHostElement: aTargetElement [
	<return: #BrButton>
	| aButton |
	icon ifNil: [ ^ super asTreePagerToolbarElement: aBlock withHostElement: aTargetElement ].
	
	aButton := GtInspectorRoundButtonStencil new asElement
		exact: GtTreePagerConstants cornerButtonSize.
	
	self configureButton: aButton withHostElement: aTargetElement.
	
	^ aBlock value: aButton
]
