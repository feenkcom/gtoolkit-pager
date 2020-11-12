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
			baseline: 'Brick' with: [
				spec repository: 'github://feenkcom/Brick:v0.8.143/src' ];
			baseline: 'GToolkitPhlow' with: [
				spec repository: 'github://feenkcom/gtoolkit-phlow:v0.8.157/src' ];
			baseline: 'GToolkitBasicUtility' with: [
				spec repository: 'github://feenkcom/gtoolkit-utility:v0.8.5/src' ].
		spec package: 'GToolkit-Pager' with: [
				spec requires: #('Brick' 'GToolkitPhlow' 'GToolkitBasicUtility' ). ]. ].

]
