!classDefinition: #CustomerTest category: 'CustomerImporter'!
TestCase subclass: #CustomerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerTest methodsFor: 'tests' stamp: 'TC&OLT 11/14/2022 14:37:04'!
test01SearchingForAddressWithInvalidNameExecutesFailureBlock
	
	| address customer blockWasExecuted |
	
	address := Address new.
	address streetName: 'valid street name'.
	
	customer := Customer new.
	customer addAddress: address.
	
	blockWasExecuted := false.
	
	customer addressAt: 'invalid street name' ifNone: [ blockWasExecuted := true. ].
	
	self assert: blockWasExecuted.! !


!classDefinition: #ImportTest category: 'CustomerImporter'!
TestCase subclass: #ImportTest
	instanceVariableNames: 'session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!ImportTest methodsFor: 'set up' stamp: 'TC 11/14/2022 10:00:50'!
setUp

	^ session := DataBaseSession for: (Array with: Address with: Customer)! !


!ImportTest methodsFor: 'tear down' stamp: 'TC 11/14/2022 10:01:22'!
tearDown

	^ session close! !


!ImportTest methodsFor: 'streams' stamp: 'olt 11/14/2022 16:08:21'!
streamWithCustomersOctavio

	^ ReadStream on: 
	'C,Octavio,LaTessa,D,39374052'! !

!ImportTest methodsFor: 'streams' stamp: 'TC 11/14/2022 11:56:43'!
streamWithCustomersPepeAndJuan

	^ ReadStream on: 
	'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires
C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA'! !

!ImportTest methodsFor: 'streams' stamp: 'olt 11/14/2022 16:23:36'!
streamWithNoCustomers

	^ ReadStream on: 
	''! !


!ImportTest methodsFor: 'session querying' stamp: 'TC 11/14/2022 12:15:03'!
getACostumerWithIDType: anIdentificationType andIDNumber: anIdentificationNumber 

	^ (session select: [ :aCustomer | (aCustomer identificationType = anIdentificationType) and: [ aCustomer identificationNumber = anIdentificationNumber. ]. ] ofType: Customer) anyOne! !

!ImportTest methodsFor: 'session querying' stamp: 'TC 11/14/2022 12:23:21'!
getAdressAtStreet: aStreetName forCustomer: aCustomer

	^ aCustomer addressAt: aStreetName ifNone: [ self fail. ]! !

!ImportTest methodsFor: 'session querying' stamp: 'TC&OLT 11/14/2022 13:37:58'!
getCustomerWithIDtype: anIDType andIDNumber: anIDNumber 
andAssertItsFirstNameIs: aFirstName lastNameIs: aLastName andNumberOfAddressesIs: aNumberOfAddresses
	
	"Tener este método no parece muy buena idea, mezcla una query con una aserción."
	
	| customer |
	
	customer := self getACostumerWithIDType: anIDType andIDNumber: anIDNumber.
	
	self assertCustomer: customer hasFirstName: aFirstName andLastName: aLastName withNumberOfAddresses: aNumberOfAddresses.
	
	^customer.! !


!ImportTest methodsFor: 'assertions' stamp: 'TC 11/14/2022 12:28:58'!
assertAddress: addressOfJuan hasStreetNumber: aStreetNumber inTown: aTown withZipCode: aZipCode inProvince: aProvince    

	self assert: aStreetNumber equals: addressOfJuan streetNumber.
	self assert: aTown equals: addressOfJuan town.
	self assert: aZipCode equals: addressOfJuan zipCode.
	self assert: aProvince equals: addressOfJuan province! !

!ImportTest methodsFor: 'assertions' stamp: 'TC 11/14/2022 12:49:37'!
assertAddressAtStreet: aStreetName forCustomer: aCustomer hasStreetNumber: aStreetNumber IsInTown: aTown inProvince: aProvince withZipCode: aZipCode

	| address |

	address := self getAdressAtStreet: aStreetName forCustomer: aCustomer.
	
	self assertAddress: address hasStreetNumber: aStreetNumber inTown: aTown withZipCode: aZipCode inProvince: aProvince.! !

!ImportTest methodsFor: 'assertions' stamp: 'TC&OLT 11/14/2022 13:36:32'!
assertCustomer: aCustomer hasFirstName: aFirstName andLastName: aLastName withNumberOfAddresses: aNumberOfAddresses
	
	self assert: aFirstName equals: aCustomer firstName.
	self assert: aLastName equals: aCustomer lastName.
	self assert: aNumberOfAddresses equals: aCustomer numberOfAddresses.! !

!ImportTest methodsFor: 'assertions' stamp: 'TC&OLT 11/14/2022 13:37:47'!
assertCustomerJuanIsImportedCorrectly
	
	| customerJuan |
	
	customerJuan := self getCustomerWithIDtype: 'C' andIDNumber: '23-25666777-9' andAssertItsFirstNameIs: 'Juan' lastNameIs: 'Perez' andNumberOfAddressesIs: 1.
	
	self assertAddressAtStreet: 'Alem' forCustomer: customerJuan hasStreetNumber: 1122 IsInTown: 'CABA' inProvince: 'CABA' withZipCode: 1001.! !

!ImportTest methodsFor: 'assertions' stamp: 'olt 11/14/2022 16:22:57'!
assertCustomerOctavioIsImportedCorrectly
	
	| customerOctavio |
	
	customerOctavio := self getCustomerWithIDtype: 'D' andIDNumber: '39374052' andAssertItsFirstNameIs: 'Octavio' lastNameIs: 'LaTessa' andNumberOfAddressesIs: 0.
	
	self assertNoAddressesForCustomer: customerOctavio.! !

!ImportTest methodsFor: 'assertions' stamp: 'TC&OLT 11/14/2022 13:37:47'!
assertCustomerPepeIsImportedCorrectly
	
	| customerPepe |
	
	customerPepe := self getCustomerWithIDtype: 'D' andIDNumber: '22333444' andAssertItsFirstNameIs: 'Pepe' lastNameIs: 'Sanchez' andNumberOfAddressesIs: 2.
	
	self assertAddressAtStreet: 'San Martin' forCustomer: customerPepe hasStreetNumber: 3322 IsInTown: 'Olivos' inProvince: 'BsAs' withZipCode: 1636.
	
	self assertAddressAtStreet: 'Maipu' forCustomer: customerPepe hasStreetNumber: 888 IsInTown: 'Florida' inProvince: 'Buenos Aires' withZipCode: 1122.! !

!ImportTest methodsFor: 'assertions' stamp: 'TC&OLT 11/14/2022 14:11:42'!
assertNoAddressesForCustomer: aCustomer
	
	! !

!ImportTest methodsFor: 'assertions' stamp: 'TC&OLT 11/14/2022 14:12:19'!
assertNumberOfImportedCustomersIs: aNumberOfCustomers

	^ self assert: aNumberOfCustomers equals: (session selectAllOfType: Customer) size! !


!ImportTest methodsFor: 'customer importing' stamp: 'TC&OLT 11/14/2022 14:01:27'!
importCustomers: aReadStream
	(CustomerImporter for: session with: aReadStream) import! !


!ImportTest methodsFor: 'tests' stamp: 'TC&OLT 11/14/2022 14:07:21'!
test01ImportingTwoCustomersWithAddressesResultsInTheirPersistenceInTheSession
	
	self importCustomers: self streamWithCustomersPepeAndJuan.
	
	self assertNumberOfImportedCustomersIs: 2.
	
	self assertCustomerPepeIsImportedCorrectly.
	
	self assertCustomerJuanIsImportedCorrectly.! !

!ImportTest methodsFor: 'tests' stamp: 'olt 11/14/2022 16:07:32'!
test02ImportingACustomerWithNoAddressesResultsInItsPersistenceInTheSession
	
	self importCustomers: self streamWithCustomersOctavio.
	
	self assertNumberOfImportedCustomersIs: 1.
	
	self assertCustomerOctavioIsImportedCorrectly.
	! !

!ImportTest methodsFor: 'tests' stamp: 'olt 11/14/2022 16:24:44'!
test03ImportingNoCustomersDoesNotChangeNumberOfImportedCustomers
	
	self importCustomers: self streamWithNoCustomers .
	
	self assertNumberOfImportedCustomersIs: 0.

	! !


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


!Address methodsFor: 'street' stamp: 'TC 11/14/2022 10:38:50'!
isAt: aStreetName 
	
	^streetName = aStreetName.! !

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

!Customer methodsFor: 'addresses' stamp: 'TC&OLT 11/14/2022 14:28:30'!
addressAt: aStreetName ifNone: aNoneBlock
	
	"TODO: Un test que llegue al aNoneBlock (que no se ecnuentre la dirección)."
	^addresses detect: [ :anAddress | anAddress isAt: aStreetName. ] ifNone: aNoneBlock.! !

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 00:19:29'!
addresses

	^ addresses! !

!Customer methodsFor: 'addresses' stamp: 'TC 11/14/2022 10:17:30'!
numberOfAddresses
	
	^addresses size.! !


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
	instanceVariableNames: 'session readStream'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerImporter methodsFor: 'initialization' stamp: 'TC&OLT 11/14/2022 14:01:27'!
initializeFor: aSession with: aReadStream
	session := aSession.
	readStream := aReadStream.! !


!CustomerImporter methodsFor: 'evaluating' stamp: 'TC&OLT 11/14/2022 14:01:27'!
import

	| newCustomer line |
	
	session beginTransaction.
	line := readStream nextLine.
	[ line notNil ] whileTrue: [
		(line beginsWith: 'C') ifTrue: [ | customerData |
			customerData := line findTokens: $,.
			newCustomer := Customer new.
			newCustomer firstName: customerData second.
			newCustomer lastName: customerData third.
			newCustomer identificationType: customerData fourth.
			newCustomer identificationNumber: customerData fifth.
			session persist: newCustomer ].

		(line beginsWith: 'A') ifTrue: [ | addressData newAddress |
			addressData := line findTokens: $,.
			newAddress := Address new.
			newCustomer addAddress: newAddress.
			newAddress streetName: addressData second.
			newAddress streetNumber: addressData third asNumber .
			newAddress town: addressData fourth.
			newAddress zipCode: addressData fifth asNumber .
			newAddress province: addressData sixth ].

		line := readStream nextLine. ].
	session commit.
readStream close! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerImporter class' category: 'CustomerImporter'!
CustomerImporter class
	instanceVariableNames: ''!

!CustomerImporter class methodsFor: 'instance creation' stamp: 'TC&OLT 11/14/2022 14:01:27'!
for: aSession with: aReadStream
	^self new initializeFor: aSession with: aReadStream! !


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
