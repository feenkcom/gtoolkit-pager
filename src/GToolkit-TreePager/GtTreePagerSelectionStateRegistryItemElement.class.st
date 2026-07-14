Class {
	#name : #GtTreePagerSelectionStateRegistryItemElement,
	#superclass : #GtTreePagerSelectionStateHandlerElement,
	#instVars : [
		'registryItem'
	],
	#category : #'GToolkit-TreePager-UI'
}

{ #category : #testing }
GtTreePagerSelectionStateRegistryItemElement >> hasRegistryItem [
	^ registryItem isNotNil
]

{ #category : #initialization }
GtTreePagerSelectionStateRegistryItemElement >> initialize [
	super initialize.

	self
		id: #'tree-pager--selection-state-registry-item';
		layout: BlLinearLayout horizontal;
		fitContent
]

{ #category : #'instance creation' }
GtTreePagerSelectionStateRegistryItemElement >> newNameLabelFor: aRegistryItem [
	^ BrLabel new
		id: #'tree-pager--selection-state-registry-item-name';
		text: (aRegistryItem name ifNil: [ 'Undefined' ]);
		aptitude: BrGlamorousLabelAptitude new;
		addAptitude: (BrGlamorousWithExplicitTooltipAptitude
				text: (aRegistryItem description
						ifNil: [ 'This is undefined selection state. Please check the code.' ]));
		constraintsDo: [ :c | 
			c linear horizontal alignLeft.
			c linear vertical alignCenter ]
]

{ #category : #'instance creation' }
GtTreePagerSelectionStateRegistryItemElement >> newStencilElementFor: aRegistryItem [
	^ aRegistryItem element
		id: #'tree-pager--selection-state-registry-item-stencil';
		constraintsDo: [ :c |
			c linear horizontal alignLeft.
			c linear vertical alignCenter ]
]

{ #category : #accessing }
GtTreePagerSelectionStateRegistryItemElement >> registryItem [
	^ registryItem
]

{ #category : #accessing }
GtTreePagerSelectionStateRegistryItemElement >> registryItem: aRegistryItem [
	registryItem == aRegistryItem ifTrue: [ ^ self ].
	registryItem := aRegistryItem.
	self updateElement
]

{ #category : #accessing }
GtTreePagerSelectionStateRegistryItemElement >> registryItemDo: aBlock [
	^ registryItem ifNotNil: aBlock
]

{ #category : #updating }
GtTreePagerSelectionStateRegistryItemElement >> updateElement [
	self removeChildren.
	self registryItemDo: [ :anItem |
		self
			addChild: (self newNameLabelFor: anItem);
			addChild: (self newStencilElementFor: anItem) ]
]
