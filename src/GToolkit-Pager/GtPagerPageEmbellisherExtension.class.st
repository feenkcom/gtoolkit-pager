Class {
	#name : #GtPagerPageEmbellisherExtension,
	#superclass : #Object,
	#category : #'GToolkit-Pager-Stencils and Builders'
}

{ #category : #factory }
GtPagerPageEmbellisherExtension class >> null [
	^ GtPagerPageEmbellisherNullExtension default
]

{ #category : #'widget configuration' }
GtPagerPageEmbellisherExtension >> fillToolWidgetIn: aCreationContext [
	"initialize a tool widget"
	self subclassResponsibility
]
