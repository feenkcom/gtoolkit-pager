Class {
	#name : #GtPagerPageElement,
	#superclass : #BrPagerPageElement,
	#category : #'GToolkit-Pager-UI'
}

{ #category : #initialization }
GtPagerPageElement >> initialize [
	super initialize.
	
	self
		layout: BlLinearLayout horizontal;
		margin: (BlInsets all: 0);
		constraintsDo: [ :c | c vertical matchParent ]
]
