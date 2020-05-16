"
I am an initial ${class:GtPagerPageSelectionContext}$ that is used until ${class:GtPhlowObjectToSelect}$ or ${class:GtPhlowObjectToSpawn}$ is received.
I am used by ${class:GtPagerPageEmbellisher}$.

"
Class {
	#name : #GtPagerPageNullSelectionContext,
	#superclass : #GtPagerPageAbstractSelectionContext,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#category : #'GToolkit-Pager-Contexts'
}

{ #category : #converting }
GtPagerPageNullSelectionContext >> asElementDo: aOneArgBlock [
	"do nothing"
]

{ #category : #enumerating }
GtPagerPageNullSelectionContext >> ifDefinedDo: aBlock [
	"do nothing"
]
