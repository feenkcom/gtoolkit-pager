Class {
	#name : #GtMultiPagerInfiniteElement,
	#superclass : #BlInfiniteElement,
	#traits : 'TGtMultiPagerWithModel',
	#classTraits : 'TGtMultiPagerWithModel classTrait',
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #initialization }
GtMultiPagerInfiniteElement >> defaultDataSource [
	^ BrPagerDataSource new
]

{ #category : #initialization }
GtMultiPagerInfiniteElement >> defaultLayout [
	^ BlInfiniteLinearLayout horizontal
]
