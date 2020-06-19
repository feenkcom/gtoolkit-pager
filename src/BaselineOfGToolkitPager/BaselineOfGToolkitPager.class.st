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
				spec repository: 'github://feenkcom/Brick:v0.7.525/src' ];
			baseline: 'GToolkitPhlow' with: [
				spec repository: 'github://feenkcom/gtoolkit-phlow:v0.7.541/src' ];
			baseline: 'GToolkitBasicUtility' with: [
				spec repository: 'github://feenkcom/gtoolkit-utility:v0.7.35/src' ].
		spec package: 'GToolkit-Pager' with: [
				spec requires: #('Brick' 'GToolkitPhlow' 'GToolkitBasicUtility' ). ]. ].

]
