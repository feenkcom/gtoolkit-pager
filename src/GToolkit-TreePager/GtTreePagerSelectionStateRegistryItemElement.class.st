Class {
	#name : #GtTreePagerSelectionStateRegistryItemElement,
	#superclass : #GtTreePagerSelectionStateRegistryItemBasicElement,
	#category : #'GToolkit-TreePager-UI'
}

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

{ #category : #updating }
GtTreePagerSelectionStateRegistryItemElement >> updateElement [
	self removeChildren.
	self registryItemDo: [ :anItem |
		self
			addChild: (self newNameLabelFor: anItem);
			addChild: (self newStencilElementFor: anItem) ]
]
