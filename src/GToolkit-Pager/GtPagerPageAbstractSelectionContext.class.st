Class {
	#name : #GtPagerPageAbstractSelectionContext,
	#superclass : #Object,
	#traits : 'TBlDebug',
	#classTraits : 'TBlDebug classTrait',
	#category : #'GToolkit-Pager-Contexts'
}

{ #category : #converting }
GtPagerPageAbstractSelectionContext >> asElementDo: aOneArgBlock [
	"Create a tool element and execute the block"
	self subclassResponsibility
]

{ #category : #enumerating }
GtPagerPageAbstractSelectionContext >> ifDefinedDo: aBlock [
	"Evaluate the block if expected"
	self subclassResponsibility
]
