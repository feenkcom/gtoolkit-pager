Extension { #name : #GtPhlowAction }

{ #category : #'*GToolkit-TreePager' }
GtPhlowAction >> asTreePagerToolbarElement: aBlock withHostElement: aTargetElement [
	"Return an element that represents the action in Bloc space, e.g., a button.
	Such element is used in the tree pager."

	<return: #BlElement>
	^ self asCircularElement: aBlock withHostElement: aTargetElement
]
