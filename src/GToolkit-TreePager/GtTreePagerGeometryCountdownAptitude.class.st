Class {
	#name : #GtTreePagerGeometryCountdownAptitude,
	#superclass : #BrCountdownGeometryAptitude,
	#category : #'GToolkit-TreePager-Support'
}

{ #category : #'as yet unclassified' }
GtTreePagerGeometryCountdownAptitude >> newDefaultAnimation [
	^ super newDefaultAnimation
		duration: GtTreePagerSettings replacedLinkRestoration
]

{ #category : #'private - event management' }
GtTreePagerGeometryCountdownAptitude >> onPerformFinishAction [
	"The finish action is postponed to provide a posibility to disable it before it is performed.
	Note: Tree pager model communicates changes using announcements, that are propagated 
	to UI using BlTaskAction tasks. Therefore all UI changes are also postponed to the next UI pulse.
	For that reason we give a change to disable the finish action execution."
	
	self widgetDo: [ :aWidget | 
		BlTaskAction 
			enqueueElement: aWidget 
			action: [ super onPerformFinishAction ] ]
]

{ #category : #'private - updating' }
GtTreePagerGeometryCountdownAptitude >> startAnimation [
	GtTreePagerAnimationFeatures
		ifEnabled: [ super startAnimation ]
		ifDisabled: [  ]
]
