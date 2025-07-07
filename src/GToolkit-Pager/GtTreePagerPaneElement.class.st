Class {
	#name : #GtTreePagerPaneElement,
	#superclass : #GtTreePagerPaneBasicElement,
	#instVars : [
		'contentElement',
		'followingsElement',
		'disappearElement'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #initialization }
GtTreePagerPaneElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtTreePagerPaneElement >> initialize [
	super initialize.
	self matchParent.
	self clipChildren: false.

	contentElement := GtTreePagerPaneContentElement new
			addAptitude: BrGlamorousFocusableShadowAptitude new.
	followingsElement := GtTreePagerPaneFollowingsElement new
			margin: (BlInsets left: 5).

	self
		addChild: (BrHorizontalPane new
				clipChildren: false;
				matchParent;
				addChild: contentElement;
				addChild: (disappearElement := self newDisappearElement)).

	self addChild: followingsElement.

	self
		addAptitude: (BrGlamorousWithMaximizerAptitude new
				// #tool;
				preferredBackground: Color white)
]

{ #category : #initialization }
GtTreePagerPaneElement >> newDisappearElement [
	^ GtInspectorRoundButtonStencil small asElement
		icon: BrPlusIconStencil close asElement;
		label: 'Close pane';
		id: GtPagerMaximizeButtonElementId;
		action: [ :aButton :aButtonModel :anEvent | self onDisappearClick: anEvent ];
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c ignored horizontal alignCenterAt: 1.0.
			c ignored vertical alignCenterAt: 0.0 ]
]

{ #category : #'private - event management' }
GtTreePagerPaneElement >> onDisappearClick: anEvent [
	anEvent consumed: true.
	self hasPaneModel ifFalse: [ ^ self ].
	self paneModel depthIndex = 1 ifTrue: [ ^ self ].

	self paneModel followingExpandedPaneModels isEmpty
		ifFalse: [ self paneModel collapse ]
		ifTrue: [ self paneModel removeFromPreviousPane ]
]

{ #category : #'private - event handling' }
GtTreePagerPaneElement >> onGtTreePagerPaneModelExpansionChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateDisappearElement ]
]

{ #category : #'private - event handling' }
GtTreePagerPaneElement >> onGtTreePagerPaneModelFollowingPanesChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateDisappearElement ]
]

{ #category : #accessing }
GtTreePagerPaneElement >> onPaneModelChanged [
	super onPaneModelChanged.
	contentElement paneModel: self paneModel.
	followingsElement paneModel: self paneModel.
	
	self updateElement.
]

{ #category : #'api - pane model' }
GtTreePagerPaneElement >> subscribeToPaneModel [
	super subscribeToPaneModel.

	self paneModel announcer weak
		when: GtTreePagerPaneModelFollowingLinksChanged
			send: #onGtTreePagerPaneModelFollowingPanesChanged:
			to: self;
		when: GtTreePagerPaneModelExpansionChanged
			send: #onGtTreePagerPaneModelExpansionChanged:
			to: self
]

{ #category : #'api - pane model' }
GtTreePagerPaneElement >> unsubscribeFromPaneModel [
	super unsubscribeFromPaneModel.

	self paneModel announcer unsubscribe: self
]

{ #category : #'private - updating' }
GtTreePagerPaneElement >> updateDisappearElement [
	self paneModel depthIndex = 1 ifTrue: [
		disappearElement visibility:  BlVisibility gone.
		^ self ].

	self paneModel followingExpandedPaneModels isEmpty
		ifFalse: [ disappearElement
				icon: (BlElement new
						size: 2 @ 10;
						background: Color gray);
				label: 'Collapse pane' ]
		ifTrue: [ disappearElement
				icon: BrPlusIconStencil close asElement;
				label: 'Remove pane' ]
]

{ #category : #'private - updating' }
GtTreePagerPaneElement >> updateElement [
	self updateDisappearElement

]
