!classDefinition: #I category: 'RomanNaturalNumbers'!
DenotativeObject subclass: #I
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'RomanNaturalNumbers'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'I class' category: 'RomanNaturalNumbers'!
I class
	instanceVariableNames: ''!

!I class methodsFor: 'navigation' stamp: 'TC 8/25/2022 20:41:38'!
next
	^II! !


!I class methodsFor: 'algebra' stamp: 'TC 9/5/2022 03:07:27'!
* aMultiplier
	^aMultiplier! !

!I class methodsFor: 'algebra' stamp: 'TC 8/25/2022 21:11:11'!
+ anAddend
	^anAddend next! !

!I class methodsFor: 'algebra' stamp: 'TC 9/5/2022 03:51:16'!
- aSubtrahend
	^self error: self negativeNumbersNotSupportedErrorDescription.! !

!I class methodsFor: 'algebra' stamp: 'TC 9/5/2022 03:53:41'!
/ aDivisor
	self = aDivisor ifTrue: [
		^self.
	]
	ifFalse: [
		^self error: self canNotDivideByBiggerNumberErrorDescription.
	].! !

!I class methodsFor: 'algebra' stamp: 'TC 9/5/2022 03:04:06'!
subtractFrom: aMinuend 
	^aMinuend previous.! !


!I class methodsFor: 'errors' stamp: 'TC 9/5/2022 03:49:32'!
canNotDivideByBiggerNumberErrorDescription
	^'Dividend must be larger than or equal to divisor.'.! !

!I class methodsFor: 'errors' stamp: 'TC 9/5/2022 03:50:28'!
negativeNumbersNotSupportedErrorDescription
	^'Minuend must be larger than subtrahend.'.! !


!I class methodsFor: 'comparison' stamp: 'TC 9/5/2022 05:02:44'!
> aNaturalNumber
	^false.! !


!classDefinition: #II category: 'RomanNaturalNumbers'!
DenotativeObject subclass: #II
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'RomanNaturalNumbers'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'II class' category: 'RomanNaturalNumbers'!
II class
	instanceVariableNames: 'next previous'!

!II class methodsFor: 'navigation' stamp: 'TC 9/5/2022 02:30:32'!
nameOfNext
	(self name endsWith: 'CMXCIX') ifTrue: [^(self name withoutSuffix: 'CMXCIX'), 'M'].
	(self name endsWith: 'DCCCXCIX') ifTrue: [^(self name withoutSuffix: 'DCCCXCIX'), 'CM'].
	(self name endsWith: 'CDXCIX') ifTrue: [^(self name withoutSuffix: 'CDXCIX'), 'D'].
	(self name endsWith: 'CCCXCIX') ifTrue: [^(self name withoutSuffix: 'CCCXCIX'), 'CD'].
	(self name endsWith: 'XCIX') ifTrue: [^(self name withoutSuffix: 'XCIX'), 'C'].
	(self name endsWith: 'LXXXIX') ifTrue: [^(self name withoutSuffix: 'LXXXIX'), 'XC'].
	(self name endsWith: 'XLIX') ifTrue: [^(self name withoutSuffix: 'XLIX'), 'L'].
	(self name endsWith: 'XXXIX') ifTrue: [ ^(self name withoutSuffix: 'XXXIX'), 'XL' ].
	(self name endsWith: 'IX') ifTrue: [ ^(self name withoutSuffix: 'IX'), 'X' ].
	(self name endsWith: 'VIII') ifTrue: [ ^(self name withoutSuffix: 'VIII'), 'IX' ].
	(self name endsWith: 'IV') ifTrue: [ ^(self name withoutSuffix: 'IV'), 'V' ].
	(self name endsWith: 'III') ifTrue: [ ^(self name withoutSuffix: 'III'), 'IV' ].
	^ self name , 'I'! !

!II class methodsFor: 'navigation' stamp: 'TC 9/5/2022 02:33:19'!
next
	next ifNil: [
		next := II createChildNamed: self nameOfNext.
		next previous: self.
	].
	^next! !

!II class methodsFor: 'navigation' stamp: 'TC 8/25/2022 21:20:04'!
previous
	^previous! !

!II class methodsFor: 'navigation' stamp: 'TC 8/25/2022 21:27:07'!
previous: aNumber
	previous := aNumber! !


!II class methodsFor: 'algebra' stamp: 'TC 9/5/2022 03:15:14'!
* aMultiplier
	^aMultiplier + (self previous * aMultiplier)! !

!II class methodsFor: 'algebra' stamp: 'TC 8/25/2022 21:17:31'!
+ anAddend 
	^self previous + anAddend next! !

!II class methodsFor: 'algebra' stamp: 'TC 9/5/2022 02:37:09'!
- aSubtrahend
	^aSubtrahend subtractFrom: self.! !

!II class methodsFor: 'algebra' stamp: 'TC 9/5/2022 04:52:43'!
/ aDivisor
	self > aDivisor ifTrue: [
		|remainder|
		remainder := self - aDivisor.
		(aDivisor > remainder) ifTrue: [^I.].
		^(remainder / aDivisor) + I.
	].
	self = aDivisor ifTrue: [^I.].
	^self error: self canNotDivideByBiggerNumberErrorDescription.! !

!II class methodsFor: 'algebra' stamp: 'TC 9/5/2022 03:04:18'!
subtractFrom: aMinuend
	^aMinuend previous - self previous! !


!II class methodsFor: 'administrative' stamp: 'TC 8/25/2022 21:38:48'!
removeAllNext
	next ifNotNil: [next removeAllNext. next removeFromSystem. next := nil]! !


!II class methodsFor: 'comparison' stamp: 'TC 9/5/2022 05:12:46'!
> aNaturalNumber
	aNaturalNumber = I ifTrue: [^true.].
	^(self previous > aNaturalNumber previous).! !


!II class methodsFor: 'errors' stamp: 'TC 9/5/2022 05:06:26'!
canNotDivideByBiggerNumberErrorDescription
	^'Dividend must be larger than or equal to divisor.'! !


!II class methodsFor: '--** private fileout/in **--' stamp: 'TC 9/5/2022 05:12:51'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := III.
	previous := I.! !


!classDefinition: #III category: 'RomanNaturalNumbers'!
II subclass: #III
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'RomanNaturalNumbers'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'III class' category: 'RomanNaturalNumbers'!
III class
	instanceVariableNames: ''!

!III class methodsFor: '--** private fileout/in **--' stamp: 'TC 9/5/2022 05:12:51'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := IV.
	previous := II.! !


!classDefinition: #IV category: 'RomanNaturalNumbers'!
II subclass: #IV
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'RomanNaturalNumbers'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IV class' category: 'RomanNaturalNumbers'!
IV class
	instanceVariableNames: ''!

!IV class methodsFor: '--** private fileout/in **--' stamp: 'TC 9/5/2022 05:12:51'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := nil.
	previous := III.! !

II initializeAfterFileIn!
III initializeAfterFileIn!
IV initializeAfterFileIn!