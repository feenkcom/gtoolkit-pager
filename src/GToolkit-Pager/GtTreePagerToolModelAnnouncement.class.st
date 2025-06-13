Class {
	#name : #GtTreePagerToolModelAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'toolModel'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #accessing }
GtTreePagerToolModelAnnouncement >> toolModel [
	^ toolModel
]

{ #category : #accessing }
GtTreePagerToolModelAnnouncement >> toolModel: anObject [
	toolModel := anObject
]
