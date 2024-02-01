Class {
	#name : #GtPagerPageModel,
	#superclass : #GtPagerPageProtoModel,
	#instVars : [
		'eventHandlers'
	],
	#category : #'GToolkit-Pager-View Model'
}

{ #category : #accessing }
GtPagerPageModel >> contentElement [
	^ self embellisher contentElement
]

{ #category : #defaults }
GtPagerPageModel >> defaultEmbellisher [
	^ GtPagerPageEmbellisher new
]

{ #category : #initialization }
GtPagerPageModel >> initialize [ 
	super initialize.
	eventHandlers := OrderedCollection new.
]

{ #category : #notifying }
GtPagerPageModel >> notifyPageAdded: aPage in: aPager [
	aPage = self ifFalse: [ ^ self ].
	self widgetDo: [ :aWrapper | 
		aWrapper tool dispatchEvent:
			(GtPagerPageAddedEvent new
				pager: aPager;
				page: aPage) ]
]

{ #category : #notifying }
GtPagerPageModel >> notifyPageRemoved: aPage from: aPager [
	aPage = self ifFalse: [ ^ self ].
	self widgetDo: [ :aWrapper | 
		aWrapper tool dispatchEvent:
			(GtPagerPageRemovedEvent new
				pager: aPager;
				page: aPage) ]
]

{ #category : #configuration }
GtPagerPageModel >> pager: aPager [
	super pager: aPager.
	self embellisher pager: aPager.
	
	eventHandlers add: (BlEventHandler 
		on: BrPagerPageAddedEvent 
		do: [ :anEvent | 
			anEvent page = self ifTrue: [
				self widgetDo: [ :aWrapper | 
					aPager context toolSelectionStatesHandler 
						applySelectionStateTo: aWrapper tool ] ].
						
			self notifyPageAdded: anEvent page in: aPager ]).
	eventHandlers add: (BlEventHandler 
		on: BrPagerPageRemovedEvent 
		do: [ :anEvent | 
			anEvent page = self ifTrue: [
				self widgetDo: [ :aWrapper | 
					aPager context toolSelectionStatesHandler 
						storeSelectionStateFrom: aWrapper tool ] ].
		
			self notifyPageRemoved: anEvent page from: aPager ]).
	eventHandlers do: [ :anEventHandler |
		aPager addEventHandler: anEventHandler ].
	
]

{ #category : #configuration }
GtPagerPageModel >> removePager: aPager [
	super removePager: aPager.
	self embellisher removePager: aPager.
	eventHandlers do: [ :anEventHandler |
		aPager removeEventHandler: anEventHandler ].
	eventHandlers removeAll
]
