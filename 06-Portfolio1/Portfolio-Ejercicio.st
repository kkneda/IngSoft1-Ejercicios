!classDefinition: #PortfolioTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!PortfolioTest methodsFor: 'tests' stamp: 'TC 10/17/2022 10:17:09'!
test01BalanceOfNewPortfolioIsZero
	
	| portfolio |
	
	portfolio := Portfolio new.
	
	self assert: portfolio balance equals: 0.! !

!PortfolioTest methodsFor: 'tests' stamp: 'TC 10/17/2022 06:55:37'!
test02BalanceOfPortfolioWithASingleAccountIsBalanceOfSaidAccount
	
	| account portfolio |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	portfolio := Portfolio new.
	portfolio add: account.
	
	self assert: account balance equals: portfolio balance.! !

!PortfolioTest methodsFor: 'tests' stamp: 'TC 10/17/2022 09:53:51'!
test03BalanceOfPortfolioWithAnAccountAndPortfolioIsBalanceofAccountAndPortfolio
	
	| subportfolioAccount portfolioAccount subportfolio portfolio |
	
	subportfolioAccount := ReceptiveAccount new.
	Deposit register: 100 on: subportfolioAccount.
	
	subportfolio := Portfolio new.
	subportfolio add: subportfolioAccount.
	
	portfolioAccount := ReceptiveAccount new.
	Deposit register: 50 on: portfolioAccount.
	
	portfolio := Portfolio new.
	portfolio add: portfolioAccount.
	portfolio add: subportfolio.
	
	self assert: (portfolioAccount balance + subportfolio balance) equals: portfolio balance.! !

!PortfolioTest methodsFor: 'tests' stamp: 'TC 10/17/2022 10:10:16'!
test04NewPortfolioHasNotRegisteredAnyTransactions
	
	| portfolio |
	
	portfolio := Portfolio new.
	
	self deny: (portfolio hasRegistered: (Deposit for: 100)).! !

!PortfolioTest methodsFor: 'tests' stamp: 'TC 10/17/2022 09:54:02'!
test05PortfolioHasRegisteredTransactionOfItsAccount
	
	| account deposit portfolio |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	portfolio := Portfolio new.
	portfolio add: account.
	
	self assert: (portfolio hasRegistered: deposit).! !

!PortfolioTest methodsFor: 'tests' stamp: 'TC 10/17/2022 10:06:10'!
test06PortfolioHasRegisteredAllTransactionsOfItsAccounts
	
	| subportfolioAccount portfolioAccount deposit withdrawal subportfolio portfolio |
	
	subportfolioAccount := ReceptiveAccount new.
	withdrawal := Withdraw register: 100 on: subportfolioAccount.
	
	portfolioAccount := ReceptiveAccount new.
	deposit := Deposit register: 100 on: portfolioAccount.
	
	subportfolio := Portfolio new.
	subportfolio add: subportfolioAccount.
	
	portfolio := Portfolio new.
	portfolio add: portfolioAccount.
	portfolio add: subportfolio.
	
	self assert: (portfolio hasRegistered: deposit).
	self assert: (portfolio hasRegistered: withdrawal).! !

!PortfolioTest methodsFor: 'tests' stamp: 'TC 10/17/2022 10:11:40'!
test07NewPortfolioHasNoTransactions
	
	| portfolio |
	
	portfolio := Portfolio new.
	
	self assert: portfolio transactions isEmpty.! !

!PortfolioTest methodsFor: 'tests' stamp: 'TC 10/17/2022 10:18:21'!
test08PortfolioHasTransactionOfItsAccount
	
	| account deposit portfolio portfolioTransactions |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	
	portfolio := Portfolio new.
	portfolio add: account.
	
	portfolioTransactions := portfolio transactions.
	
	self assert: (portfolioTransactions includes: deposit).
	self assert: (portfolioTransactions size) equals: 1.! !

!PortfolioTest methodsFor: 'tests' stamp: 'TC 10/17/2022 10:42:21'!
test09PortfolioHasTransactionsOfItsAccounts
	
	| subportfolioAccount portfolioAccount deposit withdrawal subportfolio portfolio portfolioTransactions |
	
	subportfolioAccount := ReceptiveAccount new.
	deposit := Deposit register: 100 on: subportfolioAccount.
	
	subportfolio := Portfolio new.
	subportfolio add: subportfolioAccount.
	
	portfolioAccount := ReceptiveAccount new.
	withdrawal := Withdraw register: 100 on: portfolioAccount.
	
	portfolio := Portfolio new.
	portfolio add: portfolioAccount.
	portfolio add: subportfolio.
	
	portfolioTransactions := portfolio transactions.
	
	self assert: (portfolioTransactions includes: deposit).
	self assert: (portfolioTransactions includes: withdrawal).
	self assert: (portfolioTransactions size) equals: 2.! !

!PortfolioTest methodsFor: 'tests' stamp: 'TC 10/17/2022 12:03:40'!
test10PortfolioCantHaveTheSameAccountTwice
	
	| account portfolio |
	
	account := ReceptiveAccount new.
	
	portfolio := Portfolio new.
	portfolio add: account.
	
	self should: [ portfolio add: account. ]
	raise: Exception
	withExceptionDo: [
		:anException |
		self assert: Portfolio accountCantBeAddedErrorDescription equals: anException messageText.
		self assert: (portfolio hasAccount: account).
		self assert: portfolio totalAccounts equals: 1.
	].! !

!PortfolioTest methodsFor: 'tests' stamp: 'TC 10/17/2022 12:20:53'!
test11PortfolioCantBeAddedToItself
	
	| portfolio |
	
	portfolio := Portfolio new.
	
	self should: [ portfolio add: portfolio. ]
	raise: Exception
	withExceptionDo: [
		:anException |
		self assert: Portfolio accountCantBeAddedErrorDescription equals: anException messageText.
		self assert: portfolio totalAccounts equals: 0.
	].! !

!PortfolioTest methodsFor: 'tests' stamp: 'TC 10/17/2022 12:26:42'!
test12PortfolioCantHaveAccountsOfSubportfolios
	
	| subportfolioAccount subportfolio portfolio |
	
	subportfolioAccount := ReceptiveAccount new.
	
	subportfolio := Portfolio new.
	subportfolio add: subportfolioAccount .
	
	portfolio := Portfolio new.
	portfolio add: subportfolio.
	
	self should: [ portfolio add: subportfolioAccount. ]
	raise: Exception
	withExceptionDo: [
		:anException |
		self assert: Portfolio accountCantBeAddedErrorDescription equals: anException messageText.
		self assert: (portfolio hasAccount: subportfolio).
		self assert: portfolio totalAccounts equals: 1.
	].! !

!PortfolioTest methodsFor: 'tests' stamp: 'TC 10/17/2022 13:21:23'!
test13PortfolioCantHaveAccountOfParentPortfolio
	
	| portfolioAccount subportfolio portfolio |
	
	portfolioAccount := ReceptiveAccount new.
	
	subportfolio := Portfolio new.
	
	portfolio := Portfolio new.
	portfolio add: portfolioAccount.
	portfolio add: subportfolio.
	
	self should: [ subportfolio add: portfolioAccount. ]
	raise: Exception
	withExceptionDo: [
		:anException |
		self assert: Portfolio accountCantBeAddedErrorDescription equals: anException messageText.
		self assert: (portfolio hasAccount: portfolioAccount).
		self assert: (portfolio hasAccount: subportfolio).
		self assert: portfolio totalAccounts equals: 2.
		self assert: subportfolio totalAccounts equals: 0.
	].! !

!PortfolioTest methodsFor: 'tests' stamp: 'TC 10/17/2022 13:24:40'!
test14PortfolioCantHavePortfolioOfParentPortfolio
	
	| bottomPortfolio middlePortfolio topPortfolio |
	
	bottomPortfolio := Portfolio new.
	
	middlePortfolio := Portfolio new.
	middlePortfolio add: bottomPortfolio.
	
	topPortfolio := Portfolio new.
	topPortfolio add: middlePortfolio.
	
	self should: [ bottomPortfolio add: middlePortfolio. ]
	raise: Exception
	withExceptionDo: [
		:anException |
		self assert: Portfolio accountCantBeAddedErrorDescription equals: anException messageText.
		self assert: (topPortfolio hasAccount: middlePortfolio).
		self assert: topPortfolio totalAccounts equals: 1.
		self assert: (middlePortfolio hasAccount: bottomPortfolio).
		self assert: middlePortfolio totalAccounts equals: 1.
		self assert: bottomPortfolio totalAccounts equals: 0.
	].! !

!PortfolioTest methodsFor: 'tests' stamp: 'TC 10/17/2022 14:00:38'!
test15PortfolioCantHavePortfolioWithAccountSharedByItsParent
	
	| parentPortfolioAccount portfolio parentPortfolio portfolioToBeAdded |
	
	parentPortfolioAccount := ReceptiveAccount new.
	
	portfolio := Portfolio new.
	
	parentPortfolio := Portfolio new.
	parentPortfolio add: parentPortfolioAccount.
	parentPortfolio add: portfolio.
	
	portfolioToBeAdded := Portfolio new.
	portfolioToBeAdded add: parentPortfolioAccount.
	
	self should: [ portfolio add: portfolioToBeAdded. ]
	raise: Exception
	withExceptionDo: [
		:anException |
		self assert: Portfolio accountCantBeAddedErrorDescription equals: anException messageText.
		self assert: portfolio totalAccounts equals: 0.
	].! !


!classDefinition: #ReceptiveAccountTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:44'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:48'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
		
	self assert: 100 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:52'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
		
	self assert: 50 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:32'!
test04WithdrawValueMustBePositive 

	| account withdrawValue |
	
	account := ReceptiveAccount new.
	withdrawValue := 50.
	
	self assert: withdrawValue equals: (Withdraw register: withdrawValue on: account) value
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:46'!
test05ReceptiveAccountKnowsRegisteredTransactions 

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	withdraw := Withdraw register: 50 on: account.
		
	self assert: (account hasRegistered: deposit).
	self assert: (account hasRegistered: withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 5/17/2021 17:29:53'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| deposit withdraw account |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 200.
	withdraw := Withdraw for: 50.
		
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered:withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:14:01'!
test07AccountKnowsItsTransactions 

	| account1 deposit1 |
	
	account1 := ReceptiveAccount new.
	
	deposit1 := Deposit register: 50 on: account1.
		
	self assert: 1 equals: account1 transactions size.
	self assert: (account1 transactions includes: deposit1).
! !


!classDefinition: #Account category: 'Portfolio-Ejercicio'!
Object subclass: #Account
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Account methodsFor: 'transactions' stamp: 'TC 10/17/2022 14:36:00'!
transactions
	
	^self subclassResponsibility.! !


!Account methodsFor: 'initalization' stamp: 'TC 10/17/2022 14:37:41'!
initialize
	
	^self subclassResponsibility.! !


!Account methodsFor: 'balance' stamp: 'TC 10/17/2022 14:38:04'!
balance
	
	^self subclassResponsibility.! !


!Account methodsFor: 'tetsing' stamp: 'TC 10/17/2022 14:37:15'!
hasRegistered: aTransactionToCheckRegistrationOf
	
	^self subclassResponsibility.! !


!classDefinition: #Portfolio category: 'Portfolio-Ejercicio'!
Account subclass: #Portfolio
	instanceVariableNames: 'accounts parents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Portfolio methodsFor: 'initialization' stamp: 'TC 10/17/2022 13:14:48'!
initialize
	
	accounts := OrderedCollection new.
	parents := OrderedCollection new.! !


!Portfolio methodsFor: 'addition' stamp: 'TC 10/17/2022 12:59:51'!
add: anAccountToBeAdded
	
	self assertAccountCanBeAdded: anAccountToBeAdded.
	
	anAccountToBeAdded addParent: self.
	accounts add: anAccountToBeAdded.! !

!Portfolio methodsFor: 'addition' stamp: 'TC 10/17/2022 13:00:30'!
addParent: aParentPortfolio
	
	parents add: aParentPortfolio.! !

!Portfolio methodsFor: 'addition' stamp: 'TC 10/17/2022 13:27:56'!
assertAccountCanBeAdded: anAccountToBeAdded.
	
	(self rootPortfoliosContain: anAccountToBeAdded) ifTrue:  [^self error: Portfolio accountCantBeAddedErrorDescription.].! !


!Portfolio methodsFor: 'balance' stamp: 'TC 10/17/2022 10:49:46'!
balance
	
	^accounts sum: [ 
		:anAccount |
		anAccount balance.
	] 
	ifEmpty: [0.].! !


!Portfolio methodsFor: 'transactions' stamp: 'TC 10/17/2022 10:07:35'!
hasRegistered: aTransactionToCheckRegistrationOf
	
	^accounts anySatisfy: [
		:anAccount |
		anAccount hasRegistered: aTransactionToCheckRegistrationOf.
	].! !

!Portfolio methodsFor: 'transactions' stamp: 'TC 10/17/2022 10:44:03'!
transactions
	
	| transactions |
	
	transactions := OrderedCollection new.
	
	accounts do: [
		:anAccount |
		transactions addAllLast: (anAccount transactions).
	].
	
	^transactions.! !


!Portfolio methodsFor: 'testing' stamp: 'TC 10/17/2022 14:00:58'!
contains: anAccountToCheckPresenceOf
	
	^self = anAccountToCheckPresenceOf or: [
		accounts anySatisfy: [
			:anAccount |
			(anAccount contains: anAccountToCheckPresenceOf) or: [
				anAccountToCheckPresenceOf contains: anAccount.
			].
		].
	].! !

!Portfolio methodsFor: 'testing' stamp: 'TC 10/17/2022 12:00:43'!
hasAccount: anAccountToCheckPresenceOf
	
	^accounts includes: anAccountToCheckPresenceOf.! !

!Portfolio methodsFor: 'testing' stamp: 'TC 10/17/2022 13:05:23'!
rootPortfoliosContain: anAccountToCheckPresenceOf
	
	| rootPortfolios |
	
	rootPortfolios := self rootPortfolios.
	
	^rootPortfolios anySatisfy: [
		:aRootPortfolio |
		aRootPortfolio contains: anAccountToCheckPresenceOf.
	].! !

!Portfolio methodsFor: 'testing' stamp: 'TC 10/17/2022 11:59:26'!
totalAccounts
	
	^accounts size.! !


!Portfolio methodsFor: 'hierarchy traversal' stamp: 'TC 10/17/2022 13:31:09'!
rootPortfolios
	
	| rootPortfolios |
	
	rootPortfolios := Set new.
	"Pueden haber varios parents con el mismo root portfolio; para evitar repeticiones y procesamiento innecesario se usa un Set, que no cuenta repetidos."
	
	(parents isEmpty)
		ifTrue: [rootPortfolios add: self.]
		ifFalse: [
			parents do: [
				:aParentPortfolio |
				rootPortfolios addAll: aParentPortfolio rootPortfolios.
			]
		].
	
	^rootPortfolios.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: 'Portfolio-Ejercicio'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'error descriptions' stamp: 'TC 10/17/2022 11:57:59'!
accountCantBeAddedErrorDescription
	
	^'Cannot add the same account twice to a portfolio.'.! !


!classDefinition: #ReceptiveAccount category: 'Portfolio-Ejercicio'!
Account subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'NR 10/17/2019 15:06:56'!
initialize

	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
transactions 

	^ transactions copy! !


!ReceptiveAccount methodsFor: 'balance' stamp: 'TC 10/17/2022 06:12:58'!
balance

	| balance |
	
	balance := 0.
	
	transactions do: [ 
		:aTransaction | 
		balance := aTransaction impactOn: balance.
	].
	
	^balance.! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'TC 10/17/2022 13:06:22'!
contains: anAccount

	^self = anAccount.
! !

!ReceptiveAccount methodsFor: 'testing' stamp: 'TC 10/17/2022 14:36:46'!
hasRegistered: aTransactionToCheckRegistrationOf

	^ transactions includes: aTransactionToCheckRegistrationOf 
! !


!ReceptiveAccount methodsFor: 'addition' stamp: 'TC 10/17/2022 13:00:47'!
addParent: aParentPortfolio
	
	"Do nothing."! !


!classDefinition: #AccountTransaction category: 'Portfolio-Ejercicio'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!AccountTransaction methodsFor: 'value' stamp: 'HernanWilkinson 9/12/2011 12:25'!
value 

	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: 'Portfolio-Ejercicio'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'NR 10/17/2019 03:22:00'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #Deposit category: 'Portfolio-Ejercicio'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Deposit methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:45'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:38'!
value

	^ value! !


!Deposit methodsFor: 'impact on' stamp: 'TC 10/17/2022 06:14:29'!
impactOn: aBalance
	
	^aBalance + value.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: 'Portfolio-Ejercicio'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Withdraw category: 'Portfolio-Ejercicio'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Withdraw methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:46'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:33'!
value

	^ value! !


!Withdraw methodsFor: 'impact on' stamp: 'TC 10/17/2022 06:14:35'!
impactOn: aBalance
	
	^aBalance - value.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: 'Portfolio-Ejercicio'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !
