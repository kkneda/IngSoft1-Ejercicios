!classDefinition: #CartTest category: 'tusLibros-Exercise'!
TestCase subclass: #CartTest
	instanceVariableNames: 'designPrinciplesBook fortniteBook'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'tusLibros-Exercise'!

!CartTest methodsFor: 'tests' stamp: 'TC&OLT 10/30/2022 17:04:18'!
test01NewCartIsEmpty
	
	| cart |
	
	cart := Cart withCatalog: Set new.
	
	self assert: cart isEmpty.! !

!CartTest methodsFor: 'tests' stamp: 'TC 10/30/2022 19:24:07'!
test02AddingBookInCartCatalogToCartResultsInCartWithSuchBook

	| cart |
	
	cart := self cartWithDesignPrinciplesBookInCatalog.
	
	cart addAmount: 1 ofBook: designPrinciplesBook.
	
	self deny: cart isEmpty.
	self assert: 1 equals: (cart amountOfBook: designPrinciplesBook).! !

!CartTest methodsFor: 'tests' stamp: 'TC 10/30/2022 19:33:06'!
test03AddingBookNotInCartCatalogToCartResultsInError

	| cart |
	
	cart := self cartWithDesignPrinciplesBookInCatalog.
	
	self should: [ cart addAmount: 1 ofBook: fortniteBook. ]
	raise: Error
	withExceptionDo: [
		:anError |
		self assert: anError messageText equals: cart class bookNotInCatalogErrorDescription.
		self assert: cart isEmpty.
	].! !

!CartTest methodsFor: 'tests' stamp: 'TC 10/30/2022 19:24:30'!
test04AddingMultipleCopiesOfBookInCartCatalogToCartResultsInCartWithMultipleCopiesOfSuchBook

	| cart |
	
	cart := self cartWithDesignPrinciplesBookInCatalog.
	
	cart addAmount: 3 ofBook: designPrinciplesBook.
	
	self deny: cart isEmpty.
	self assert: 3 equals: (cart amountOfBook: designPrinciplesBook).! !

!CartTest methodsFor: 'tests' stamp: 'TC 10/30/2022 19:23:11'!
test05AddingZeroOrLessCopiesOfBookToCartResultsInError

	| cart |
	
	cart := self cartWithDesignPrinciplesBookInCatalog.
	
	self should: [ cart addAmount: -1 ofBook: designPrinciplesBook. ]
	raise: Error
	withExceptionDo: [
		:anError |
		self assert: anError messageText equals: cart class nonPositiveAmmountErrorDescription.
		self assert: cart isEmpty.
	].! !

!CartTest methodsFor: 'tests' stamp: 'TC 10/30/2022 19:33:37'!
test06AddingMultipleBooksInCartCatalogToCartResultsInCartWithOnlySuchBooks

	| cart |
	
	cart := Cart withCatalog: (Set with: designPrinciplesBook with: fortniteBook).
	
	cart addAmount: 1 ofBook: designPrinciplesBook.
	cart addAmount: 2 ofBook: fortniteBook.	
	
	self assert: (Dictionary with: designPrinciplesBook->1 with: fortniteBook->2) equals: cart books.

! !


!CartTest methodsFor: 'carts' stamp: 'TC 10/30/2022 19:22:41'!
cartWithDesignPrinciplesBookInCatalog

	^ Cart withCatalog: (Set with: designPrinciplesBook)! !


!CartTest methodsFor: 'set up' stamp: 'TC 10/30/2022 19:32:49'!
setUp
	
	designPrinciplesBook := '978-02016336100'.
	fortniteBook := '978-0316491266'.! !


!classDefinition: #Cart category: 'tusLibros-Exercise'!
Object subclass: #Cart
	instanceVariableNames: 'catalog books'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'tusLibros-Exercise'!

!Cart methodsFor: 'testing' stamp: 'TC&OLT 10/30/2022 17:03:43'!
isEmpty
	
	^books isEmpty.! !


!Cart methodsFor: 'initialization' stamp: 'TC&OLT 10/30/2022 17:32:46'!
initializeWithCatalog: aCatalogOfBooks
	
	catalog := aCatalogOfBooks.
	books := Dictionary new.! !


!Cart methodsFor: 'adding' stamp: 'TC&OLT 10/30/2022 18:16:05'!
addAmount: anAmountOfBooks ofBook: aBookToBeAdded
	
	| previousAmountOfBook |
	
	self assertBookIsInCatalog: aBookToBeAdded.
	self assertAmountIsPositive: anAmountOfBooks .

	
	previousAmountOfBook := (books at: aBookToBeAdded ifAbsent: [ 0 ]).
	books at: aBookToBeAdded put: (previousAmountOfBook + anAmountOfBooks).! !


!Cart methodsFor: 'accessing' stamp: 'TC&OLT 10/30/2022 17:51:35'!
amountOfBook: aBookToCheckAmountOf
	
	^books at: aBookToCheckAmountOf ifAbsent: [0].! !

!Cart methodsFor: 'accessing' stamp: 'TC 10/30/2022 19:02:38'!
books

	^books copy.! !


!Cart methodsFor: 'assertions' stamp: 'TC&OLT 10/30/2022 18:16:55'!
assertAmountIsPositive: anAmountOfBooks

	(anAmountOfBooks >0) ifFalse: [ ^self error: self class nonPositiveAmmountErrorDescription. ].! !

!Cart methodsFor: 'assertions' stamp: 'TC&OLT 10/30/2022 18:14:14'!
assertBookIsInCatalog: aBook
	
	
	(catalog includes: aBook) ifFalse: [ ^self error: self class bookNotInCatalogErrorDescription. ].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'tusLibros-Exercise'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance creation' stamp: 'TC&OLT 10/30/2022 16:57:08'!
withCatalog: aCatalogOfBooks
	
	^self new initializeWithCatalog: aCatalogOfBooks.! !


!Cart class methodsFor: 'error descriptions' stamp: 'TC&OLT 10/30/2022 17:15:52'!
bookNotInCatalogErrorDescription
	
	^'Book is not in catalog.'.! !

!Cart class methodsFor: 'error descriptions' stamp: 'TC&OLT 10/30/2022 18:09:13'!
nonPositiveAmmountErrorDescription
	
	^'Ammount of books should be a positive number.'.! !
