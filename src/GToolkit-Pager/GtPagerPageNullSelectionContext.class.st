"
I am an initial {{gtClass:GtPagerPageSelectionContext}} that is used until {{gtClass:GtPhlowObjectToSelect}} or {{gtClass:GtPhlowObjectToSpawn}} is received.
I am used by {{gtClass:GtPagerPageEmbellisher}}.


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
