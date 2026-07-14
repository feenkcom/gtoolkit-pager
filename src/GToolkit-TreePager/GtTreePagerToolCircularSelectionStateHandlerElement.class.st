Class {
	#name : #GtTreePagerToolCircularSelectionStateHandlerElement,
	#superclass : #GtTreePagerSelectionStateHandlerElement,
	#instVars : [
		'selectionStateHandler'
	],
	#category : #'GToolkit-TreePager-UI'
}

{ #category : #accessing }
GtTreePagerToolCircularSelectionStateHandlerElement >> hasSelectionStateHandler [
	^ selectionStateHandler isNotNil
]

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
		label: 'Decrease maximum selection states';
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
		label: 'Increase maximum selection states';
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
GtTreePagerToolCircularSelectionStateHandlerElement >> selectionStateHandler [
	^ selectionStateHandler
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
	self childWithId: #'tree-pager--tool-circular-selection-state-handler-value'
		ifFound: [ :aLabel | aLabel text: self valueText ]
]

{ #category : #accessing }
GtTreePagerToolCircularSelectionStateHandlerElement >> valueText [
	self hasSelectionStateHandler ifFalse: [ ^ '0/0' ].
	^ self selectionStateHandler numberOfSelectionStates asString , '/'
		, self selectionStateHandler maxSelectionStates asString
]
