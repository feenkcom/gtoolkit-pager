Class {
	#name : #GtPagerPageWidth,
	#superclass : #Object,
	#traits : 'TBlDebug',
	#classTraits : 'TBlDebug classTrait',
	#category : #'GToolkit-Pager-Strategies'
}

{ #category : #'instance creation' }
GtPagerPageWidth class >> exact [
	^ GtPagerPageExactWidth new
]

{ #category : #'instance creation' }
GtPagerPageWidth class >> exact: aNumber [
	^ self exact width: aNumber
]

{ #category : #testing }
GtPagerPageWidth class >> isAbstract [
	^ self name = #GtPagerPageWidth 
]

{ #category : #'instance creation' }
GtPagerPageWidth class >> weight: aNumber [
	^ self weighted weight: aNumber
]

{ #category : #'instance creation' }
GtPagerPageWidth class >> weighted [
	^ GtPagerPageWeightedWidth new
]

{ #category : #'api - size' }
GtPagerPageWidth >> onElement: aPageElement [
	"Configure the page element"
	^ self subclassResponsibility
]
