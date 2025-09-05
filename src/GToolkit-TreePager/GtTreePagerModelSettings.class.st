Class {
	#name : #GtTreePagerModelSettings,
	#superclass : #Object,
	#traits : 'TGtOptions + TGtAnnouncer',
	#classTraits : 'TGtOptions classTrait + TGtAnnouncer classTrait',
	#instVars : [
		'announcer'
	],
	#classInstVars : [
		'defaultNumberOfVisibleColumns'
	],
	#category : #'GToolkit-TreePager-Model Rest'
}

{ #category : #'api - settings' }
GtTreePagerModelSettings class >> defaultNumberOfVisibleColumns [
	^ defaultNumberOfVisibleColumns ifNil: [ 2 ]
]

{ #category : #'api - settings' }
GtTreePagerModelSettings class >> defaultNumberOfVisibleColumns: aNumber [
	defaultNumberOfVisibleColumns := aNumber
]

{ #category : #announcer }
GtTreePagerModelSettings >> announcer [
	<return: #Announcer>
	^ announcer
]

{ #category : #initialization }
GtTreePagerModelSettings >> announcer: anAnnouncer [
	announcer := anAnnouncer
]

{ #category : #'api - settings' }
GtTreePagerModelSettings >> columnHeight [
	^ self
		optionAt: #columnHeight
		ifAbsentPut: [ BlHorizontalTreeFlowLayoutCellCount new ]
]

{ #category : #'api - settings' }
GtTreePagerModelSettings >> columnHeight: aLayoutCount [
	self
		optionAt: #columnHeight
		ifPresent: [ :anExistingCount | 
			anExistingCount = aLayoutCount
				ifFalse: [ self optionAt: #columnHeight put: aLayoutCount ]
				ifTrue: [ ^ self ] ]
		ifAbsentPut: [ aLayoutCount ].

	self announcer
		announce: (GtTreePagerModelColumnHeightChanged new
				settings: self;
				columnHeight: aLayoutCount)
]

{ #category : #'api - settings' }
GtTreePagerModelSettings >> copySettingsFrom: aModelSettings [
	aModelSettings optionsDo: [ :aKey :aValue | 
		self optionAt: aKey put: aValue shallowCopy ]
]

{ #category : #'api - settings' }
GtTreePagerModelSettings >> decreaseNumberOfVisibleColumns [
	self numberOfVisibleColumns: self numberOfVisibleColumns - 1
]

{ #category : #'api - settings' }
GtTreePagerModelSettings >> fillEntireColumnHeight [
	"Each column height is equally filled by available children"

	self columnHeight: BlHorizontalTreeFlowLayoutCellCount new
]

{ #category : #'api - settings' }
GtTreePagerModelSettings >> fillRowHeight [
	"Each child in a given column occupies just its row height.
	In other words, the column height might not be used completely."

	self columnHeight: BlHorizontalTreeFlowLayoutRowGrowingCount new
]

{ #category : #'api - settings' }
GtTreePagerModelSettings >> increaseNumberOfVisibleColumns [
	self numberOfVisibleColumns: self numberOfVisibleColumns + 1
]

{ #category : #'api - settings' }
GtTreePagerModelSettings >> numberOfVisibleColumns [
	^ self optionAt: #numberOfVisibleColumns ifAbsentPut: [ self class defaultNumberOfVisibleColumns ]
]

{ #category : #'api - settings' }
GtTreePagerModelSettings >> numberOfVisibleColumns: aLayoutColumnCount [
	| aNewValue |
	self assert: [ aLayoutColumnCount isInteger ].
	
	aNewValue := aLayoutColumnCount max: 1.

	self
		optionAt: #numberOfVisibleColumns
		ifPresent: [ :anExistingCount | 
			anExistingCount = aNewValue
				ifFalse: [ self optionAt: #numberOfVisibleColumns put: aNewValue ]
				ifTrue: [ ^ self ] ]
		ifAbsentPut: [ aNewValue ].

	self announcer
		announce: (GtTreePagerModelNumberOfVisibleColumnsChanged new
				settings: self;
				amount: aNewValue)
]
