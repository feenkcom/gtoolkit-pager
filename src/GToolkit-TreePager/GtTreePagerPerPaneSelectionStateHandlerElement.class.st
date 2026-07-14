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
		vFitContent;
		hMatchParent
]

{ #category : #'private - instance creation' }
GtTreePagerPerPaneSelectionStateHandlerElement >> newInspectButtonFor: aSelectionStateHandler [
	^ BrButton new
		id: #'tree-pager--per-pane-selection-state-handler-inspect-button';
		fitContent;
		aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonExteriorAptitude;
		icon: (BrGlamorousVectorIcons inspect asElement);
		label: 'Inspect selection state handler';
		constraintsDo: [ :c |
			c margin: (BlInsets left: 10).
			c linear horizontal alignLeft.
			c linear vertical alignCenter ];
		action: [ :aButton | aButton phlow spawnObject: aSelectionStateHandler ]
]

{ #category : #'private - instance creation' }
GtTreePagerPerPaneSelectionStateHandlerElement >> newLabelFor: aSelectionStateHandler [
	^ BrLabel new
		id: #'tree-pager--per-pane-selection-state-handler-label';
		text: aSelectionStateHandler asTreePagerPerPaneSelectionStateLabel;
		aptitude: BrGlamorousLabelAptitude new;
		vFitContent;
		hMatchParent;
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
			addChild: (self newInspectButtonFor: aSelectionStateHandler);
			addChild: aSelectionStateHandler selectionStateHandler asTreePagerSettingsItemElement ]
]
