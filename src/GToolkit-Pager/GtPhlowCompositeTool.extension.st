Extension { #name : #GtPhlowCompositeTool }

{ #category : #'*GToolkit-Pager' }
GtPhlowCompositeTool >> contextWithNavigationContext: aNavigationContext [
	"Tools may use phlow context with the given navigation context"

	self tools
		do: [ :eachTool | eachTool contextWithNavigationContext: aNavigationContext ]
]
