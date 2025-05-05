Class {
	#name : #GtPagerExamples,
	#superclass : #Object,
	#category : #'GToolkit-Pager-Examples'
}

{ #category : #'examples - pager' }
GtPagerExamples >> basicPager [
	<gtExample>
	<return: #GtPager>
	| aPager |
	aPager := GtPager new.
	self assert: aPager pages size equals: 0.
	^ aPager
]

{ #category : #'examples - pages' }
GtPagerExamples >> pageOne [
	<gtExample>
	<return: #BrLabel>
	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude;
		text: self pageOneText;
		constraintsDo: [ :c | 
			c frame vertical alignCenter.
			c frame horizontal alignCenter ]
]

{ #category : #'examples - pages' }
GtPagerExamples >> pageOneString [
	<gtExample>
	<return: #ByteString>
	^ 'Page one'
]

{ #category : #'examples - pages' }
GtPagerExamples >> pageOneText [
	<gtExample>
	<return: #BlRunRopedText>
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
	<return: #BrLabel>
	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude;
		text: self pageTwoText;
		constraintsDo: [ :c | 
			c frame vertical alignCenter.
			c frame horizontal alignCenter ]
]

{ #category : #'examples - pages' }
GtPagerExamples >> pageTwoString [
	<gtExample>
	<return: #ByteString>
	^ 'Page two'
]

{ #category : #'examples - pages' }
GtPagerExamples >> pageTwoText [
	<gtExample>
	<return: #BlRunRopedText>
	^ self pageTextFromString: self pageTwoString
]

{ #category : #'examples - pager' }
GtPagerExamples >> pagerWithOnePage [
	<gtExample>
	<return: #GtPager>
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
	<return: #GtPager>
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
