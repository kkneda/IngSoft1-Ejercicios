!classDefinition: #CantSuspend category: 'CodigoRepetido-Ejercicio'!
Error subclass: #CantSuspend
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!


!classDefinition: #NotFound category: 'CodigoRepetido-Ejercicio'!
Error subclass: #NotFound
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!


!classDefinition: #CustomerBookTest category: 'CodigoRepetido-Ejercicio'!
TestCase subclass: #CustomerBookTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!

!CustomerBookTest methodsFor: 'testing' stamp: 'TC 9/7/2022 16:50:34'!
checkThat: aBlock causesException: anException andSuccesfulExecutionOf: anEnsuingBlock
	
	[ aBlock value.
	self fail ]
		on: anException 
		do: anEnsuingBlock.! !

!CustomerBookTest methodsFor: 'testing' stamp: 'TC 9/7/2022 16:50:38'!
checkThat: aBlock executesInLessThan: anAmountOfTime
	
	|millisecondsBeforeExecutingBlock millisecondsAfterExecutingBlock|
	
	millisecondsBeforeExecutingBlock := Time millisecondClockValue * millisecond.
	aBlock value.
	millisecondsAfterExecutingBlock := Time millisecondClockValue * millisecond.
	
	self assert: (millisecondsAfterExecutingBlock - millisecondsBeforeExecutingBlock) < anAmountOfTime! !

!CustomerBookTest methodsFor: 'testing' stamp: 'TC 9/7/2022 16:50:41'!
checkThat: aCustomerBook hasActiveCustomersAmount: aNumberOfActiveCustomers 
suspendedCustomersAmount: aNumberOfSuspendedCustomers andTotalCustomersAmount: aNumberOfTotalCustomers
	
	self assert: aNumberOfActiveCustomers equals: aCustomerBook numberOfActiveCustomers.
	self assert: aNumberOfSuspendedCustomers equals: aCustomerBook numberOfSuspendedCustomers.
	self assert: aNumberOfTotalCustomers equals: aCustomerBook numberOfCustomers.! !

!CustomerBookTest methodsFor: 'testing' stamp: 'TC 9/7/2022 18:56:52'!
newCustomerBookWithCustomerNamed: aName
	^(CustomerBook new) addCustomerNamed: aName.! !

!CustomerBookTest methodsFor: 'testing' stamp: 'TC 9/7/2022 17:44:42'!
test01AddingCustomerShouldNotTakeMoreThan50Milliseconds

	| customerBook |
	
	customerBook := CustomerBook new.
	
	self checkThat: [ customerBook addCustomerNamed:'John Lennon' ] executesInLessThan: 50 * millisecond.! !

!CustomerBookTest methodsFor: 'testing' stamp: 'TC 9/7/2022 18:57:45'!
test02RemovingCustomerShouldNotTakeMoreThan100Milliseconds

	| customerBook paulMcCartney |
	
	paulMcCartney := 'Paul McCartney'.
	customerBook := self newCustomerBookWithCustomerNamed: paulMcCartney.
	
	self checkThat: [ customerBook removeCustomerNamed: paulMcCartney ] executesInLessThan: 100 * millisecond.! !

!CustomerBookTest methodsFor: 'testing' stamp: 'TC 9/7/2022 17:44:52'!
test03CanNotAddACustomerWithEmptyName 

	| customerBook |
			
	customerBook := CustomerBook new.
	
	self checkThat: [ customerBook addCustomerNamed: ''. ] causesException: Error andSuccesfulExecutionOf:  [ 
			:causedException | 
			self assert: causedException messageText = CustomerBook customerCanNotBeEmptyErrorMessage.
			self assert: customerBook isEmpty. ].! !

!CustomerBookTest methodsFor: 'testing' stamp: 'TC 9/7/2022 18:58:50'!
test04CanNotRemoveAnInvalidCustomer
	
	| customerBook johnLennon |
	
	johnLennon := 'John Lennon'.
	customerBook := self newCustomerBookWithCustomerNamed: johnLennon.
	
	self checkThat: [ customerBook removeCustomerNamed: 'Paul McCartney'. ] causesException: NotFound andSuccesfulExecutionOf:  [ 
			self assert: customerBook numberOfCustomers = 1.
			self assert: (customerBook includesCustomerNamed: johnLennon). ].
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'TC 9/7/2022 19:00:48'!
test05SuspendingACustomerShouldNotRemoveItFromCustomerBook

	| customerBook paulMcCartney|
	
	paulMcCartney := 'Paul McCartney'.
	customerBook := self newCustomerBookWithCustomerNamed: paulMcCartney.
	customerBook suspendCustomerNamed: paulMcCartney.
	
	self checkThat: customerBook hasActiveCustomersAmount: 0 suspendedCustomersAmount: 1 andTotalCustomersAmount: 1.
	self assert: (customerBook includesCustomerNamed: paulMcCartney).! !

!CustomerBookTest methodsFor: 'testing' stamp: 'TC 9/7/2022 19:02:05'!
test06RemovingASuspendedCustomerShouldRemoveItFromCustomerBook

	| customerBook paulMcCartney|
	
	paulMcCartney := 'Paul McCartney'.
	customerBook := self newCustomerBookWithCustomerNamed: paulMcCartney.
	customerBook suspendCustomerNamed: paulMcCartney.
	customerBook removeCustomerNamed: paulMcCartney.
	
	self checkThat: customerBook hasActiveCustomersAmount: 0 suspendedCustomersAmount: 0 andTotalCustomersAmount: 0.
	self deny: (customerBook includesCustomerNamed: paulMcCartney).


	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'TC 9/7/2022 19:02:32'!
test07CanNotSuspendAnInvalidCustomer
	
	| customerBook johnLennon |
			
	johnLennon := 'John Lennon'.
	customerBook := self newCustomerBookWithCustomerNamed: johnLennon.
	
	self checkThat: [ customerBook suspendCustomerNamed: 'George Harrison'. ] causesException: CantSuspend andSuccesfulExecutionOf: [ 
		self assert: customerBook numberOfCustomers = 1.
		self assert: (customerBook includesCustomerNamed: johnLennon) ].
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'TC 9/7/2022 19:03:10'!
test08CanNotSuspendAnAlreadySuspendedCustomer
	
	| customerBook johnLennon |
	
	johnLennon := 'John Lennon'.
	customerBook := self newCustomerBookWithCustomerNamed: johnLennon.
	customerBook suspendCustomerNamed: johnLennon.
	
	self checkThat: [ customerBook suspendCustomerNamed: johnLennon. ] causesException: CantSuspend andSuccesfulExecutionOf: [ 
		self assert: customerBook numberOfCustomers = 1.
		self assert: (customerBook includesCustomerNamed: johnLennon) ].! !


!classDefinition: #CustomerBook category: 'CodigoRepetido-Ejercicio'!
Object subclass: #CustomerBook
	instanceVariableNames: 'suspended active'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!

!CustomerBook methodsFor: 'testing' stamp: 'TC 9/7/2022 17:33:04'!
includesCustomerNamed: aName

	^(active includes: aName) or: [ suspended includes: aName ]! !

!CustomerBook methodsFor: 'testing' stamp: 'TC 9/7/2022 17:58:17'!
isEmpty
	
	^self numberOfCustomers = 0.! !


!CustomerBook methodsFor: 'initialization' stamp: 'NR 9/17/2020 07:23:04'!
initialize

	active := OrderedCollection new.
	suspended:= OrderedCollection new.! !


!CustomerBook methodsFor: 'customer management' stamp: 'TC 9/7/2022 19:31:19'!
addCustomerNamed: aName

	self causeExceptionIfNameIsEmpty: aName.
	self causeExceptionIfACustomerInBookIsNamed: aName.
	active add: aName ! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 4/3/2019 10:14:26'!
numberOfActiveCustomers
	
	^active size! !

!CustomerBook methodsFor: 'customer management' stamp: 'TC 9/7/2022 17:36:59'!
numberOfCustomers
	
	^self numberOfActiveCustomers + self numberOfSuspendedCustomers ! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 9/19/2018 17:36:09'!
numberOfSuspendedCustomers
	
	^suspended size! !

!CustomerBook methodsFor: 'customer management' stamp: 'TC 9/7/2022 18:29:49'!
removeCustomerNamed: aName 
 
	active remove: aName ifAbsent: [
		suspended remove: aName ifAbsent: [
			^NotFound signal.
		].
	].
! !

!CustomerBook methodsFor: 'customer management' stamp: 'HernanWilkinson 7/6/2011 17:52'!
signalCustomerAlreadyExists 

	self error: self class customerAlreadyExistsErrorMessage! !

!CustomerBook methodsFor: 'customer management' stamp: 'HernanWilkinson 7/6/2011 17:51'!
signalCustomerNameCannotBeEmpty 

	self error: self class customerCanNotBeEmptyErrorMessage ! !

!CustomerBook methodsFor: 'customer management' stamp: 'TC 9/7/2022 19:35:17'!
suspendCustomerNamed: aName 
	
	active remove: aName ifAbsent: [^CantSuspend signal].
	
	suspended add: aName
! !


!CustomerBook methodsFor: 'private' stamp: 'TC 9/7/2022 19:30:15'!
causeExceptionIfACustomerInBookIsNamed: aName
	
	(self includesCustomerNamed: aName) ifTrue: [ self signalCustomerAlreadyExists ].! !

!CustomerBook methodsFor: 'private' stamp: 'TC 9/7/2022 19:30:12'!
causeExceptionIfNameIsEmpty: aName
	
	aName isEmpty ifTrue: [ self signalCustomerNameCannotBeEmpty ].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerBook class' category: 'CodigoRepetido-Ejercicio'!
CustomerBook class
	instanceVariableNames: ''!

!CustomerBook class methodsFor: 'error messages' stamp: 'NR 4/11/2022 07:18:12'!
customerAlreadyExistsErrorMessage

	^'Customer already exists!!!!!!'! !

!CustomerBook class methodsFor: 'error messages' stamp: 'NR 4/11/2022 07:18:16'!
customerCanNotBeEmptyErrorMessage

	^'Customer name cannot be empty!!!!!!'! !
