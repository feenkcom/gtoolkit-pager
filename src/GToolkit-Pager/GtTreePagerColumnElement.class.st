Class {
	#name : #GtTreePagerColumnElement,
	#superclass : #BrPagerPageElement,
	#traits : 'TGtTreePagerWithColumnModel + TBrLayoutResizable',
	#classTraits : 'TGtTreePagerWithColumnModel classTrait + TBrLayoutResizable classTrait',
	#instVars : [
		'toolsContainer',
		'followersContainer'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #initialization }
GtTreePagerColumnElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtTreePagerColumnElement >> initialize [
	super initialize.
	self matchParent.
	self padding: (BlInsets all: 10).

	self initializeToolsContainer.
	self initializeFollowingToolsContainer.
	self addChild: toolsContainer as: #tools.
	self addChild: followersContainer as: #followers
]

{ #category : #initialization }
GtTreePagerColumnElement >> initializeFollowingToolsContainer [
	followersContainer := GtTreePagerColumnFollowersElement new
]

{ #category : #initialization }
GtTreePagerColumnElement >> initializeToolsContainer [
	toolsContainer := GtTreePagerColumnToolsElement new
]

{ #category : #'api - pane model' }
GtTreePagerColumnElement >> onColumnModelChanged [
	toolsContainer paneModel: self paneModel.
	followersContainer paneModel: self paneModel
]
