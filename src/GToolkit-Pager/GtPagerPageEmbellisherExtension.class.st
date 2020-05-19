Class {
	#name : #GtPagerPageEmbellisherExtension,
	#superclass : #Object,
	#traits : 'TBlDebug',
	#classTraits : 'TBlDebug classTrait',
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
