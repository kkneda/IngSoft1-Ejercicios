!classDefinition: #OOStackTest category: 'Stack-Exercise'!
TestCase subclass: #OOStackTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:30'!
test01StackShouldBeEmptyWhenCreated

	| stack |
	
	stack := OOStack new.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:29:55'!
test02PushAddElementsToTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'something'.
	
	self deny: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:01'!
test03PopRemovesElementsFromTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'something'.
	stack pop.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:09'!
test04PopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	stack push: pushedObject.
	
	self assert: stack pop = pushedObject! !

!OOStackTest methodsFor: 'test' stamp: 'NR 9/16/2021 17:40:17'!
test05StackBehavesLIFO

	| stack firstPushedObject secondPushedObject |
	
	stack := OOStack new.
	firstPushedObject := 'firstSomething'.
	secondPushedObject := 'secondSomething'.
	
	stack push: firstPushedObject.
	stack push: secondPushedObject.
	
	self assert: stack pop = secondPushedObject.
	self assert: stack pop = firstPushedObject.
	self assert: stack isEmpty 
	! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:20'!
test06TopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	
	stack push: pushedObject.
	
	self assert: stack top = pushedObject.
	! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:24'!
test07TopDoesNotRemoveObjectFromStack

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	
	stack push: pushedObject.
	
	self assert: stack size = 1.
	stack top.
	self assert: stack size = 1.
	! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:26'!
test08CanNotPopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:31'!
test09CanNotPopWhenThereAreNoObjectsInTheStackAndTheStackHadObjects

	| stack  |
	
	stack := OOStack new.
	stack push: 'something'.
	stack pop.
	
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:44'!
test10CanNotTopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack top ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !


!classDefinition: #SentenceFinderByPrefixTest category: 'Stack-Exercise'!
TestCase subclass: #SentenceFinderByPrefixTest
	instanceVariableNames: 'stack finder prefix stringWithPrefix anotherStringWithPrefix stringWithoutPrefix anotherStringWithoutPrefix'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!SentenceFinderByPrefixTest methodsFor: 'tests' stamp: 'TC 9/19/2022 14:50:33'!
test00EmptyCollectionIsReturnedForEmptyStack
	
	self assert: ((finder findSentencesPrefixedBy: prefix) isEmpty).! !

!SentenceFinderByPrefixTest methodsFor: 'tests' stamp: 'TC 9/19/2022 16:02:04'!
test01EmptyCollectionIsReturnedForStackWhoseStringsDontStartWithPrefix
	
	stack push: stringWithoutPrefix ; push: anotherStringWithoutPrefix.
	
	self assert: ((finder findSentencesPrefixedBy: prefix) isEmpty).! !

!SentenceFinderByPrefixTest methodsFor: 'tests' stamp: 'TC 9/19/2022 16:02:25'!
test02CollectionWithSingleElementIsReturnedForStackWithSingleStringThatStartsWithPrefix
	
	stack push: stringWithPrefix.
	
	self assert: ((finder findSentencesPrefixedBy: prefix) includes: stringWithPrefix).! !

!SentenceFinderByPrefixTest methodsFor: 'tests' stamp: 'TC 9/19/2022 15:56:28'!
test03CollectionWithMultipleElementIsReturnedForStackWithMultipleStringsStartingWithPrefix
	
	stack push: stringWithPrefix; push: anotherStringWithPrefix; push: stringWithoutPrefix.
	
	self assert: ((finder findSentencesPrefixedBy: prefix) asSet) equals: ((OrderedCollection with: stringWithPrefix with: anotherStringWithPrefix) asSet).! !

!SentenceFinderByPrefixTest methodsFor: 'tests' stamp: 'TC 9/19/2022 16:02:44'!
test04SearchForPrefixesPreservesStack
	
	stack push: stringWithPrefix; push: anotherStringWithPrefix; push: stringWithoutPrefix.
	
	finder findSentencesPrefixedBy: prefix.
	
	self assert: stack size = 3; assert: stack pop = stringWithoutPrefix; assert: stack pop = anotherStringWithPrefix; assert: stack pop = stringWithPrefix.! !

!SentenceFinderByPrefixTest methodsFor: 'tests' stamp: 'TC 9/19/2022 16:00:24'!
test05SearchIsCaseSensitive
	
	stack push: stringWithPrefix; push: stringWithPrefix asUppercase.
	
	self assert: (finder findSentencesPrefixedBy: prefix) equals: (OrderedCollection with: stringWithPrefix).! !

!SentenceFinderByPrefixTest methodsFor: 'tests' stamp: 'TC 9/19/2022 16:00:55'!
test06SearchThrowsErrorForEmptyPrefix
	
	stack push: stringWithPrefix.
	
	self should: [finder findSentencesPrefixedBy: '']
	raise: Error
	withExceptionDo: [
		:anError |
		self assert: anError messageText = SentenceFinderByPrefix invalidPrefixErrorDescription
	].! !

!SentenceFinderByPrefixTest methodsFor: 'tests' stamp: 'TC 9/19/2022 16:01:20'!
test07SearchThrowsErrorForPrefixWithWhitespace
	
	stack push: stringWithPrefix.
	
	self should: [finder findSentencesPrefixedBy: prefix,' ']
	raise: Error
	withExceptionDo: [
		:anError |
		self assert: anError messageText = SentenceFinderByPrefix invalidPrefixErrorDescription
	].! !


!SentenceFinderByPrefixTest methodsFor: 'setup' stamp: 'TC 9/19/2022 16:00:12'!
setUp
	
	stack := OOStack new.
	finder := SentenceFinderByPrefix with: stack.
	prefix := 'bingus'.
	
	stringWithPrefix := prefix,'myBeloved'.
	anotherStringWithPrefix := prefix,'IsLife'.
	stringWithoutPrefix := 'bababooey'.
	anotherStringWithoutPrefix := 'ohYeahWooYeahOhYeahWooYeahWooYeahOhYeahOhWooWooYeahWooYeah'. ! !


!classDefinition: #OOStack category: 'Stack-Exercise'!
Object subclass: #OOStack
	instanceVariableNames: 'top size'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStack methodsFor: 'initialization' stamp: 'TC 9/19/2022 09:21:11'!
initialize
	
	top := NullOOStackElement new.
	size := 0.! !


!OOStack methodsFor: 'testing' stamp: 'TC 9/19/2022 09:09:47'!
isEmpty
	
	^size = 0.! !


!OOStack methodsFor: 'addition' stamp: 'TC 9/19/2022 09:47:45'!
push: anObjectToPutOnTop
	
	| formerTop newTop |
	
	formerTop := top.
	newTop := ConcreteOOStackElement newWith: anObjectToPutOnTop above: formerTop.
	
	top := newTop.
	size := size + 1.! !


!OOStack methodsFor: 'removal' stamp: 'TC 9/19/2022 09:39:28'!
pop
	
	| formerTop newTop |
	
	formerTop := top.
	newTop := top nextBelow.
	
	top := newTop.
	size := size - 1.
	
	^formerTop content.! !


!OOStack methodsFor: 'inspection' stamp: 'TC 9/19/2022 09:05:23'!
size
	
	^size.! !

!OOStack methodsFor: 'inspection' stamp: 'TC 9/19/2022 09:40:41'!
top
	
	^top content.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OOStack class' category: 'Stack-Exercise'!
OOStack class
	instanceVariableNames: ''!

!OOStack class methodsFor: 'error descriptions' stamp: 'NR 9/16/2021 17:39:43'!
stackEmptyErrorDescription
	
	^ 'stack is empty!!!!!!'! !


!classDefinition: #OOStackElement category: 'Stack-Exercise'!
Object subclass: #OOStackElement
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackElement methodsFor: 'inspection' stamp: 'TC 9/19/2022 09:17:31'!
content
	
	self subclassResponsibility.! !

!OOStackElement methodsFor: 'inspection' stamp: 'TC 9/19/2022 09:26:46'!
nextBelow
	
	self subclassResponsibility.! !


!classDefinition: #ConcreteOOStackElement category: 'Stack-Exercise'!
OOStackElement subclass: #ConcreteOOStackElement
	instanceVariableNames: 'content nextBelow'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!ConcreteOOStackElement methodsFor: 'inspection' stamp: 'TC 9/19/2022 09:17:46'!
content
	
	^content.! !

!ConcreteOOStackElement methodsFor: 'inspection' stamp: 'TC 9/19/2022 09:27:25'!
nextBelow
	
	^nextBelow.! !


!ConcreteOOStackElement methodsFor: 'initialization' stamp: 'TC 9/19/2022 09:29:35'!
initializeWith: aContentForTheElement above: aStackElementBelow
	
	content := aContentForTheElement.
	nextBelow := aStackElementBelow.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ConcreteOOStackElement class' category: 'Stack-Exercise'!
ConcreteOOStackElement class
	instanceVariableNames: ''!

!ConcreteOOStackElement class methodsFor: 'instance creation' stamp: 'TC 9/19/2022 09:47:12'!
newWith: aContentForTheElement above: aStackElementBelow
	
	^ConcreteOOStackElement new initializeWith: aContentForTheElement above: aStackElementBelow.! !


!classDefinition: #NullOOStackElement category: 'Stack-Exercise'!
OOStackElement subclass: #NullOOStackElement
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!NullOOStackElement methodsFor: 'inspection' stamp: 'TC 9/19/2022 09:18:42'!
content
	
	^self error: OOStack stackEmptyErrorDescription.! !

!NullOOStackElement methodsFor: 'inspection' stamp: 'TC 9/19/2022 09:28:03'!
nextBelow
	
	^self error: OOStack stackEmptyErrorDescription.! !


!classDefinition: #SentenceFinderByPrefix category: 'Stack-Exercise'!
Object subclass: #SentenceFinderByPrefix
	instanceVariableNames: 'stack'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!SentenceFinderByPrefix methodsFor: 'search' stamp: 'TC 9/19/2022 13:45:06'!
findSentencesPrefixedBy: aStringPrefix
	
	| sentencesWithPrefix |
	
	self throwErrorIfNotValid: aStringPrefix.
		
	sentencesWithPrefix := OrderedCollection new.
	
	self addSentencesPrefixedBy: aStringPrefix into: sentencesWithPrefix.
	
	^sentencesWithPrefix.! !


!SentenceFinderByPrefix methodsFor: 'private - operations' stamp: 'TC 9/19/2022 13:17:52'!
addSentencesPrefixedBy: aStringPrefix into: anOrderedCollection
	
	| prefixOperations recoveryStack |
	
	prefixOperations := StringOperations new.
	recoveryStack := OOStack new.
	
	[stack isEmpty] whileFalse: [
		| sentenceAtTheTop |
		
		sentenceAtTheTop := stack pop.
		(prefixOperations checkIf: aStringPrefix isPrefixOf: sentenceAtTheTop) ifTrue: [
			anOrderedCollection add: sentenceAtTheTop.
		].
		recoveryStack push: sentenceAtTheTop.
	].
	
	self restoreElementsFrom: recoveryStack.! !

!SentenceFinderByPrefix methodsFor: 'private - operations' stamp: 'TC 9/19/2022 13:17:37'!
restoreElementsFrom: aRecoveryStack
	
	[aRecoveryStack isEmpty] whileFalse: [
		stack push: (aRecoveryStack pop).
	].! !


!SentenceFinderByPrefix methodsFor: 'initialization' stamp: 'TC 9/19/2022 13:38:37'!
initializeWith: aStack
	
	stack := aStack.! !


!SentenceFinderByPrefix methodsFor: 'private - validation' stamp: 'TC 9/19/2022 13:43:41'!
throwErrorIfNotValid: aStringPrefix
	
	| prefixAsOrderedCollection whitespace |
	
	prefixAsOrderedCollection := aStringPrefix asOrderedCollection.
	whitespace := $ . "(es un espacio)"
	
	(aStringPrefix isEmpty or: [prefixAsOrderedCollection includes: whitespace]) ifTrue: [
		^self error: SentenceFinderByPrefix invalidPrefixErrorDescription.
	].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SentenceFinderByPrefix class' category: 'Stack-Exercise'!
SentenceFinderByPrefix class
	instanceVariableNames: ''!

!SentenceFinderByPrefix class methodsFor: 'instance creation' stamp: 'TC 9/19/2022 14:07:22'!
with: aStack
	
	^SentenceFinderByPrefix new initializeWith: aStack.! !


!SentenceFinderByPrefix class methodsFor: 'error descriptions' stamp: 'TC 9/19/2022 13:42:03'!
invalidPrefixErrorDescription
	
	^ 'prefix is invalid (either empty or holding whitespace).'! !


!classDefinition: #StringOperations category: 'Stack-Exercise'!
Object subclass: #StringOperations
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!
!StringOperations commentStamp: '<historical>' prior: 0!
Los métodos de esta clase podrían haber sido auxiliares privados de SentenceFinderByPrefix, pero me pareció que por ser de utilidad general para las strings quizás no estaba mal meterlos acá, en una clase separada. Tampoco quise extender String con métodos extra porque entiendo que no era la idea y porque estos métodos quizás sean demasiado específicos (aunque quizás no estaría tan mal, dado que otras clases como la de los enteros, por ejemplo, tienen definidas operaciones como el factorial).!


!StringOperations methodsFor: 'testing' stamp: 'TC 9/19/2022 12:21:00'!
checkIf: aStringPrefix isPrefixOf: aString
	
	^(aStringPrefix size = 0) or: [
		(aStringPrefix size <= aString size) and: [
			aStringPrefix = (aString copyFrom: 1 to: aStringPrefix size)
		]
	].
	
	"Para mayor correctitud habría que evaluar que los colaboradores son strings."! !
