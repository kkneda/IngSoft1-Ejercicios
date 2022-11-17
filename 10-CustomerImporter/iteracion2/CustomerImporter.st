!classDefinition: #ImportTest category: 'CustomerImporter'!
TestCase subclass: #ImportTest
	instanceVariableNames: 'session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!ImportTest methodsFor: 'tests' stamp: 'TC 11/17/2022 14:50:29'!
test01ImportWithValidInputWorksAsExpected

	CustomerImporter valueFrom: self validImportData into: session..

	self assertNumberOfCustomersImportedIs: 2.
	self assertPepeSanchezWasImportedCorrecty.
	self assertJuanPerezWasImportedCorrectly.! !

!ImportTest methodsFor: 'tests' stamp: 'TC 11/17/2022 15:13:25'!
test02headerWithInvalidFirstCharacterRaisesError
	
	| customerImporter | 
	
	customerImporter := CustomerImporter from: self invalidImportDataWrongIDType into: session.
	
	self should: [ customerImporter value. ]
	raise: Error - MessageNotUnderstood 
	withExceptionDo: [
		:anError |
		self assert: anError messageText equals: customerImporter class invalidLineHeaderErrorDescription.
		self assertNumberOfCustomersImportedIs: 0.
	].! !

!ImportTest methodsFor: 'tests' stamp: 'TC 11/17/2022 15:13:44'!
test03emptyLineInDataCausesError
	
	| customerImporter | 
	
	customerImporter := CustomerImporter from: self emptyData into: session.
	
	self should: [ customerImporter value. ]
	raise: Error - MessageNotUnderstood 
	withExceptionDo: [
		:anError |
		self assert: anError messageText equals: customerImporter class emptyLineErrorDescription.
		self assertNumberOfCustomersImportedIs: 0.
	].! !

!ImportTest methodsFor: 'tests' stamp: 'TC 11/17/2022 15:13:54'!
test04customerLineWithMoreThanFiveFieldsInDataCausesError
	
	| customerImporter | 
	
	customerImporter := CustomerImporter from: self customerImportDataWithMoreThanFiveFields into: session.
	
	self should: [ customerImporter value. ]
	raise: Error - MessageNotUnderstood 
	withExceptionDo: [
		:anError |
		self assert: anError messageText equals: customerImporter class moreThanFiveFieldsForCustomerErrorDescription .
		self assertNumberOfCustomersImportedIs: 0.
	].! !

!ImportTest methodsFor: 'tests' stamp: 'TC 11/17/2022 15:14:15'!
test05customerLineWithLessThanFiveFieldsInDataCausesError
	
	| customerImporter | 
	
	customerImporter := CustomerImporter from: self customerImportDataWithLessThanFiveFields into: session.
	
	self should: [ customerImporter value. ]
	raise: Error - MessageNotUnderstood 
	withExceptionDo: [
		:anError |
		self assert: anError messageText equals: customerImporter class lessThanFiveFieldsForCustomerErrorDescription .
		self assertNumberOfCustomersImportedIs: 0.
	].! !

!ImportTest methodsFor: 'tests' stamp: 'TC 11/17/2022 15:14:23'!
test06addressLineWithMoreThanSixFieldsInDataCausesError
	
	| customerImporter | 
	
	customerImporter := CustomerImporter from: self addressImportDataWithMoreThanSixFields into: session.
	
	self should: [ customerImporter value. ]
	raise: Error - MessageNotUnderstood 
	withExceptionDo: [
		:anError |
		self assert: anError messageText equals: customerImporter class moreThanSixFieldsForAddressErrorDescription .
		self assertNumberOfCustomersImportedIs: 1.
	].! !

!ImportTest methodsFor: 'tests' stamp: 'TC 11/17/2022 15:14:33'!
test07addressLineWithLessThanSixFieldsInDataCausesError
	
	| customerImporter | 
	
	customerImporter := CustomerImporter from: self addressImportDataWithLessThanSixFields into: session.
	
	self should: [ customerImporter value. ]
	raise: Error - MessageNotUnderstood 
	withExceptionDo: [
		:anError |
		self assert: anError messageText equals: customerImporter class lessThanSixFieldsForAddressErrorDescription .
		self assertNumberOfCustomersImportedIs: 1.
	].! !

!ImportTest methodsFor: 'tests' stamp: 'TC 11/17/2022 15:14:42'!
test08importDataStartingWithAnAddressLineCausesError
	
	| customerImporter | 
	
	customerImporter := CustomerImporter from: self importDataStartingWithAddressLine into: session.
	
	self should: [ customerImporter value. ]
	raise: Error - MessageNotUnderstood 
	withExceptionDo: [
		:anError |
		self assert: anError messageText equals: customerImporter class addressWithNoCustomerErrorDescription.
		self assertNumberOfCustomersImportedIs: 0.
	].! !


!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:22:05'!
assertAddressOf: importedCustomer at: aStreetName hasNumber: aNumber town: aTown zipCode: aZipCode province: aProvince

	| importedAddress |

	importedAddress := importedCustomer addressAt: aStreetName ifNone: [ self fail ].
	self assert: aStreetName equals: importedAddress streetName.
	self assert: aNumber equals: importedAddress streetNumber.
	self assert: aTown equals: importedAddress town.
	self assert: aZipCode equals: importedAddress zipCode.
	self assert: aProvince equals: importedAddress province.

	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:27:57'!
assertCustomerWithIdentificationType: anIdType number: anIdNumber hasFirstName: aFirstName lastName: aLastName

	| importedCustomer |

	importedCustomer := self customerWithIdentificationType: anIdType number: anIdNumber.

	self assert: aFirstName equals: importedCustomer firstName.
	self assert: aLastName equals: importedCustomer lastName.
	self assert: anIdType equals: importedCustomer identificationType.
	self assert: anIdNumber equals: importedCustomer identificationNumber.

	^importedCustomer

	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:28:45'!
assertJuanPerezWasImportedCorrectly

	| importedCustomer |

	importedCustomer := self assertCustomerWithIdentificationType: 'C' number: '23-25666777-9' hasFirstName: 'Juan' lastName: 'Perez'.
	self assertAddressOf: importedCustomer at: 'Alem' hasNumber: 1122 town: 'CABA' zipCode: 1001 province: 'CABA'
	! !

!ImportTest methodsFor: 'assertions' stamp: 'TC&OLT 11/14/2022 18:46:41'!
assertNumberOfCustomersImportedIs: aNumberOfCustomers

	^ self assert: aNumberOfCustomers equals: (session selectAllOfType: Customer) size! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:28:05'!
assertPepeSanchezWasImportedCorrecty

	| importedCustomer |

	importedCustomer := self assertCustomerWithIdentificationType: 'D' number: '22333444' hasFirstName: 'Pepe' lastName: 'Sanchez'.
	self assertAddressOf: importedCustomer at: 'San Martin' hasNumber: 3322 town: 'Olivos' zipCode: 1636 province: 'BsAs'.
	self assertAddressOf: importedCustomer at: 'Maipu' hasNumber: 888 town: 'Florida' zipCode: 1122 province: 'Buenos Aires'.


	! !


!ImportTest methodsFor: 'setUp/tearDown' stamp: 'HAW 5/22/2022 00:27:50'!
setUp

	session := DataBaseSession for: (Array with: Address with: Customer).
	session beginTransaction.
! !

!ImportTest methodsFor: 'setUp/tearDown' stamp: 'HAW 5/22/2022 00:28:23'!
tearDown

	session commit.
	session close.
	! !


!ImportTest methodsFor: 'customer' stamp: 'HAW 5/22/2022 18:14:22'!
customerWithIdentificationType: anIdType number: anIdNumber

	^ (session
		select: [ :aCustomer | aCustomer identificationType = anIdType and: [ aCustomer identificationNumber = anIdNumber ]]
		ofType: Customer) anyOne! !


!ImportTest methodsFor: 'test data' stamp: 'TC 11/17/2022 14:28:25'!
addressImportDataWithLessThanSixFields
	
	^ ReadStream on:
'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636'.! !

!ImportTest methodsFor: 'test data' stamp: 'TC 11/17/2022 14:21:40'!
addressImportDataWithMoreThanSixFields
	
	^ ReadStream on:
'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636,BsAs,bingus'.! !

!ImportTest methodsFor: 'test data' stamp: 'TC 11/17/2022 14:13:38'!
customerImportDataWithLessThanFiveFields
	
	^ ReadStream on: 'C,Bingus,MyBeloved'.! !

!ImportTest methodsFor: 'test data' stamp: 'TC 11/17/2022 14:13:50'!
customerImportDataWithMoreThanFiveFields

	^ ReadStream on: 'C,Bingus,MyBeloved,D,1,invalidField'.! !

!ImportTest methodsFor: 'test data' stamp: 'TC&OLT 11/14/2022 19:32:41'!
emptyData

	^ ReadStream on: '
	'.! !

!ImportTest methodsFor: 'test data' stamp: 'TC 11/17/2022 14:51:41'!
importDataStartingWithAddressLine
	
	^ ReadStream on: 'A,San Martin,3322,Olivos,1636,BsAs'.! !

!ImportTest methodsFor: 'test data' stamp: 'TC 11/17/2022 14:13:21'!
invalidImportDataWrongIDType

	^ ReadStream on: 'Z'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 18:08:08'!
validImportData

	^ ReadStream on:
'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires
C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA'! !


!classDefinition: #Address category: 'CustomerImporter'!
Object subclass: #Address
	instanceVariableNames: 'id streetName streetNumber town zipCode province'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Address methodsFor: 'province' stamp: 'HAW 5/22/2022 00:19:29'!
province

	^province! !

!Address methodsFor: 'province' stamp: 'HAW 5/22/2022 00:19:29'!
province: aProvince

	province := aProvince
	! !


!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 17:55:46'!
isAt: aStreetName

	^streetName = aStreetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetName

	^streetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetName: aStreetName

	streetName := aStreetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetNumber

	^streetNumber ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetNumber: aStreetNumber

	streetNumber := aStreetNumber ! !


!Address methodsFor: 'twon' stamp: 'HAW 5/22/2022 00:19:29'!
town

	^town! !

!Address methodsFor: 'twon' stamp: 'HAW 5/22/2022 00:19:29'!
town: aTown

	town := aTown! !


!Address methodsFor: 'zip code' stamp: 'HAW 5/22/2022 00:19:29'!
zipCode

	^zipCode! !

!Address methodsFor: 'zip code' stamp: 'HAW 5/22/2022 00:19:29'!
zipCode: aZipCode

	zipCode := aZipCode! !


!classDefinition: #Customer category: 'CustomerImporter'!
Object subclass: #Customer
	instanceVariableNames: 'id firstName lastName identificationType identificationNumber addresses'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 00:19:29'!
addAddress: anAddress

	addresses add: anAddress ! !

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 17:55:17'!
addressAt: aStreetName ifNone: aNoneBlock

	^addresses detect: [ :address | address isAt: aStreetName ] ifNone: aNoneBlock ! !

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 00:19:29'!
addresses

	^ addresses! !


!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
firstName

	^firstName ! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
firstName: aName

	firstName := aName! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
lastName

	^lastName ! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
lastName: aLastName

	lastName := aLastName
! !


!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationNumber

	^identificationNumber ! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationNumber: anIdentificationNumber

	identificationNumber := anIdentificationNumber! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationType

	^identificationType ! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationType: anIdentificationType

	identificationType := anIdentificationType! !


!Customer methodsFor: 'initialization' stamp: 'HAW 5/22/2022 00:19:29'!
initialize

	super initialize.
	addresses := OrderedCollection new.! !


!classDefinition: #CustomerImporter category: 'CustomerImporter'!
Object subclass: #CustomerImporter
	instanceVariableNames: 'session readStream newCustomer record line'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerImporter methodsFor: 'initialization' stamp: 'HAW 5/22/2022 18:06:47'!
initializeFrom: aReadStream into: aSession
	session := aSession.
	readStream := aReadStream.! !


!CustomerImporter methodsFor: 'assertions' stamp: 'TC 11/17/2022 15:08:47'!
assertNewCustomerIsNotNil

	^ newCustomer ifNil: [ self error: self class addressWithNoCustomerErrorDescription. ].
	
	"Nota: esto podría resolverse más 'grácilmente' con un NullObject o algo así, pero no estaba seguro si se permitía modificar clases por fuera de CustomerImporter para esta iteración."! !

!CustomerImporter methodsFor: 'assertions' stamp: 'TC 11/17/2022 14:31:15'!
assertRecordForAddressHasSixFields

	record size > 6 ifTrue: [ self error: self class moreThanSixFieldsForAddressErrorDescription. ].
	record size < 6 ifTrue: [ self error: self class lessThanSixFieldsForAddressErrorDescription. ]! !

!CustomerImporter methodsFor: 'assertions' stamp: 'TC 11/17/2022 15:04:16'!
assertRecordForCustomerHasFiveFields

	record size > 5 ifTrue: [ self error: self class moreThanFiveFieldsForCustomerErrorDescription ].
	record size < 5 ifTrue: [ self error: self class lessThanFiveFieldsForCustomerErrorDescription ]! !

!CustomerImporter methodsFor: 'assertions' stamp: 'TC 11/17/2022 15:12:12'!
assertRecordIsNotEmpty

	^ record isEmpty ifTrue: [ self error: self class emptyLineErrorDescription. ]! !


!CustomerImporter methodsFor: 'testing' stamp: 'TC&OLT 11/14/2022 18:35:25'!
hasNextLine

	line := readStream nextLine.
	^line notNil.! !

!CustomerImporter methodsFor: 'testing' stamp: 'TC 11/17/2022 12:18:30'!
recordIsForACustomer
	
	^ record first = 'C'.
	! !

!CustomerImporter methodsFor: 'testing' stamp: 'TC&OLT 11/14/2022 18:27:56'!
recordIsForAnAddress

	^ record first = 'A'! !

!CustomerImporter methodsFor: 'testing' stamp: 'TC 11/17/2022 14:47:12'!
recordIsNeitherForCustomerNorAddress
	
	^((record first = 'C') or: [ record first = 'A'. ]) not.! !


!CustomerImporter methodsFor: 'evaluating' stamp: 'TC 11/17/2022 15:07:13'!
importAddress

	| newAddress |
			newAddress := Address new.
			self assertNewCustomerIsNotNil.
			newCustomer addAddress: newAddress.
			newAddress streetName: record second.
			newAddress streetNumber: record third asNumber .
			newAddress town: record fourth.
			newAddress zipCode: record fifth asNumber .
			newAddress province: record sixth! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'TC&OLT 11/14/2022 18:23:50'!
importCustomer

	newCustomer := Customer new.
			newCustomer firstName: record second.
			newCustomer lastName: record third.
			newCustomer identificationType: record fourth.
			newCustomer identificationNumber: record fifth.
			session persist: newCustomer! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'TC 11/17/2022 14:47:26'!
importRecord

	record := line findTokens: $,.
	
	self assertRecordIsNotEmpty.
	
	(self recordIsNeitherForCustomerNorAddress) ifTrue: [ self error: self class invalidLineHeaderErrorDescription. ].
	
	(self recordIsForACustomer) ifTrue: [		
		self assertRecordForCustomerHasFiveFields.
		self importCustomer.
	].
	
	(self recordIsForAnAddress) ifTrue: [
		self assertRecordForAddressHasSixFields.
		self importAddress.
	].! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'TC&OLT 11/14/2022 18:37:30'!
value

	[self hasNextLine ] whileTrue: [	self importRecord.	].

	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerImporter class' category: 'CustomerImporter'!
CustomerImporter class
	instanceVariableNames: ''!

!CustomerImporter class methodsFor: 'instance creation' stamp: 'HAW 5/22/2022 18:06:47'!
from: aReadStream into: aSession
	^self new initializeFrom: aReadStream into: aSession! !


!CustomerImporter class methodsFor: 'importing' stamp: 'HAW 5/22/2022 18:11:27'!
valueFrom: aReadStream into: aSession

	^(self from: aReadStream into: aSession) value! !


!CustomerImporter class methodsFor: 'error descriptions' stamp: 'TC 11/17/2022 15:03:37'!
addressWithNoCustomerErrorDescription

	^'Address has no customer.'.! !

!CustomerImporter class methodsFor: 'error descriptions' stamp: 'TC 11/17/2022 15:05:49'!
emptyLineErrorDescription

	^'Empty line.'.! !

!CustomerImporter class methodsFor: 'error descriptions' stamp: 'TC&OLT 11/14/2022 19:02:48'!
invalidLineHeaderErrorDescription

	^'Invalid line header.'.! !

!CustomerImporter class methodsFor: 'error descriptions' stamp: 'TC 11/17/2022 15:05:23'!
lessThanFiveFieldsForCustomerErrorDescription
	
	^'Less than five fields for a customer.'.! !

!CustomerImporter class methodsFor: 'error descriptions' stamp: 'TC 11/17/2022 14:29:16'!
lessThanSixFieldsForAddressErrorDescription
	
	^'Less than six fields for an address.'.! !

!CustomerImporter class methodsFor: 'error descriptions' stamp: 'TC 11/17/2022 15:05:16'!
moreThanFiveFieldsForCustomerErrorDescription

	^'More than five fields for a customer.'.! !

!CustomerImporter class methodsFor: 'error descriptions' stamp: 'TC 11/17/2022 14:26:47'!
moreThanSixFieldsForAddressErrorDescription

	^'More than six fields for an address.'.! !


!classDefinition: #DataBaseSession category: 'CustomerImporter'!
Object subclass: #DataBaseSession
	instanceVariableNames: 'configuration tables id'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 5/22/2022 00:19:29'!
beginTransaction

	! !

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 5/22/2022 19:17:36'!
commit

	(tables at: Customer ifAbsent: [#()]) do: [ :aCustomer | self persistAddressesOf: aCustomer ]
	! !


!DataBaseSession methodsFor: 'closing' stamp: 'HAW 5/22/2022 00:19:29'!
close

	! !


!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
defineIdOf: anObject

	anObject instVarNamed: 'id' put: (self newIdFor: anObject).! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
delay

	(Delay forMilliseconds: 100) wait! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 19:29:06'!
objectsOfType: aType

	^ tables at: aType ifAbsent: [ #() ]! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
persistAddressesOf: anObjectWithAddresses

	anObjectWithAddresses addresses do: [ :anAddress | self persist: anAddress ]
	! !


!DataBaseSession methodsFor: 'initialization' stamp: 'HAW 5/22/2022 00:19:29'!
initializeFor: aConfiguration

	configuration := aConfiguration.
	tables := Dictionary new.
	id := 0.! !


!DataBaseSession methodsFor: 'id' stamp: 'HAW 5/22/2022 00:19:29'!
newIdFor: anObject

	id := id + 1.
	^id! !


!DataBaseSession methodsFor: 'persistance' stamp: 'HAW 5/22/2022 00:19:29'!
persist: anObject

	| table |

	self delay.
	table := tables at: anObject class ifAbsentPut: [ Set new ].

	self defineIdOf: anObject.
	table add: anObject.

	(anObject isKindOf: Customer) ifTrue: [ self persistAddressesOf: anObject ].! !


!DataBaseSession methodsFor: 'selecting' stamp: 'HAW 5/22/2022 19:29:06'!
select: aCondition ofType: aType

	self delay.
	^(self objectsOfType: aType) select: aCondition ! !

!DataBaseSession methodsFor: 'selecting' stamp: 'HAW 5/22/2022 19:29:06'!
selectAllOfType: aType

	self delay.
	^(self objectsOfType: aType) copy ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DataBaseSession class' category: 'CustomerImporter'!
DataBaseSession class
	instanceVariableNames: ''!

!DataBaseSession class methodsFor: 'instance creation' stamp: 'HAW 5/22/2022 00:19:29'!
for: aConfiguration

	^self new initializeFor: aConfiguration! !
