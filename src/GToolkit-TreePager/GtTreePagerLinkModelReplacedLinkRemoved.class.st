Class {
	#name : #GtTreePagerLinkModelReplacedLinkRemoved,
	#superclass : #GtTreePagerLinkModelAnnouncement,
	#instVars : [
		'replacedLink'
	],
	#category : #'GToolkit-TreePager-Announcements'
}

{ #category : #accessing }
GtTreePagerLinkModelReplacedLinkRemoved >> replacedLink [
	^ replacedLink
]

{ #category : #accessing }
GtTreePagerLinkModelReplacedLinkRemoved >> replacedLink: anObject [
	replacedLink := anObject
]
