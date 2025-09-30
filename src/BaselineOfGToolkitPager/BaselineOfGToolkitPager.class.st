Class {
	#name : #BaselineOfGToolkitPager,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkitPager
}

{ #category : #baseline }
BaselineOfGToolkitPager >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec
			baseline: 'GToolkitPhlow' with: [
				spec repository: 'github://feenkcom/gtoolkit-phlow:v0.8.1847/src' ].
		spec
			baseline: 'GToolkitBasicUtility' with: [
				spec repository: 'github://feenkcom/gtoolkit-utility:v0.8.401/src' ].

		spec package: 'GToolkit-CommonPager' with: [
			spec requires: #(#GToolkitPhlow #GToolkitBasicUtility) ].
		spec package: 'GToolkit-Pager' with: [
			spec requires: #(#'GToolkit-CommonPager' #GToolkitPhlow #GToolkitBasicUtility) ].
		spec package: 'GToolkit-TreePager' with: [
			spec requires: #(#'GToolkit-CommonPager' #GToolkitPhlow #GToolkitBasicUtility) ].
	]
]
