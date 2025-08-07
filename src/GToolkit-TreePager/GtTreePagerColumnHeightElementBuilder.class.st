Class {
	#name : #GtTreePagerColumnHeightElementBuilder,
	#superclass : #Object,
	#traits : 'TBlHorizontalTreeFlowLayoutRowCountVisitor',
	#classTraits : 'TBlHorizontalTreeFlowLayoutRowCountVisitor classTrait',
	#instVars : [
		'icon',
		'label',
		'preview',
		'columnHeight'
	],
	#category : #'GToolkit-TreePager-Support'
}

{ #category : #building }
GtTreePagerColumnHeightElementBuilder >> build [
	self visitLayoutRowCount: self columnHeight
]

{ #category : #accessing }
GtTreePagerColumnHeightElementBuilder >> columnHeight [
	^ columnHeight
]

{ #category : #accessing }
GtTreePagerColumnHeightElementBuilder >> columnHeight: anObject [
	columnHeight := anObject
]

{ #category : #building }
GtTreePagerColumnHeightElementBuilder >> icon [
	self build.
	^ icon
]

{ #category : #building }
GtTreePagerColumnHeightElementBuilder >> label [
	self build.
	^ label
]

{ #category : #private }
GtTreePagerColumnHeightElementBuilder >> newFillColumnHeightIcon [
	^ BrHorizontalPane new
		cellSpacing: 2;
		fitContent;
		alignTopLeft;
		addChild: (BlElement new
				size: 7 @ 14;
				background: BlTheme default button defaultTextForeground);
		addChild: (BlElement new
				size: 7 @ 14;
				background: BlTheme default button defaultTextForeground)
]

{ #category : #private }
GtTreePagerColumnHeightElementBuilder >> newFillRowHeightIcon [
	^ BrHorizontalPane new
		cellSpacing: 2;
		fitContent;
		alignTopLeft;
		addChild: (BlElement new
				size: 7 @ 14;
				background: BlTheme default button defaultTextForeground);
		addChild: (BlElement new
				size: 7 @ 7;
				background: BlTheme default button defaultTextForeground)
]

{ #category : #building }
GtTreePagerColumnHeightElementBuilder >> preview [
	self build.
	^ preview
]

{ #category : #visiting }
GtTreePagerColumnHeightElementBuilder >> visitBlHorizontalTreeFlowLayoutRowCount: aCount [
	icon := self newFillRowHeightIcon.
	label := 'Fill row height'.
	preview := 'instead of column height'
]

{ #category : #visiting }
GtTreePagerColumnHeightElementBuilder >> visitBlHorizontalTreeFlowLayoutRowGrowingCount: aCount [
	icon := self newFillColumnHeightIcon.
	label := 'Fill column height'.
	preview := 'instead of row height'
]
