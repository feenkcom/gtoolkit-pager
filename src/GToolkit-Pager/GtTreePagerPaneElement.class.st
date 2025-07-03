Class {
	#name : #GtTreePagerPaneElement,
	#superclass : #GtTreePagerPaneBasicElement,
	#instVars : [
		'contentElement',
		'followingsElement',
		'disappearElement',
		'maximizeElement'
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
	^ GtInspectorRoundButtonStencil normal asElement
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

	self paneModel hasFollowingPanes
		ifTrue: [ self paneModel collapse ]
		ifFalse: [ self paneModel removeFromPreviousPane ]
]

{ #category : #accessing }
GtTreePagerPaneElement >> onPaneModelChanged [
	contentElement paneModel: self paneModel.
	followingsElement paneModel: self paneModel.
	
	self updateElement.
]

{ #category : #'private - updating' }
GtTreePagerPaneElement >> updateDisappearElement [
	self paneModel hasFollowingPanes
		ifTrue: [ disappearElement
				icon: (BlElement new
						size: 2 @ 10;
						background: Color gray);
				label: 'Collapse pane' ]
		ifFalse: [ disappearElement
				icon: BrPlusIconStencil close asElement;
				label: 'Close pane' ]
]

{ #category : #'private - updating' }
GtTreePagerPaneElement >> updateElement [
	self updateDisappearElement

]
