Extension { #name : #GtPhlowContext }

{ #category : #'*GToolkit-Pager' }
GtPhlowContext >> navigation [
	^ self optionAt: GtPagerPageNavigationContext ifAbsentPut: [ GtPagerPageNavigationContext new ]
]

{ #category : #'*GToolkit-Pager' }
GtPhlowContext >> navigationContext [
	^ self optionAt: GtPagerPageNavigationContext ifAbsent: [ nil ]
]

{ #category : #'*GToolkit-Pager' }
GtPhlowContext >> navigationContext: aGtPagerPageNavigationContext [
	self optionAt: GtPagerPageNavigationContext put: aGtPagerPageNavigationContext
]
