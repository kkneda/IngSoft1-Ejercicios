!classDefinition: #CartTest category: 'TusLibros'!
TestCase subclass: #CartTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:08'!
test01NewCartsAreCreatedEmpty

	self assert: self createCart isEmpty! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:45'!
test02CanNotAddItemsThatDoNotBelongToStore

	| cart |
	
	cart := self createCart.
	
	self 
		should: [ cart add: self itemNotSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test03AfterAddingAnItemTheCartIsNotEmptyAnymore

	| cart |
	
	cart := self createCart.
	
	cart add: self itemSellByTheStore.
	self deny: cart isEmpty ! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test04CanNotAddNonPositiveNumberOfItems

	| cart |
	
	cart := self createCart.
	
	self 
		should: [cart add: 0 of: self itemSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidQuantityErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:45'!
test05CanNotAddMoreThanOneItemNotSellByTheStore

	| cart |
	
	cart := self createCart.
	
	self 
		should: [cart add: 2 of: self itemNotSellByTheStore  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test06CartRemembersAddedItems

	| cart |
	
	cart := self createCart.
	
	cart add: self itemSellByTheStore.
	self assert: (cart includes: self itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test07CartDoesNotHoldNotAddedItems

	| cart |
	
	cart := self createCart.
	
	self deny: (cart includes: self itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:45'!
test08CartRemembersTheNumberOfAddedItems

	| cart |
	
	cart := self createCart.
	
	cart add: 2 of: self itemSellByTheStore.
	self assert: (cart occurrencesOf: self itemSellByTheStore) = 2! !

!CartTest methodsFor: 'tests' stamp: 'TC&OLT 11/2/2022 14:03:11'!
test09AccumulatedPriceOfEmptyCartIsZero
	
	| cart |
	
	cart := self createCart.
	
	self assert: 0 equals: cart accumulatedPrice.! !

!CartTest methodsFor: 'tests' stamp: 'TC&OLT 11/2/2022 14:03:03'!
test10AccumulatedPriceOfCartWithSingleItemIsPriceOfSuchItem
	
	| cart |
	
	cart := self createCart.
	
	cart add: self itemSellByTheStore.
	
	self assert: self itemSellByTheStorePrice equals: cart accumulatedPrice.! !

!CartTest methodsFor: 'tests' stamp: 'TC&OLT 11/2/2022 14:04:12'!
test11AccumulatedPriceOfCartWithMultipleCopiesOfAnItemIsPriceForAllSuchCopies
	
	| cart |
	
	cart := self createCart.
	
	cart add: 2 of: self itemSellByTheStore.
	
	self assert: 2 * self itemSellByTheStorePrice equals: cart accumulatedPrice.! !


!CartTest methodsFor: 'support' stamp: 'HernanWilkinson 6/17/2013 17:48'!
createCart
	
	^Cart acceptingItemsOf: self defaultCatalog! !

!CartTest methodsFor: 'support' stamp: 'TC&OLT 11/2/2022 13:59:59'!
defaultCatalog
	
	^ Dictionary with: self itemSellByTheStore->self itemSellByTheStorePrice.! !

!CartTest methodsFor: 'support' stamp: 'HernanWilkinson 6/17/2013 17:44'!
itemNotSellByTheStore
	
	^'invalidBook'! !

!CartTest methodsFor: 'support' stamp: 'HernanWilkinson 6/17/2013 17:43'!
itemSellByTheStore
	
	^ 'validBook'! !

!CartTest methodsFor: 'support' stamp: 'TC&OLT 11/2/2022 13:51:48'!
itemSellByTheStorePrice
	
	^ 10*euro! !


!classDefinition: #CashierTest category: 'TusLibros'!
TestCase subclass: #CashierTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CashierTest methodsFor: 'tests' stamp: 'TC&OLT 11/3/2022 12:20:53'!
test01CheckoutOfEmptyCartResultsInError
	
	| cart salesBook creditCard accessToMerchant merchantProcessor cashier |
	
	cart := Cart acceptingItemsOf: Array new.
	
	salesBook := OrderedCollection new.
	
	creditCard:= CreditCard goodThrough: (September/1/2025).
	
	accessToMerchant := false.
	
	merchantProcessor := MerchantProcessorTestDouble with: (Dictionary with: creditCard ->[ :anAmount :aCreditCard | accessToMerchant := true. ]).
	
	cashier := Cashier recordingSalesOn: salesBook.
	
	self should: [ cashier checkoutFor: cart with: creditCard on: (November/2/2022) using: merchantProcessor. ]
	raise: Error
	withExceptionDo: [
		:anError |
		self assert: anError messageText equals: cashier emptyCartAtCheckoutErrorMessage.
		self assert: OrderedCollection new equals: salesBook.
		self deny: accessToMerchant.
	].! !

!CashierTest methodsFor: 'tests' stamp: 'TC&OLT 11/3/2022 12:15:52'!
test02CheckoutOfCartWithSingleItemReturnsPriceOfSuchItem
	
	| cart salesBook creditCard merchantProcessor cashier |
	
	cart := Cart acceptingItemsOf: (Dictionary with: 'valid book'->(10*euro)).
	cart add: 'valid book'.
	
	salesBook := OrderedCollection new.
	
	creditCard:= CreditCard goodThrough: (September/1/2025).
	
	merchantProcessor := MerchantProcessorTestDouble with: (Dictionary with: creditCard ->[ :anAmount :aCreditCard | . ]).
	
	cashier := Cashier recordingSalesOn: salesBook.
	
	self assert: (10*euro) equals: (cashier checkoutFor: cart with: creditCard on: (November/2/2022) using: merchantProcessor).! !

!CashierTest methodsFor: 'tests' stamp: 'TC&OLT 11/3/2022 12:16:14'!
test03CheckoutOfCartWithMultipleCopiesOfMultipleItemsReturnsPriceForAllCopies
	
	| cart salesBook creditCard merchantProcessor cashier |
	
	cart := Cart acceptingItemsOf: (Dictionary with: 'valid book 1'->(10*euro) with: 'valid book 2'->(15*euro)).
	cart add: 2 of: 'valid book 1'.
	cart add: 3 of: 'valid book 2'.
	
	salesBook := OrderedCollection new.
	
	creditCard:= CreditCard goodThrough: (September/1/2025).
	
	merchantProcessor := MerchantProcessorTestDouble with: (Dictionary with: creditCard->[ :anAmount :anCreditCard | . ]).
	
	cashier := Cashier recordingSalesOn: salesBook.
	
	self assert: (65*euro) equals: (cashier checkoutFor: cart with: creditCard on: (November/2/2022) using: merchantProcessor).! !

!CashierTest methodsFor: 'tests' stamp: 'TC&OLT 11/3/2022 12:16:31'!
test04SalesBooksRegistersCheckout
	
	| cart salesBook creditCard merchantProcessor cashier |
	
	cart := Cart acceptingItemsOf: (Dictionary with: 'valid book 1'->(10*euro) with: 'valid book 2'->(15*euro)).
	cart add: 2 of: 'valid book 1'.
	cart add: 3 of: 'valid book 2'.
	
	salesBook := OrderedCollection new.

	creditCard:= CreditCard goodThrough: (September/1/2025).
	
	merchantProcessor := MerchantProcessorTestDouble with: (Dictionary with: creditCard->[ :anAmount :anCreditCard | . ]).
	
	cashier := Cashier recordingSalesOn: salesBook.
	cashier checkoutFor: cart with: creditCard on: (November/2/2022) using: merchantProcessor.
	
	self assert: (OrderedCollection with: 65*euro) equals: (salesBook).! !

!CashierTest methodsFor: 'tests' stamp: 'TC&OLT 11/3/2022 12:22:33'!
test05CheckoutCannotBePerformedWhenUsingAnExpiredCreditCard
	
	| cart salesBook expiredCreditCard merchantProcessor accessToMerchant cashier |
	
	cart := Cart acceptingItemsOf: (Dictionary with: 'valid book 1'->(10*euro) with: 'valid book 2'->(15*euro)).
	cart add: 2 of: 'valid book 1'.
	cart add: 3 of: 'valid book 2'.
	
	salesBook := OrderedCollection new.
	
	expiredCreditCard:= CreditCard goodThrough: (September/1/2021).
	
	accessToMerchant := false.
	
	merchantProcessor := MerchantProcessorTestDouble with: (Dictionary with: expiredCreditCard->[ :anAmount :aCreditCard | accessToMerchant := true.]).
	
	cashier := Cashier recordingSalesOn: salesBook.
	
	self 
		should: [cashier checkoutFor: cart with: expiredCreditCard on: (November/2/2022) using: merchantProcessor.]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: cashier expiredCardErrorMessage.
			self assert: salesBook isEmpty.
			self deny: accessToMerchant.
		].
		
	! !

!CashierTest methodsFor: 'tests' stamp: 'TC&OLT 11/3/2022 12:22:49'!
test06CheckoutCannotBePerformedWithAStolenCreditCard
	
	| cart salesBook cashier stolenCreditCard merchantProcessor |
	
	cart := Cart acceptingItemsOf: (Dictionary with:'valid book'->(10*euro)).
	cart add: 'valid book'.
	
	salesBook := OrderedCollection new.
	
	cashier := Cashier recordingSalesOn: salesBook.
	
	stolenCreditCard := CreditCard goodThrough: November/3/2022.
	
	merchantProcessor := MerchantProcessorTestDouble with: (Dictionary with: stolenCreditCard->[ :anAmount :aCreditCard | cashier error: cashier stolenCardErrorMessage. ]).
	
	self should: [ cashier checkoutFor: cart with: stolenCreditCard on: (November/2/2022) using: merchantProcessor. ]
	raise: Error
	withExceptionDo: [
		:anError |
		self assert: anError messageText equals: cashier stolenCardErrorMessage.
		self assert: salesBook isEmpty.
	].! !

!CashierTest methodsFor: 'tests' stamp: 'TC&OLT 11/3/2022 12:23:02'!
test07CheckoutCannotBePerformedWithACardWithInsufficientFunds
	
	| cart salesBook cashier creditCardWithInsufficientFunds merchantProcessor |
	
	cart := Cart acceptingItemsOf: (Dictionary with:'valid book'->(10*euro)).
	cart add: 'valid book'.
	
	salesBook := OrderedCollection new.
	
	cashier := Cashier recordingSalesOn: salesBook.
	
	creditCardWithInsufficientFunds := CreditCard goodThrough: November/3/2022.
	
	merchantProcessor := MerchantProcessorTestDouble with: (Dictionary with: creditCardWithInsufficientFunds->[ :anAmount :aCreditCard | cashier error: cashier cardWithInsufficientFundsErrorMessage. ]).
	
	self should: [ cashier checkoutFor: cart with: creditCardWithInsufficientFunds on: (November/2/2022) using: merchantProcessor. ]
	raise: Error
	withExceptionDo: [
		:anError |
		self assert: anError messageText equals: cashier cardWithInsufficientFundsErrorMessage.
		self assert: salesBook isEmpty.
	].! !


!classDefinition: #CreditCardTest category: 'TusLibros'!
TestCase subclass: #CreditCardTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCardTest methodsFor: 'tests' stamp: 'TC&OLT 11/3/2022 12:26:53'!
test01CreditCardIsNotExpiredOnDateBeforeExpiration
	
	| creditCard |
	
	creditCard := CreditCard goodThrough: November/3/2022.
	
	self deny: (creditCard isExpiredOn: November/2/2022).! !

!CreditCardTest methodsFor: 'tests' stamp: 'TC&OLT 11/3/2022 12:27:12'!
test02CreditCardIsExpiredOnDatePastExpiration
	
	| creditCard |
	
	creditCard := CreditCard goodThrough: November/3/2022.
	
	self assert: (creditCard isExpiredOn: November/4/2022).! !


!classDefinition: #MerchantProcessorTestDoubleTest category: 'TusLibros'!
TestCase subclass: #MerchantProcessorTestDoubleTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!MerchantProcessorTestDoubleTest methodsFor: 'tests' stamp: 'TC&OLT 11/3/2022 12:28:01'!
test01DebitingAnyAmountFromCreditCardInDictionaryExecutesAssociatedClosure
	
	| creditCard merchantProcessor |
	
	creditCard := CreditCard goodThrough: November/3/2022.
	
	merchantProcessor := MerchantProcessorTestDouble with: (Dictionary with: creditCard->[ :anAmount :aCreditCard | ^'Success.']).
	
	self assert: 'Success.' equals: (merchantProcessor debit: 0 from: creditCard).! !

!MerchantProcessorTestDoubleTest methodsFor: 'tests' stamp: 'TC&OLT 11/3/2022 12:28:10'!
test02DebitingAnyAmountFromCreditCardNotInDictionaryCausesAnError
	
	| creditCardInDictionary creditCardNotInDictionary merchantProcessor |
	
	creditCardInDictionary := CreditCard goodThrough: November/3/2022.
	creditCardNotInDictionary := CreditCard goodThrough: November/4/2022.
	
	merchantProcessor := MerchantProcessorTestDouble with: (Dictionary with: creditCardInDictionary ->[ :anAmount :aCreditCard | ^'Success.']).
	
	self should: [ merchantProcessor debit: 0 from: creditCardNotInDictionary. ]
	raise: 	Error
	withExceptionDo: [
		:anError |
		self assert: anError messageText equals: merchantProcessor cardNotRegisteredErrorMessage.
	].! !


!classDefinition: #Cart category: 'TusLibros'!
Object subclass: #Cart
	instanceVariableNames: 'priceList items'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:45'!
invalidItemErrorMessage
	
	^'Item is not in catalog'! !

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:45'!
invalidQuantityErrorMessage
	
	^'Invalid number of items'! !


!Cart methodsFor: 'assertions' stamp: 'TC&OLT 11/2/2022 13:48:01'!
assertIsValidItem: anItem

	(priceList includesKey: anItem) ifFalse: [ self error: self invalidItemErrorMessage ]! !

!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 17:51'!
assertIsValidQuantity: aQuantity

	aQuantity strictlyPositive ifFalse: [ self error: self invalidQuantityErrorMessage ]! !


!Cart methodsFor: 'initialization' stamp: 'TC&OLT 11/2/2022 13:55:18'!
initializeAcceptingItemsOf: aPriceList

	priceList := aPriceList.
	items := OrderedCollection new.! !


!Cart methodsFor: 'queries' stamp: 'TC&OLT 11/2/2022 14:06:27'!
accumulatedPrice
	
	^items sum: [ :anItem | priceList at: anItem. ] ifEmpty: [ 0 ].! !

!Cart methodsFor: 'queries' stamp: 'HernanWilkinson 6/17/2013 17:45'!
occurrencesOf: anItem

	^items occurrencesOf: anItem  ! !


!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
includes: anItem

	^items includes: anItem ! !

!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
isEmpty
	
	^items isEmpty ! !


!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:44'!
add: anItem

	^ self add: 1 of: anItem ! !

!Cart methodsFor: 'adding' stamp: 'TC&OLT 11/2/2022 13:59:27'!
add: aQuantity of: anItem

	self assertIsValidQuantity: aQuantity.
	self assertIsValidItem: anItem.

	items add: anItem withOccurrences: aQuantity.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 17:48'!
acceptingItemsOf: aCatalog

	^self new initializeAcceptingItemsOf: aCatalog ! !


!classDefinition: #Cashier category: 'TusLibros'!
Object subclass: #Cashier
	instanceVariableNames: 'salesBook'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'initialization' stamp: 'TC&OLT 11/2/2022 13:43:48'!
initializeRecordingSalesOn: aSalesBookToRecordSalesOn
	
	salesBook := aSalesBookToRecordSalesOn.! !


!Cashier methodsFor: 'error messages' stamp: 'TC&OLT 11/3/2022 11:58:39'!
cardWithInsufficientFundsErrorMessage

	^'Cannot perform checkout with a card with insufficient funds.'.! !

!Cashier methodsFor: 'error messages' stamp: 'TC&OLT 11/2/2022 13:44:25'!
emptyCartAtCheckoutErrorMessage
	
	^'Cart cannot be empty at checkout.'.! !

!Cashier methodsFor: 'error messages' stamp: 'TC&OLT 11/3/2022 09:18:19'!
expiredCardErrorMessage

	^'Cannot perform checkout with an expired card.'.! !

!Cashier methodsFor: 'error messages' stamp: 'TC&OLT 11/3/2022 11:33:07'!
stolenCardErrorMessage

	^'Cannot perform checkout with a stolen card.'.! !


!Cashier methodsFor: 'checkout' stamp: 'TC&OLT 11/2/2022 18:40:08'!
checkoutFor: aCartToPerformCheckoutFor with: aCardToPerformCheckoutWith on: aDateToPerformCheckoutOn
	
	| cartAccumulatedPrice |
	
	
	self assertCheckoutCanBePerformedFor: aCartToPerformCheckoutFor.
	
	self  assertCheckoutCanBePerformedWith: aCardToPerformCheckoutWith on: aDateToPerformCheckoutOn .
	
	cartAccumulatedPrice:= aCartToPerformCheckoutFor accumulatedPrice.
	salesBook add: cartAccumulatedPrice.
	
	^cartAccumulatedPrice.! !

!Cashier methodsFor: 'checkout' stamp: 'TC&OLT 11/3/2022 11:49:25'!
checkoutFor: aCartToPerformCheckoutFor with: aCardToPerformCheckoutWith on: aDateToPerformCheckoutOn using: aMerchantProcessor
	
	| cartAccumulatedPrice |
	
	self assertCheckoutCanBePerformedFor: aCartToPerformCheckoutFor.
	self assertCheckoutCanBePerformedWith: aCardToPerformCheckoutWith on: aDateToPerformCheckoutOn. "Cambiar nombre para chequeo por vencimiento."
	
	cartAccumulatedPrice := aCartToPerformCheckoutFor accumulatedPrice.
	
	aMerchantProcessor debit: cartAccumulatedPrice from: aCardToPerformCheckoutWith.
	
	salesBook add: cartAccumulatedPrice.
	
	^cartAccumulatedPrice.! !


!Cashier methodsFor: 'assertions' stamp: 'TC&OLT 11/2/2022 18:37:26'!
assertCheckoutCanBePerformedFor: aCartToPerformCheckoutOn
	
	aCartToPerformCheckoutOn isEmpty ifTrue: [
		^self error: self emptyCartAtCheckoutErrorMessage.
	].! !

!Cashier methodsFor: 'assertions' stamp: 'TC&OLT 11/2/2022 19:05:15'!
assertCheckoutCanBePerformedWith: aCardToPerformCheckoutWith on: aDateToPerformCheckoutOn .
	
	(aCardToPerformCheckoutWith isExpiredOn: aDateToPerformCheckoutOn) ifTrue: [
		^self error: self expiredCardErrorMessage.
	].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: 'TusLibros'!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'instance creation' stamp: 'TC&OLT 11/2/2022 13:42:59'!
recordingSalesOn: aSalesBookToRecordSalesOn
	
	^self new initializeRecordingSalesOn: aSalesBookToRecordSalesOn.! !


!classDefinition: #CreditCard category: 'TusLibros'!
Object subclass: #CreditCard
	instanceVariableNames: 'expirationDate'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCard methodsFor: 'initialization' stamp: 'TC&OLT 11/3/2022 09:35:33'!
initializeGoodThrough: aDateOfExpiration
	
	expirationDate := aDateOfExpiration.! !


!CreditCard methodsFor: 'testing' stamp: 'TC&OLT 11/3/2022 09:35:54'!
isExpiredOn: aDateToCheckExpirationOn
	
	^expirationDate < aDateToCheckExpirationOn.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: 'TusLibros'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'instance creation' stamp: 'TC&OLT 11/3/2022 09:33:16'!
goodThrough: aDateOfExpiration
	
	^self new initializeGoodThrough: aDateOfExpiration.! !


!classDefinition: #MerchantProcessorTestDouble category: 'TusLibros'!
Object subclass: #MerchantProcessorTestDouble
	instanceVariableNames: 'debitDictionary'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!MerchantProcessorTestDouble methodsFor: 'initialization' stamp: 'TC&OLT 11/3/2022 10:57:47'!
initializeWith: aDictionaryWithClosuresForValues
	
	debitDictionary := aDictionaryWithClosuresForValues.! !


!MerchantProcessorTestDouble methodsFor: 'debiting' stamp: 'TC&OLT 11/3/2022 11:44:04'!
debit: anAmountToDebit from: aCreditCardToDebitFrom
	
	^(debitDictionary at: aCreditCardToDebitFrom ifAbsent: [ self error: self cardNotRegisteredErrorMessage. ]) value: anAmountToDebit value: aCreditCardToDebitFrom.! !


!MerchantProcessorTestDouble methodsFor: 'error messages' stamp: 'TC&OLT 11/3/2022 11:01:49'!
cardNotRegisteredErrorMessage
	
	^'Credit card has not been registered.'.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MerchantProcessorTestDouble class' category: 'TusLibros'!
MerchantProcessorTestDouble class
	instanceVariableNames: ''!

!MerchantProcessorTestDouble class methodsFor: 'instance creation' stamp: 'TC&OLT 11/3/2022 10:53:51'!
with: aDictionaryWithClosuresForValues
	
	^self new initializeWith: aDictionaryWithClosuresForValues.! !
