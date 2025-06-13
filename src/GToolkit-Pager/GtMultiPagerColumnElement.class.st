Class {
	#name : #GtMultiPagerColumnElement,
	#superclass : #BrPagerPageElement,
	#traits : 'TGtMultiPagerWithColumnModel + TBrLayoutResizable',
	#classTraits : 'TGtMultiPagerWithColumnModel classTrait + TBrLayoutResizable classTrait',
	#instVars : [
		'toolsContainer',
		'followersContainer'
	],
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #initialization }
GtMultiPagerColumnElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtMultiPagerColumnElement >> initialize [
	super initialize.
	self matchParent.
	self padding: (BlInsets all: 10).

	self initializeToolsContainer.
	self initializeFollowingToolsContainer.
	self addChild: toolsContainer as: #tools.
	self addChild: followersContainer as: #followers
]

{ #category : #initialization }
GtMultiPagerColumnElement >> initializeFollowingToolsContainer [
	followersContainer := GtMultiPagerColumnFollowersElement new
]

{ #category : #initialization }
GtMultiPagerColumnElement >> initializeToolsContainer [
	toolsContainer := GtMultiPagerColumnToolsElement new
]

{ #category : #'api - pane model' }
GtMultiPagerColumnElement >> onColumnModelChanged [
	toolsContainer paneModel: self paneModel.
	followersContainer paneModel: self paneModel
]
