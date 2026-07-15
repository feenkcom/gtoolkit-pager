Class {
	#name : #GtTreePagerSelectionStateRegistryItemNameElement,
	#superclass : #GtTreePagerSelectionStateRegistryItemBasicElement,
	#category : #'GToolkit-TreePager-UI'
}

{ #category : #initialization }
GtTreePagerSelectionStateRegistryItemNameElement >> initialize [
	super initialize.

	self
		id: #'tree-pager--selection-state-registry-item-name-only';
		layout: BlLinearLayout horizontal;
		fitContent
]

{ #category : #'private - instance creation' }
GtTreePagerSelectionStateRegistryItemNameElement >> newNameLabelFor: aRegistryItem [
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

{ #category : #updating }
GtTreePagerSelectionStateRegistryItemNameElement >> updateElement [
	self removeChildren.
	self registryItemDo: [ :anItem |
		self addChild: (self newNameLabelFor: anItem) ]
]
