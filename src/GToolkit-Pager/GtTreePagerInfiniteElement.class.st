Class {
	#name : #GtTreePagerInfiniteElement,
	#superclass : #BlInfiniteElement,
	#traits : 'TGtTreePagerWithModel',
	#classTraits : 'TGtTreePagerWithModel classTrait',
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #initialization }
GtTreePagerInfiniteElement >> defaultDataSource [
	^ BrPagerDataSource new
]

{ #category : #initialization }
GtTreePagerInfiniteElement >> defaultLayout [
	^ BlInfiniteLinearLayout horizontal
]
