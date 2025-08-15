Trait {
	#name : #TGtTreePagerLinkModelState,
	#category : #'GToolkit-TreePager-Model'
}

{ #category : #'api - state' }
TGtTreePagerLinkModelState >> isActive [
	"Return true if link model is active.
	Active links are replaced with new spawned or selected links."

	<return: #Boolean>
	^ self state isActive
]

{ #category : #'api - state' }
TGtTreePagerLinkModelState >> isCollapsed [
	"Return true if link model is collapsed.
	Collapsed panes are not spawned (displayed). Their following panes are displayed if spawned"

	<return: #Boolean>
	^ self state isCollapsed
]

{ #category : #'api - state' }
TGtTreePagerLinkModelState >> isExpanded [
	"Return true if link model is expanded.
	Expanded panes may be spawned (displayed).
	It is better to ask `#isSpawned` in order to know
	whether a pane is displayed."

	<return: #Boolean>
	^ self state isExpanded
]

{ #category : #'api - state' }
TGtTreePagerLinkModelState >> isHidden [
	"Return true if link model is hidden.
	Hidden panes and their following panes are not displayed."

	<return: #Boolean>
	^ self state isHidden
]

{ #category : #'api - state' }
TGtTreePagerLinkModelState >> isSelected [
	"Return true if link model is selected.
	Selected links are replaced with new spawned or selected links."

	<return: #Boolean>
	^ self state isSelected
]

{ #category : #'api - state' }
TGtTreePagerLinkModelState >> isSpawned [
	"Return true if link pane model is spawned (expanded and displayed)"

	<return: #Boolean>
	^ self state isSpawned
]

{ #category : #'api - state' }
TGtTreePagerLinkModelState >> state [
	<return: #GtTreePagerLinkState>
	^ self explicitRequirement
]
