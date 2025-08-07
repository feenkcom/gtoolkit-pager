Class {
	#name : #GtTreePagerLinkModelAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'linkModel'
	],
	#category : #'GToolkit-TreePager-Announcements'
}

{ #category : #accessing }
GtTreePagerLinkModelAnnouncement >> linkModel [
	^ linkModel
]

{ #category : #accessing }
GtTreePagerLinkModelAnnouncement >> linkModel: anObject [
	linkModel := anObject
]

{ #category : #accessing }
GtTreePagerLinkModelAnnouncement >> paneModel [
	^ self linkModel paneModel
]
