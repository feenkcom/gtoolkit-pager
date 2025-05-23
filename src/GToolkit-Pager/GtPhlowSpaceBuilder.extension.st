Extension { #name : #GtPhlowSpaceBuilder }

{ #category : #'*GToolkit-Pager' }
GtPhlowSpaceBuilder >> inPager: anElementStencil [
	"Set element that will be added as a pager pane to a newly created space"

	self inPager: anElementStencil configured: nil
]

{ #category : #'*GToolkit-Pager' }
GtPhlowSpaceBuilder >> inPager: anElementStencil configured: aPagerConfiguration [
	"Set element that will be added as a pager pane to a newly created space"

	self stencil: [ 
		| aPager |
		aPager := GtPager createWrappedOn: anElementStencil.
		aPager maximized.
		aPagerConfiguration ifNotNil: [
			aPagerConfiguration applyOn: aPager ].
		aPager ] asStencil.
]

{ #category : #'*GToolkit-Pager' }
GtPhlowSpaceBuilder >> objectInPager: anObject [
	"Set element that will be added as a pager pane to a newly created space"

	| aTitleBuilder |
	aTitleBuilder := GtPhlowTitleLabelBuilder longLabel: [ anObject gtInspectorTitleString ].
	self title: aTitleBuilder build.

	self inPager: [ anObject gtDefaultInspectorTool asElementDo: [ :e | e ] ] asStencil
]

{ #category : #'*GToolkit-Pager' }
GtPhlowSpaceBuilder >> spawnTool: aPhlowToolBlock [
	"A Phlow tool is either:
	- spawned to the next GtPager pane, or
	- displayed as a new GtWorld tab, or
	- opened in a new window."

	<return: #BlSpace or: nil>
	| anEvent |
	self fromElement ifNil: [ ^ self show ].
	aPhlowToolBlock ifNil: [ ^ self show ].

	anEvent := self fromElement phlow spawnTool: aPhlowToolBlock value.
	anEvent isConsumed ifTrue: [ ^ nil ].
	^ self show.
]
