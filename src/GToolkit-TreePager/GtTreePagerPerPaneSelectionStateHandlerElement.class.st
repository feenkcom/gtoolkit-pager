Class {
	#name : #GtTreePagerPerPaneSelectionStateHandlerElement,
	#superclass : #GtTreePagerSelectionStateHandlerElement,
	#category : #'GToolkit-TreePager-UI'
}

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
		beMiniSize;
		aptitude: BrGlamorousButtonWithIconAptitude;
		icon: BrGlamorousVectorIcons inspect asElement;
		label: 'Inspect selection state handler';
		constraintsDo: [ :c | 
			c margin: (BlInsets left: 3 right: 3).
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
		addAptitude: (BrGlamorousWithExplicitTooltipAptitude text: aSelectionStateHandler asTreePagerPerPaneSelectionStateTooltipLabel);
		vFitContent;
		hMatchParent;
		constraintsDo: [ :c | 
			c linear horizontal alignLeft.
			c linear vertical alignCenter ]
]

{ #category : #updating }
GtTreePagerPerPaneSelectionStateHandlerElement >> updateElement [
	self removeChildren.
	self
		selectionStateHandlerDo: [ :aSelectionStateHandler | 
			self
				addChild: (self newLabelFor: aSelectionStateHandler);
				addChild: (self newInspectButtonFor: aSelectionStateHandler);
				addChild: (aSelectionStateHandler selectionStateHandler
						asTreePagerSettingsItemElementForPerPaneHandler: aSelectionStateHandler) ]
]
