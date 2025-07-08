Class {
	#name : #GtTreePagerPaneLinks,
	#superclass : #Object,
	#instVars : [
		'paneModel',
		'links'
	],
	#category : #'GToolkit-Pager-Tree Pager'
}

{ #category : #'api - active link' }
GtTreePagerPaneLinks >> activeLink [
	^ links detect: #isActive ifNone: [ nil ]
]

{ #category : #'api - active link' }
GtTreePagerPaneLinks >> activeLink: aNewLinkModel [
	| anOldLinkModel |
	self assert: [ links includes: aNewLinkModel ].
	anOldLinkModel := self activeLink.
	anOldLinkModel = aNewLinkModel ifTrue: [ ^ self ].
	
	anOldLinkModel ifNotNil: #inactivate.
	aNewLinkModel activate.
	
	self notifyActiveLinkChangedFrom: anOldLinkModel to: aNewLinkModel
]

{ #category : #'api - links' }
GtTreePagerPaneLinks >> addLink: aLinkModel [
	aLinkModel isActive ifTrue: [ self inactivateLink ].

	^ self links: (self links copyWith: aLinkModel)
]

{ #category : #views }
GtTreePagerPaneLinks >> gtLinksFor: aView [
	<gtView>
	links ifNil: [ ^ aView empty ].
	^ aView columnedTree
		title: 'Links';
		items: [ links ];
		children: #followingLinks;
		column: 'Link' text: [ :each | each gtDisplayString ];
		column: 'State' text: [ :each | each state gtDisplayString ];
		column: 'Active'
			text: [ :each | 
				each isActive
					ifTrue: [ 'yes' ]
					ifFalse: [ 'no' asRopedText foreground: BlTheme default button disabledTextColor ] ]
			width: 50;
		column: 'Spawned'
			text: [ :each | 
				each isDisplayed
					ifTrue: [ 'yes' ]
					ifFalse: [ 'no' asRopedText foreground: BlTheme default button disabledTextColor ] ]
			width: 70;
		column: 'Hidden'
			text: [ :each | 
				each isHidden
					ifTrue: [ 'yes' ]
					ifFalse: [ 'no' asRopedText foreground: BlTheme default button disabledTextColor ] ]
			width: 60;
		column: 'Collapsed'
			text: [ :each | 
				each isCollapsed
					ifTrue: [ 'yes' ]
					ifFalse: [ 'no' asRopedText foreground: BlTheme default button disabledTextColor ] ]
			width: 70
]

{ #category : #'api - active link' }
GtTreePagerPaneLinks >> inactivateLink [
	| anOldActiveLink |
	anOldActiveLink := self activeLink ifNil: [ ^ self ].
	anOldActiveLink inactivate.

	self notifyActiveLinkChangedFrom: anOldActiveLink to: nil
]

{ #category : #'api - active link' }
GtTreePagerPaneLinks >> inactivateLink: aLinkModel [
	self activeLink = aLinkModel ifFalse: [ ^ self ].

	self inactivateLink
]

{ #category : #initialization }
GtTreePagerPaneLinks >> initialize [
	super initialize.
	links := Array empty
]

{ #category : #'api - links' }
GtTreePagerPaneLinks >> links [
	^ links
]

{ #category : #'api - links' }
GtTreePagerPaneLinks >> links: aCollection [
	| anOldFollowingLinks |
	self assert: [ aCollection allSatisfy: [ :each | 
		each isKindOf: GtTreePagerLinkModel ] ].

	links = aCollection ifTrue: [ ^ self ].

	aCollection do: [ :each | each previousPane: self paneModel ].
	anOldFollowingLinks := links.
	links := aCollection.
	self updateActiveLink.

	self notifyFollowingLinksChanged: anOldFollowingLinks
]

{ #category : #'private - notifying' }
GtTreePagerPaneLinks >> notifyActiveLinkChangedFrom: anOldActiveLink to: aNewActiveLink [
	self paneModel notifyActiveLinkChangedFrom: anOldActiveLink to: aNewActiveLink
]

{ #category : #'private - notifying' }
GtTreePagerPaneLinks >> notifyFollowingLinksChanged: anOldFollowingLinks [
	self paneModel notifyFollowingLinksChanged: anOldFollowingLinks
]

{ #category : #accessing }
GtTreePagerPaneLinks >> paneModel [
	^ paneModel
]

{ #category : #accessing }
GtTreePagerPaneLinks >> paneModel: anObject [
	paneModel := anObject
]

{ #category : #'api - links' }
GtTreePagerPaneLinks >> removeLink: aLinkModel [
	self links: (self links copyWithout: aLinkModel)
]

{ #category : #'private - updating' }
GtTreePagerPaneLinks >> updateActiveLink [
	links ifEmpty: [ ^ self ].

	self activeLink notNil ifFalse: [ self activeLink: links last ]
]
