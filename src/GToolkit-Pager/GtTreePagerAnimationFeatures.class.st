"
{{gtClass:BlScripter}} waits for all animations to finish, which is undesirable in some cases, e.g., {{gtMethod:GtTreePagerLinkReplacedElement>>#startAnimation | label=#methodClass}}. In such cases, users can disable {{gtClass:GtTreePager}} animations for specific scripter steps.
"
Class {
	#name : #GtTreePagerAnimationFeatures,
	#superclass : #DynamicVariable,
	#category : #'GToolkit-Pager-Support'
}

{ #category : #controlling }
GtTreePagerAnimationFeatures class >> disableDuring: aBlock [
	^ self value: false during: aBlock
]

{ #category : #accessing }
GtTreePagerAnimationFeatures class >> enabled [
	"Answer true if using animations is enabled in a particular process.
	The default is true."

	^ self soleInstance enabled
]

{ #category : #controlling }
GtTreePagerAnimationFeatures class >> ifEnabled: anAsyncBlock ifDisabled: aSyncBlock [
	^ self enabled 
		ifTrue: anAsyncBlock 
		ifFalse: aSyncBlock
]

{ #category : #accessing }
GtTreePagerAnimationFeatures >> enabled [
	"Answer true if using animations is enabled in a particular process.
	The default is true."
	
	^ self value
		ifNil: [ true ]
		ifNotNil: [ :value | value ]
]
