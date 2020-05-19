Class {
	#name : #GtPagerPageEmbellisherExtensions,
	#superclass : #GtPagerPageEmbellisherExtension,
	#instVars : [
		'collection'
	],
	#category : #'GToolkit-Pager-Stencils and Builders'
}

{ #category : #adding }
GtPagerPageEmbellisherExtensions >> addExtension: anExtension [
	self collection add: anExtension
]

{ #category : #accessing }
GtPagerPageEmbellisherExtensions >> collection [
	<return: #Collection>
	^ collection
]

{ #category : #accessing }
GtPagerPageEmbellisherExtensions >> collection: aCollection [
	collection := aCollection
]

{ #category : #defaults }
GtPagerPageEmbellisherExtensions >> defaultCollection [
	^ OrderedCollection new: 2
]

{ #category : #'widget configuration' }
GtPagerPageEmbellisherExtensions >> fillToolWidgetIn: aCreationContext [
	self collection do: [ :eachExtension | 
		eachExtension fillToolWidgetIn: aCreationContext ]
]

{ #category : #initialization }
GtPagerPageEmbellisherExtensions >> initialize [
	super initialize.
	collection := self defaultCollection.
]
