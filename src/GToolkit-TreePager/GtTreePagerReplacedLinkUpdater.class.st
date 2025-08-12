"
I set {{gtMethod:name=GtTreePagerLinkModel >> #replacedLink: | label=replaced link}} based on {{gtMethod:name=GtTreePagerReplacedLinkUpdater >> #replacedLinkModel | label=replaced link}}'s state.
"
Class {
	#name : #GtTreePagerReplacedLinkUpdater,
	#superclass : #Object,
	#traits : 'TGtTreePagerLinkStateVisitor',
	#classTraits : 'TGtTreePagerLinkStateVisitor classTrait',
	#instVars : [
		'element',
		'newLinkModel',
		'replacedLinkModel'
	],
	#category : #'GToolkit-TreePager-Support'
}

{ #category : #accessing }
GtTreePagerReplacedLinkUpdater >> newLinkModel [
	^ newLinkModel
]

{ #category : #accessing }
GtTreePagerReplacedLinkUpdater >> newLinkModel: anObject [
	newLinkModel := anObject
]

{ #category : #accessing }
GtTreePagerReplacedLinkUpdater >> replacedLinkModel [
	^ replacedLinkModel
]

{ #category : #accessing }
GtTreePagerReplacedLinkUpdater >> replacedLinkModel: anObject [
	replacedLinkModel := anObject
]

{ #category : #updating }
GtTreePagerReplacedLinkUpdater >> update [
	self newLinkModel ifNil: [ ^ self ].
	self replacedLinkModel ifNil: [ ^ self ].
	
	self visitLinkState: self replacedLinkModel state
]

{ #category : #private }
GtTreePagerReplacedLinkUpdater >> updateReplacedLink [
	self newLinkModel replacedLink: self replacedLinkModel
]

{ #category : #visiting }
GtTreePagerReplacedLinkUpdater >> visitGtTreePagerLinkActiveSpawnedState: aState [
	self updateReplacedLink
]
