Extension { #name : #GtPhlowExplicitCompositeTool }

{ #category : #'*GToolkit-Pager' }
GtPhlowExplicitCompositeTool >> contextWithNavigationContext: aNavigationContext [
	"Tools may use phlow context with the given navigation context"

	self lastCompositeToolDo: [ :aCompositeTool | 
		aCompositeTool contextWithNavigationContext: aNavigationContext ]
]
