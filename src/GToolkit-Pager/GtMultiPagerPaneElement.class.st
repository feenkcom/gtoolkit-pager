Class {
	#name : #GtMultiPagerPaneElement,
	#superclass : #BrPagerPageElement,
	#traits : 'TGtMultiPagerWithPaneModel + TBrLayoutResizable',
	#classTraits : 'TGtMultiPagerWithPaneModel classTrait + TBrLayoutResizable classTrait',
	#instVars : [
		'toolsContainer',
		'followersContainer'
	],
	#category : #'GToolkit-Pager-Multi Pager - Model'
}

{ #category : #initialization }
GtMultiPagerPaneElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtMultiPagerPaneElement >> initialize [
	super initialize.
	self matchParent.
	self padding: (BlInsets all: 10).

	self initializeToolsContainer.
	self initializeFollowingToolsContainer.
	self addChild: toolsContainer as: #tools.
	self addChild: followersContainer as: #followers
]

{ #category : #initialization }
GtMultiPagerPaneElement >> initializeFollowingToolsContainer [
	followersContainer := GtMultiPagerPaneFollowersElement new
]

{ #category : #initialization }
GtMultiPagerPaneElement >> initializeToolsContainer [
	toolsContainer := GtMultiPagerPaneToolsElement new
]

{ #category : #'api - pane model' }
GtMultiPagerPaneElement >> onPaneModelChanged [
	toolsContainer paneModel: self paneModel.
	followersContainer paneModel: self paneModel
]
