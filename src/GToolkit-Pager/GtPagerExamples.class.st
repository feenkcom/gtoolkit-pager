Class {
	#name : #GtPagerExamples,
	#superclass : #Object,
	#category : #'GToolkit-Pager-Examples'
}

{ #category : #'examples - pager' }
GtPagerExamples >> basicPager [
	<gtExample>
	| aPager |
	aPager := GtPager new.
	self assert: aPager pages size equals: 0.
	^ aPager.
]

{ #category : #'examples - pages' }
GtPagerExamples >> pageOne [
	<gtExample>
	^ BrLabel new 
		look: BrGlamorousLabelLook;
		text: self pageOneText;
		constraintsDo: [ :c | 
			c frame vertical alignCenter.
			c frame horizontal alignCenter. ]
]

{ #category : #'examples - pages' }
GtPagerExamples >> pageOneString [
	<gtExample>
	^ 'Page one'
]

{ #category : #'examples - pages' }
GtPagerExamples >> pageOneText [
	<gtExample>
	^ self pageTextFromString: self pageOneString
]

{ #category : #'examples - pages' }
GtPagerExamples >> pageTextFromString: aString [
	<gtExample>
	^ aString asRopedText foreground: BrGlamorousColors disabledButtonTextColor
]

{ #category : #'examples - pages' }
GtPagerExamples >> pageTwo [
	<gtExample>
	^ BrLabel new 
		look: BrGlamorousLabelLook;
		text: self pageTwoText;
		constraintsDo: [ :c | 
			c frame vertical alignCenter.
			c frame horizontal alignCenter. ]
]

{ #category : #'examples - pages' }
GtPagerExamples >> pageTwoString [
	<gtExample>
	^ 'Page two'
]

{ #category : #'examples - pages' }
GtPagerExamples >> pageTwoText [
	<gtExample>
	^ self pageTextFromString: self pageTwoString
]

{ #category : #'examples - pager' }
GtPagerExamples >> pagerWithOnePage [
	<gtExample>
	| aPager aPage |
	aPager := self basicPager.
	aPage := self pageOne.
	aPager addWrapped: aPage.
	self assert: aPager pages size equals: 1.
	self assert: aPager childrenCount equals: 2.
	^ aPager
]

{ #category : #'examples - pager' }
GtPagerExamples >> pagerWithTwoPages [
	<gtExample>
	| aPager aPageOne aPageTwo |
	aPager := self basicPager.
	aPageOne := self pageOne.
	aPager addWrapped: aPageOne.
	aPageTwo := self pageTwo.
	aPager addWrapped: aPageTwo.
	self assert: aPager pages size equals: 2.
	self assert: aPager childrenCount equals: 2.
	^ aPager
]
