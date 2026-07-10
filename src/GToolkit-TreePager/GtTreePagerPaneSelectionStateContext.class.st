Class {
	#name : #GtTreePagerPaneSelectionStateContext,
	#superclass : #Object,
	#instVars : [
		'toolElement',
		'selectionState',
		'columnIndex',
		'rowIndex'
	],
	#category : #'GToolkit-TreePager-Model Rest'
}

{ #category : #accessing }
GtTreePagerPaneSelectionStateContext >> columnIndex [
	^ columnIndex
]

{ #category : #accessing }
GtTreePagerPaneSelectionStateContext >> columnIndex: anObject [
	columnIndex := anObject
]

{ #category : #accessing }
GtTreePagerPaneSelectionStateContext >> rowIndex [
	^ rowIndex
]

{ #category : #accessing }
GtTreePagerPaneSelectionStateContext >> rowIndex: anObject [
	rowIndex := anObject
]

{ #category : #accessing }
GtTreePagerPaneSelectionStateContext >> selectionState [
	^ selectionState
]

{ #category : #accessing }
GtTreePagerPaneSelectionStateContext >> selectionState: anObject [
	selectionState := anObject
]

{ #category : #accessing }
GtTreePagerPaneSelectionStateContext >> toolElement [
	^ toolElement
]

{ #category : #accessing }
GtTreePagerPaneSelectionStateContext >> toolElement: anObject [
	toolElement := anObject
]
