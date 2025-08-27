Class {
	#name : #GtTreePagerLinkState,
	#superclass : #Object,
	#classVars : [
		'Collapsed',
		'Hidden',
		'Inactive',
		'Removed',
		'Selected',
		'Spawned'
	],
	#category : #'GToolkit-TreePager-Model'
}

{ #category : #'api - accessing' }
GtTreePagerLinkState class >> collapsed [
	^ Collapsed ifNil: [ Collapsed := GtTreePagerLinkInactiveCollapsedState new ]
]

{ #category : #'gt - extensions' }
GtTreePagerLinkState class >> gtAllBooleanSelectors [
	| tester |
	tester := self gtAllStates anyOne.
	^ GtTreePagerLinkState selectors
		select: [ :each | 
			each numArgs isZero
				and: [ (tester perform: each) isKindOf: Boolean ] ]
]

{ #category : #'gt - extensions' }
GtTreePagerLinkState class >> gtAllStateSelectors [
	| tester |
	tester := self gtAllStates anyOne.
	^ (GtTreePagerLinkState selectors
		select: [ :each | 
			each numArgs isZero
				and: [ (tester perform: each) isKindOf: GtTreePagerLinkState ] ])
		sort: [ :a :b | a < b ]
]

{ #category : #'gt - extensions' }
GtTreePagerLinkState class >> gtAllStates [
	^ (GtTreePagerLinkState class methods
		select: [ :eachMethod | 
			eachMethod numArgs isZero
				and: [ eachMethod protocol = 'api - accessing'
						and: [ (GtTreePagerLinkState perform: eachMethod selector)
								isKindOf: GtTreePagerLinkState ] ] ]
		thenCollect: [ :eachMethod | GtTreePagerLinkState perform: eachMethod selector ]) 
			sort: [ :a :b | a label < b label ]
]

{ #category : #'gt - extensions' }
GtTreePagerLinkState class >> gtAllStatesFor: aView [
	<gtView>
	<gtClassView>
	^ aView columnedTree
		title: 'States';
		items: [ self gtAllStates ];
		children: [ :eachObject | 
			(eachObject isKindOf: GtTreePagerLinkState)
				ifTrue: [ self gtAllStatesWithSelectors
						select: [ :eachAssoc | eachAssoc key = eachObject ] ]
				ifFalse: [ | aState |
					aState := eachObject key perform: eachObject value.
					self gtAllStatesWithSelectors
						select: [ :eachAssoc | eachAssoc key = aState ] ] ];
		expandUpTo: 1;
		column: 'Name'
			text: [ :eachObject | 
				(eachObject isKindOf: GtTreePagerLinkState)
					ifTrue: [ eachObject label , ' state' ]
					ifFalse: [ | aText |
						aText := (eachObject value asString , ': ') asRopedText
								foreground: BlTheme default button disabledTextColor.
						aText append: (eachObject key perform: eachObject value) label asRopedText ] ];
		in: [ :theView | 
			self gtAllBooleanSelectors
				do: [ :eachSelector | 
					theView
						column: eachSelector asString
						text: [ :eachObject | 
							(eachObject isKindOf: GtTreePagerLinkState)
								ifTrue: [ (eachObject perform: eachSelector)
										ifTrue: [ 'yes' ]
										ifFalse: [ 'no' asRopedText foreground: BlTheme default button disabledTextColor ] ]
								ifFalse: [ ((eachObject key perform: eachObject value)
										perform: eachSelector)
										ifTrue: [ 'yes' ]
										ifFalse: [ 'no' asRopedText foreground: BlTheme default button disabledTextColor ] ] ]
						width: eachSelector size * 8 ] ];
		send: [ :eachObject | 
			(eachObject isKindOf: GtTreePagerLinkState)
				ifTrue: [ eachObject ]
				ifFalse: [ eachObject key perform: eachObject value ] ]
]

{ #category : #'gt - extensions' }
GtTreePagerLinkState class >> gtAllStatesWithSelectors [
	| selectors |
	selectors := self gtAllStateSelectors.

	^ self gtAllStates
		flatCollect: [ :eachState | 
			selectors
				collect: [ :eachSelector | eachState -> eachSelector ]
				thenReject: [ :eachAssoc | (eachAssoc key perform: eachAssoc value) = eachState ] ]
]

{ #category : #'api - accessing' }
GtTreePagerLinkState class >> hidden [
	^ Hidden ifNil: [ Hidden := GtTreePagerLinkInactiveSelectedState new ]
]

{ #category : #'api - accessing' }
GtTreePagerLinkState class >> inactive [
	^ Inactive ifNil: [ Inactive := GtTreePagerLinkInactiveSpawnedState new ]
]

{ #category : #'api - accessing' }
GtTreePagerLinkState class >> removed [
	^ Removed ifNil: [ Removed := GtTreePagerLinkInactiveRemovedState new ]
]

{ #category : #'api - accessing' }
GtTreePagerLinkState class >> selected [
	^ Selected ifNil: [ Selected := GtTreePagerLinkActiveSelectedState new ]
]

{ #category : #'api - accessing' }
GtTreePagerLinkState class >> spawned [
	^ Spawned ifNil: [ Spawned := GtTreePagerLinkActiveSpawnedState new ]
]

{ #category : #visiting }
GtTreePagerLinkState >> acceptVisitor: aVisitor [
	^ aVisitor visitGtTreePagerLinkState: self
]

{ #category : #'api - state' }
GtTreePagerLinkState >> activate [
	"Return an active state"

	^ self
]

{ #category : #'api - state' }
GtTreePagerLinkState >> collapse [
	"Return a collapsed state"

	^ self
]

{ #category : #'api - state' }
GtTreePagerLinkState >> expand [
	"Return an expanded state"

	^ self
]

{ #category : #'gt - extensions' }
GtTreePagerLinkState >> gtAllStatesFor: aView [
	<gtView>
	^ (self class gtAllStatesFor: aView) items: [ {self} ]
]

{ #category : #'api - state' }
GtTreePagerLinkState >> hide [
	"Return a hidden state"

	^ GtTreePagerLinkState hidden
]

{ #category : #'api - state' }
GtTreePagerLinkState >> inactivate [
	"Return an inactive state"

	^ self
]

{ #category : #'api - state' }
GtTreePagerLinkState >> isActive [
	^ false
]

{ #category : #'api - state' }
GtTreePagerLinkState >> isCollapsed [
	^ false
]

{ #category : #'api - state' }
GtTreePagerLinkState >> isExpanded [
	^ self isCollapsed not
]

{ #category : #'api - state' }
GtTreePagerLinkState >> isHidden [
	^ false
]

{ #category : #'api - state' }
GtTreePagerLinkState >> isRemoved [
	^ false
]

{ #category : #'api - state' }
GtTreePagerLinkState >> isSelected [
	^ false
]

{ #category : #'api - state' }
GtTreePagerLinkState >> isSpawned [
	"Return true if link pane model is spawned (expanded and displayed)"

	<return: #Boolean>
	^ false
]

{ #category : #accessing }
GtTreePagerLinkState >> label [
	^ String
		streamContents: [ :aStream | 
			((self className withoutPrefix: 'GtTreePagerLink') withoutSuffix: 'State')
				splitCamelCase
				do: [ :each | aStream nextPutAll: each asLowercase ]
				separatedBy: [ aStream space ] ]
]

{ #category : #'api - state' }
GtTreePagerLinkState >> remove [
	"Return a removed state"

	^ GtTreePagerLinkState removed
]

{ #category : #'api - state' }
GtTreePagerLinkState >> select [
	"Return a selected state"

	^ self
]
