Class {
	#name : #GtTreePagerModelSettings,
	#superclass : #Object,
	#traits : 'TGtOptions + TGtAnnouncer',
	#classTraits : 'TGtOptions classTrait + TGtAnnouncer classTrait',
	#instVars : [
		'announcer'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

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
