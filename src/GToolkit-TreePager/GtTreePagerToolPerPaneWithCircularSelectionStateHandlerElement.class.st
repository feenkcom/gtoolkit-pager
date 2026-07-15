Class {
	#name : #GtTreePagerToolPerPaneWithCircularSelectionStateHandlerElement,
	#superclass : #GtTreePagerSelectionStateHandlerElement,
	#instVars : [
		'labelTooltip'
	],
	#category : #'GToolkit-TreePager-UI'
}

{ #category : #private }
GtTreePagerToolPerPaneWithCircularSelectionStateHandlerElement >> circularSelectionStateHandlerDo: aDoBlock ifAbsent: anAbsentBlock [
	self hasSelectionStateHandler ifFalse: [ ^ anAbsentBlock value ].

	^ self selectionStateHandler selectionStateHandler
		ifNotNil: aDoBlock
		ifNil: anAbsentBlock
]

{ #category : #initialization }
GtTreePagerToolPerPaneWithCircularSelectionStateHandlerElement >> initialize [
	super initialize.
	
	self
		id: #'tree-pager--tool-circular-selection-state-handler';
		layout: BlLinearLayout horizontal;
		fitContent;
		addChild: self newDecreaseButton;
		addChild: self newValueLabel;
		addChild: self newIncreaseButton
]

{ #category : #ui }
GtTreePagerToolPerPaneWithCircularSelectionStateHandlerElement >> newDecreaseButton [
	^ BrButton new
		id: #'tree-pager--tool-circular-selection-state-handler-decrease';
		beMiniSize;
		aptitude: BrGlamorousButtonWithIconAptitude;
		icon: BrGlamorousVectorIcons remove;
		label: 'Decrease maximum tool and tab saved selections';
		action: [ :aButton | self onDecreaseMaxSelectionStatesFrom: aButton ];
		constraintsDo: [ :c | 
			c linear horizontal alignLeft.
			c linear vertical alignCenter ]
]

{ #category : #ui }
GtTreePagerToolPerPaneWithCircularSelectionStateHandlerElement >> newIncreaseButton [
	^ BrButton new
		id: #'tree-pager--tool-circular-selection-state-handler-increase';
		beMiniSize;
		aptitude: BrGlamorousButtonWithIconAptitude;
		icon: BrGlamorousVectorIcons add;
		label: 'Increase maximum tool and tab save selection';
		action: [ :aButton | self onIncreaseMaxSelectionStatesFrom: aButton ];
		constraintsDo: [ :c | 
			c linear horizontal alignLeft.
			c linear vertical alignCenter ]
]

{ #category : #ui }
GtTreePagerToolPerPaneWithCircularSelectionStateHandlerElement >> newValueLabel [
	^ BrLabel new
		id: #'tree-pager--tool-circular-selection-state-handler-value';
		text: self valueText;
		aptitude: BrGlamorousLabelAptitude new;
		addAptitude: (labelTooltip := BrGlamorousWithExplicitTooltipAptitude new
					text: self valueTooltip);
		constraintsDo: [ :c | 
			c margin: (BlInsets left: 3 right: 3).
			c linear horizontal alignLeft.
			c linear vertical alignCenter ]
]

{ #category : #actions }
GtTreePagerToolPerPaneWithCircularSelectionStateHandlerElement >> onDecreaseMaxSelectionStatesFrom: aButton [
	self selectionStateHandlerDo: [ :aSelectionStateHandler | 
		aSelectionStateHandler decreaseMaxSelectionStates ]
]

{ #category : #actions }
GtTreePagerToolPerPaneWithCircularSelectionStateHandlerElement >> onIncreaseMaxSelectionStatesFrom: aButton [
	self selectionStateHandlerDo: [ :aSelectionStateHandler | 
		aSelectionStateHandler increaseMaxSelectionStates ]
]

{ #category : #subscriptions }
GtTreePagerToolPerPaneWithCircularSelectionStateHandlerElement >> onMaxSelectionStatesChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #accessing }
GtTreePagerToolPerPaneWithCircularSelectionStateHandlerElement >> selectionStateHandler: aSelectionStateHandler [
	selectionStateHandler == aSelectionStateHandler ifTrue: [ ^ self ].
	selectionStateHandler ifNotNil: [ self unsubscribeFromSelectionStateHandler ].
	selectionStateHandler := aSelectionStateHandler.
	selectionStateHandler ifNotNil: [ self subscribeToSelectionStateHandler ].
	self updateElement
]

{ #category : #accessing }
GtTreePagerToolPerPaneWithCircularSelectionStateHandlerElement >> selectionStateHandlerDo: aBlock [
	self hasSelectionStateHandler ifTrue: [ aBlock value: self selectionStateHandler ]
]

{ #category : #subscriptions }
GtTreePagerToolPerPaneWithCircularSelectionStateHandlerElement >> subscribeToSelectionStateHandler [
	self
		circularSelectionStateHandlerDo: [ :aHandler | 
			aHandler announcer weak
				when: GtPhlowToolCircularSelectionStateHandlerAnnouncement
				send: #onMaxSelectionStatesChanged:
				to: self ]
		ifAbsent: [  ]
]

{ #category : #accessing }
GtTreePagerToolPerPaneWithCircularSelectionStateHandlerElement >> unsubscribeFromSelectionStateHandler [
	self
		circularSelectionStateHandlerDo: [ :aHandler |
			aHandler announcer unsubscribe: self ]
		ifAbsent: [  ]
]

{ #category : #updating }
GtTreePagerToolPerPaneWithCircularSelectionStateHandlerElement >> updateElement [
	self
		childWithId: #'tree-pager--tool-circular-selection-state-handler-value'
		ifFound: [ :aLabel | aLabel text: self valueText ].

	labelTooltip ifNotNil: [ :anAptitude | anAptitude text: self valueTooltip ]
]

{ #category : #accessing }
GtTreePagerToolPerPaneWithCircularSelectionStateHandlerElement >> valueText [
	^ self
		circularSelectionStateHandlerDo: [ :aHandler | aHandler maxSelectionStates asString ]
		ifAbsent: [ '0' ]
]

{ #category : #accessing }
GtTreePagerToolPerPaneWithCircularSelectionStateHandlerElement >> valueTooltip [
	^ 'Maximum number of saved tool and tab selections for each pane'
]
