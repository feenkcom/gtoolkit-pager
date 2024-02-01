Class {
	#name : #GtPagerContext,
	#superclass : #Object,
	#traits : 'TBlDebug + TGtOptions',
	#classTraits : 'TBlDebug classTrait + TGtOptions classTrait',
	#category : #'GToolkit-Pager-Contexts'
}

{ #category : #selection }
GtPagerContext >> toolSelectionStatesHandler [
	<return: #GtPhlowToolSelectionStateHandler>
	
	^ self 
		optionAt:  #toolSelectionStatesHandler 
		ifAbsentPut: [ GtPhlowToolSelectionStateHandler new ]
]
