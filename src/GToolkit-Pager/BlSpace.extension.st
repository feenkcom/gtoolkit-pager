Extension { #name : #BlSpace }

{ #category : #'*GToolkit-Pager' }
BlSpace >> inPager: anElementStencil [
	"Add a pager with a given element."

	self inPager: anElementStencil configured: nil
]

{ #category : #'*GToolkit-Pager' }
BlSpace >> inPager: anElementStencil configured: aPagerConfiguration [
	"Add a pager with a given element."

	| aPager |
	aPager := GtPager createWrappedOn: anElementStencil.
	aPager maximized.
	aPagerConfiguration ifNotNil: [
		aPagerConfiguration applyOn: aPager ].
	self addChild: aPager
]

{ #category : #'*GToolkit-Pager' }
BlSpace >> objectInPager: anObject [
	"Add a pager element with a default object tool."

	| aTitleBuilder |
	aTitleBuilder := GtPhlowTitleLabelBuilder
			longLabel: [ anObject gtInspectorTitleString ].
	self title: aTitleBuilder build.

	self inPager: [ anObject gtDefaultInspectorTool asElementDo: [ :e | e ] ] asStencil
]

{ #category : #'*GToolkit-Pager' }
BlSpace class >> spawnTool: aPhlowToolBlock from: anElement [
	"A Phlow tool is either:
	- spawned to the next GtPager pane, or
	- displayed as a new GtWorld tab, or
	- opened in a new window."

	<return: #BlSpace or: nil>
	| aPhlowTool anEvent |
	self
		assert: [ aPhlowToolBlock isNotNil ]
		description: [ 'Phlow tool block must be non-nil' ].
	aPhlowTool := aPhlowToolBlock value.
	self
		assert: [ aPhlowTool isNotNil ]
		description: [ 'Phlow tool must be non-nil: { 1 }' format: { aPhlowToolBlock } ].
	
	anElement ifNil: [ 
		^ self new
			inPager: aPhlowTool;
			withSceneDriller;
			show ].

	anEvent := anElement phlow spawnTool: aPhlowTool.
	anEvent isConsumed ifTrue: [ ^ nil ].
	^ self new
		inPager: aPhlowTool;
		withSceneDriller;
		showFrom: anElement
]