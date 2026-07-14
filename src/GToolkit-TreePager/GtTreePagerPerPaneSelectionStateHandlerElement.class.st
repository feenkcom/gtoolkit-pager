Class {
	#name : #GtTreePagerPerPaneSelectionStateHandlerElement,
	#superclass : #GtTreePagerSelectionStateHandlerElement,
	#instVars : [
		'selectionStateHandler'
	],
	#category : #'GToolkit-TreePager-UI'
}

{ #category : #testing }
GtTreePagerPerPaneSelectionStateHandlerElement >> hasSelectionStateHandler [
	^ selectionStateHandler isNotNil
]

{ #category : #initialization }
GtTreePagerPerPaneSelectionStateHandlerElement >> initialize [
	super initialize.

	self
		id: #'tree-pager--per-pane-selection-state-handler';
		layout: BlLinearLayout horizontal;
		fitContent
]

{ #category : #'private - instance creation' }
GtTreePagerPerPaneSelectionStateHandlerElement >> newLabelFor: aSelectionStateHandler [
	^ BrLabel new
		id: #'tree-pager--per-pane-selection-state-handler-label';
		text: aSelectionStateHandler asTreePagerPerPaneSelectionStateLabel;
		aptitude: BrGlamorousLabelAptitude new;
		constraintsDo: [ :c |
			c linear horizontal alignLeft.
			c linear vertical alignCenter ]
]

{ #category : #accessing }
GtTreePagerPerPaneSelectionStateHandlerElement >> selectionStateHandler [
	^ selectionStateHandler
]

{ #category : #accessing }
GtTreePagerPerPaneSelectionStateHandlerElement >> selectionStateHandler: aSelectionStateHandler [
	selectionStateHandler == aSelectionStateHandler ifTrue: [ ^ self ].
	selectionStateHandler := aSelectionStateHandler.
	self updateElement
]

{ #category : #private }
GtTreePagerPerPaneSelectionStateHandlerElement >> selectionStateHandlerDo: aBlock [
	^ selectionStateHandler ifNotNil: aBlock
]

{ #category : #updating }
GtTreePagerPerPaneSelectionStateHandlerElement >> updateElement [
	self removeChildren.
	self selectionStateHandlerDo: [ :aSelectionStateHandler |
		self
			addChild: (self newLabelFor: aSelectionStateHandler);
			addChild: aSelectionStateHandler selectionStateHandler asTreePagerSettingsItemElement ]
]
