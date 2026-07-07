Class {
	#name : #GtTreePagerViewCachingStrategy,
	#superclass : #Object,
	#instVars : [
		'selectionStateHandler'
	],
	#category : #'GToolkit-TreePager-Model Rest'
}

{ #category : #initialization }
GtTreePagerViewCachingStrategy >> initialize [
	super initialize.

	selectionStateHandler := GtPhlowToolCircularSelectionStateHandler new
]

{ #category : #copying }
GtTreePagerViewCachingStrategy >> postSimilarSettingsOption [
	selectionStateHandler := selectionStateHandler similarSelectionStateHandler
]

{ #category : #accessing }
GtTreePagerViewCachingStrategy >> selectionStateHandler [
	<return: #TGtPhlowToolSelectionStateHandler>
	^ selectionStateHandler
]

{ #category : #accessing }
GtTreePagerViewCachingStrategy >> selectionStateHandler: anObject [
	selectionStateHandler := anObject
]

{ #category : #copying }
GtTreePagerViewCachingStrategy >> similarSettingsOption [
	^ self copy postSimilarSettingsOption
]
