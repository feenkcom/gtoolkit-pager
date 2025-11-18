Class {
	#name : #GtTreePagerLinkModelAboutToRestoreReplacedLinkAnnouncement,
	#superclass : #GtTreePagerLinkModelAnnouncement,
	#instVars : [
		'replacedLink',
		'parentPane'
	],
	#category : #'GToolkit-TreePager-Announcements'
}

{ #category : #accessing }
GtTreePagerLinkModelAboutToRestoreReplacedLinkAnnouncement >> parentPane [
	^ parentPane
]

{ #category : #accessing }
GtTreePagerLinkModelAboutToRestoreReplacedLinkAnnouncement >> parentPane: anObject [
	parentPane := anObject
]

{ #category : #accessing }
GtTreePagerLinkModelAboutToRestoreReplacedLinkAnnouncement >> replacedLink [
	^ replacedLink
]

{ #category : #accessing }
GtTreePagerLinkModelAboutToRestoreReplacedLinkAnnouncement >> replacedLink: anObject [
	replacedLink := anObject
]
