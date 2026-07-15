Class {
	#name : #GtTreePagerToolCircularSelectionStateHandlerElement,
	#superclass : #GtTreePagerSelectionStateHandlerElement,
	#instVars : [
		'labelTooltip'
	],
	#category : #'GToolkit-TreePager-UI'
}

{ #category : #initialization }
GtTreePagerToolCircularSelectionStateHandlerElement >> initialize [
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
GtTreePagerToolCircularSelectionStateHandlerElement >> newDecreaseButton [
	^ BrButton new
		id: #'tree-pager--tool-circular-selection-state-handler-decrease';
		aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonExteriorAptitude;
		icon: BrGlamorousVectorIcons remove;
		label: 'Decrease maximum tool and tab saved selections';
		action: [ :aButton | self onDecreaseMaxSelectionStatesFrom: aButton ];
		constraintsDo: [ :c | 
			c linear horizontal alignLeft.
			c linear vertical alignCenter ]
]

{ #category : #ui }
GtTreePagerToolCircularSelectionStateHandlerElement >> newIncreaseButton [
	^ BrButton new
		id: #'tree-pager--tool-circular-selection-state-handler-increase';
		aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonExteriorAptitude;
		icon: BrGlamorousVectorIcons add;
		label: 'Increase maximum tool and tab save selection';
		action: [ :aButton | self onIncreaseMaxSelectionStatesFrom: aButton ];
		constraintsDo: [ :c | 
			c linear horizontal alignLeft.
			c linear vertical alignCenter ]
]

{ #category : #ui }
GtTreePagerToolCircularSelectionStateHandlerElement >> newValueLabel [
	^ BrLabel new
		id: #'tree-pager--tool-circular-selection-state-handler-value';
		text: self valueText;
		aptitude: BrGlamorousLabelAptitude new;
		addAptitude: (labelTooltip := BrGlamorousWithExplicitTooltipAptitude new
					text: self valueTooltip);
		constraintsDo: [ :c | 
			c linear horizontal alignLeft.
			c linear vertical alignCenter ]
]

{ #category : #actions }
GtTreePagerToolCircularSelectionStateHandlerElement >> onDecreaseMaxSelectionStatesFrom: aButton [
	self selectionStateHandlerDo: [ :aSelectionStateHandler | 
		aSelectionStateHandler decreaseMaxSelectionStates ]
]

{ #category : #actions }
GtTreePagerToolCircularSelectionStateHandlerElement >> onIncreaseMaxSelectionStatesFrom: aButton [
	self selectionStateHandlerDo: [ :aSelectionStateHandler | 
		aSelectionStateHandler increaseMaxSelectionStates ]
]

{ #category : #subscriptions }
GtTreePagerToolCircularSelectionStateHandlerElement >> onMaxSelectionStatesChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #accessing }
GtTreePagerToolCircularSelectionStateHandlerElement >> selectionStateHandler: aSelectionStateHandler [
	selectionStateHandler == aSelectionStateHandler ifTrue: [ ^ self ].
	selectionStateHandler ifNotNil: [ self unsubscribeFromSelectionStateHandler ].
	selectionStateHandler := aSelectionStateHandler.
	selectionStateHandler ifNotNil: [ self subscribeToSelectionStateHandler ].
	self updateElement
]

{ #category : #accessing }
GtTreePagerToolCircularSelectionStateHandlerElement >> selectionStateHandlerDo: aBlock [
	self hasSelectionStateHandler ifTrue: [ aBlock value: self selectionStateHandler ]
]

{ #category : #subscriptions }
GtTreePagerToolCircularSelectionStateHandlerElement >> subscribeToSelectionStateHandler [
	self selectionStateHandler announcer weak
		when: GtPhlowToolCircularSelectionStateHandlerAnnouncement
		send: #onMaxSelectionStatesChanged:
		to: self
]

{ #category : #accessing }
GtTreePagerToolCircularSelectionStateHandlerElement >> unsubscribeFromSelectionStateHandler [
	^ selectionStateHandler announcer unsubscribe: self
]

{ #category : #updating }
GtTreePagerToolCircularSelectionStateHandlerElement >> updateElement [
	self
		childWithId: #'tree-pager--tool-circular-selection-state-handler-value'
		ifFound: [ :aLabel | aLabel text: self valueText ].

	labelTooltip ifNotNil: [ :anAptitude | anAptitude text: self valueTooltip ]
]

{ #category : #accessing }
GtTreePagerToolCircularSelectionStateHandlerElement >> valueText [
	self hasSelectionStateHandler ifFalse: [ ^ '0/0' ].
	^ self selectionStateHandler numberOfSelectionStates asString , '/'
		, self selectionStateHandler maxSelectionStates asString
]

{ #category : #accessing }
GtTreePagerToolCircularSelectionStateHandlerElement >> valueTooltip [
	self hasSelectionStateHandler
		ifFalse: [ ^ 'Uninitialized tool and tab selection state handler' ].

	^ '{1} saved tool and tab selections out of a total of {2} possible saves'
		format: {self selectionStateHandler numberOfSelectionStates.
				self selectionStateHandler maxSelectionStates}
]
