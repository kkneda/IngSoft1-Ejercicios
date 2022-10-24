!classDefinition: #PortfolioTest category: 'Portfolio-Solucion'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:16:26'!
test01BalanceOfPortfolioWithoutAccountsIsZero

	self assert: 0 equals: Portfolio new balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'NR 5/27/2021 17:36:04'!
test02BalanceOfPortfolioWithAccountsIsSumOfAccountsBalance

	| account portfolio |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	portfolio := Portfolio with: account.
	
	self assert: account balance equals: portfolio balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:23:25'!
test03BalanceOfPortfolioIsCalculatedRecursivelyOnPortfolios

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortofolio |
	
	simplePortfolioAccount := ReceptiveAccount new.
	Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	Withdraw register: 50 on: composedPortfolioAccount.
	composedPortofolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	self assert: (composedPortfolioAccount balance + simplePortfolio balance) equals: composedPortofolio balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:43:15'!
test04PortfolioWithoutAccountsHasNoRegisteredTransaction

	self deny: (Portfolio new hasRegistered: (Deposit for: 100))! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:43:11'!
test05PortfolioHasRegisteredItsAccountsTransactions

	| account portfolio deposit |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	portfolio := Portfolio with: account.
	
	self assert: (portfolio hasRegistered: deposit)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:06'!
test06PortfolioLooksForRegisteredTransactionsRecursively

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortfolio composedPortfolioAccountWithdraw simplePortfolioAccountDeposit |
	
	simplePortfolioAccount := ReceptiveAccount new.
	simplePortfolioAccountDeposit := Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	composedPortfolioAccountWithdraw := Withdraw register: 50 on: composedPortfolioAccount.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	self assert: (composedPortfolio hasRegistered: simplePortfolioAccountDeposit).
	self assert: (composedPortfolio hasRegistered: composedPortfolioAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:10'!
test07PortfolioHasNoTransactionWhenHasNoAccounts

	self assert: Portfolio new transactions isEmpty! !

!PortfolioTest methodsFor: 'tests' stamp: 'NR 6/22/2020 07:31:19'!
test08PortfolioTransactionsIncludesAllItsAccountsTransactions

	| account portfolio accountDeposit anotherAccount portfolioTransactions anotherAccountWithdraw |
	
	account := ReceptiveAccount new.
	accountDeposit := Deposit register: 100 on: account.
	anotherAccount := ReceptiveAccount new.
	anotherAccountWithdraw := Withdraw register: 100 on: account.
	portfolio := Portfolio with: account.
	
	portfolioTransactions := portfolio transactions.
	
	self assert: 2 equals: portfolioTransactions size.
	self assert: (portfolioTransactions includes: accountDeposit).
	self assert: (portfolioTransactions includes: anotherAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:20'!
test09PortfolioTransactionsAreCalculatedRecursively

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortfolio composedPortfolioAccountWithdraw simplePortfolioAccountDeposit composedPortfolioTransactions |
	
	simplePortfolioAccount := ReceptiveAccount new.
	simplePortfolioAccountDeposit := Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	composedPortfolioAccountWithdraw := Withdraw register: 50 on: composedPortfolioAccount.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	composedPortfolioTransactions := composedPortfolio transactions.
	self assert: 2 equals: composedPortfolioTransactions size.
	self assert: (composedPortfolioTransactions includes: simplePortfolioAccountDeposit).
	self assert: (composedPortfolioTransactions includes: composedPortfolioAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:24'!
test10PortfolioCanNotIncludeTheSameAccountMoreThanOnce

	| account portfolio |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio with: account.
	
	self 
		should: [ portfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: portfolio accountsSize.
			self assert: (portfolio accountsIncludes: account) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:28'!
test11PortfolioCanNotIncludeAccountOfItsPortfolios

	| account simplePortfolio composedPortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio with: account.
	composedPortfolio := Portfolio with: simplePortfolio.
	
	self 
		should: [ composedPortfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: composedPortfolio accountsSize.
			self assert: (composedPortfolio accountsIncludes: simplePortfolio) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:32'!
test12PortfolioCanNotIncludeItself

	| account simplePortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio with: account.
	
	self 
		should: [ simplePortfolio add: simplePortfolio ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: simplePortfolio accountsSize.
			self assert: (simplePortfolio accountsIncludes: account) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 12:01:51'!
test13ComposedPortfolioCanNotHaveParentPortfolioAccount

	| account simplePortfolio composedPortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio new.
	composedPortfolio := Portfolio with: simplePortfolio.
	composedPortfolio add: account.
	
	self 
		should: [ simplePortfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: simplePortfolio accountsIsEmpty ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 12:12:16'!
test14ComposedPortfolioCanNotHaveAccountOfAnyRootParentRecursively

	| account leftParentPortfolio leftRootParentPortfolio portfolio rightParentPortfolio rightRootParentPortfolio |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio new.
	leftParentPortfolio := Portfolio with: portfolio .
	leftRootParentPortfolio := Portfolio with: leftParentPortfolio.
	leftRootParentPortfolio add: account.
	
	rightParentPortfolio := Portfolio with: portfolio .
	rightRootParentPortfolio := Portfolio with: rightParentPortfolio.
	rightRootParentPortfolio add: account.

	self 
		should: [ portfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: portfolio accountsIsEmpty ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/29/2019 16:31:18'!
test15PortfolioCanNotIncludeAnyOfTheComposedAccountOfPortfolioToAdd

	| portfolioToAdd portfolioToModify rootPortfolio sharedAccount |
	
	sharedAccount := ReceptiveAccount new.
	portfolioToModify := Portfolio new.
	rootPortfolio := Portfolio with: sharedAccount with: portfolioToModify.
	portfolioToAdd := Portfolio with: sharedAccount.
	
	self 
		should: [ portfolioToModify add: portfolioToAdd ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError | 
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: portfolioToModify accountsIsEmpty ]! !


!classDefinition: #ReceptiveAccountTest category: 'Portfolio-Solucion'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:19:48'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:19:54'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
		
	self assert: 100 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:02'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
		
	self assert: 50 equals: account balance .
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

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:54'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 100.
	withdraw := Withdraw for: 50.
		
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered:withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:21:24'!
test07AccountKnowsItsTransactions 

	| account1 deposit1 |
	
	account1 := ReceptiveAccount new.
	
	deposit1 := Deposit register: 100 on: account1.
		
	self assert: 1 equals: account1 transactions size .
	self assert: (account1 transactions includes: deposit1).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'TC&OLT 10/24/2022 11:39:52'!
test08EmptyAccountSummaryIsBalance
	
	| account |
	
	account := ReceptiveAccount new.
	
	self assert: account accountSummary equals: (OrderedCollection with: 'Balance = 0').! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'TC&OLT 10/24/2022 11:41:50'!
test09AccountWithSingleDepositSummaryIsDepositWithBalance
	
	| account |
	
	account := ReceptiveAccount new.
	
	Deposit register: 100 on: account.
	
	self assert: account accountSummary equals: (OrderedCollection with: 'Depósito por 100.' with: 'Balance = 100').! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'TC&OLT 10/24/2022 11:42:46'!
test10AccountWithDepositandWithdrawSummaryIsDepositAndWithdrawWithBalance
	
	| account |
	
	account := ReceptiveAccount new.
	
	Deposit register: 100 on: account.
	Withdraw register: 100 on: account.
	
	self assert: account accountSummary equals: (OrderedCollection with: 'Depósito por 100.' with: 'Extracción por 100.' with: 'Balance = 0').! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'TC&OLT 10/24/2022 12:00:51'!
test11AccountsWithTransferSummaryHasTransfers
	
	| sourceAccount destinationAccount|
	
	sourceAccount := ReceptiveAccount new.
	destinationAccount := ReceptiveAccount new.
		
	Deposit register: 100 on: sourceAccount.
	Withdraw register: 50 on: sourceAccount.
	
	Transfer register: 100 from: sourceAccount to: destinationAccount.
	
	self assert: sourceAccount accountSummary equals: (OrderedCollection with: 'Depósito por 100.' with: 'Extracción por 50.' with: 'Salida por transferencia de 100.' with: 'Balance = -50').
	self assert: destinationAccount accountSummary equals: (OrderedCollection with: 'Entrada por transferencia de 100.' with: 'Balance = 100').! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'TC&OLT 10/24/2022 16:29:45'!
test12AccountsWithZeroTransfersHaveTransferNetZero
	
	| account |
	
	account := ReceptiveAccount new.
	
	self assert: account transferNet equals: 0.! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'TC&OLT 10/24/2022 13:57:12'!
test13AccountsWithOneTransfersReflectsOnTransferNet
	
	| sourceAccount destinationAccount|
	
	sourceAccount := ReceptiveAccount new.
	destinationAccount := ReceptiveAccount new.
	
	Transfer register: 100 from: sourceAccount to: destinationAccount.
	
		
	self assert: sourceAccount transferNet equals: -100.
	self assert: destinationAccount transferNet equals: 100.! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'TC&OLT 10/24/2022 14:13:10'!
test14AccountsWithMultipleTransfersReflectsOnTransferNet
	
	| sourceAccount destinationAccount|
	
	sourceAccount := ReceptiveAccount new.
	destinationAccount := ReceptiveAccount new.
	
	Transfer register: 100 from: sourceAccount to: destinationAccount.
	Transfer register: 200 from: sourceAccount to: destinationAccount.
		
	self assert: sourceAccount transferNet equals: -300.
	self assert: destinationAccount transferNet equals: 300.! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'TC&OLT 10/24/2022 14:13:45'!
test15AccountsWithMultipleTransactionsReflectsOnTransferNet
	
	| sourceAccount destinationAccount|
	
	sourceAccount := ReceptiveAccount new.
	destinationAccount := ReceptiveAccount new.
	
	Deposit register: 100 on: sourceAccount.
	Withdraw register: 50 on: sourceAccount.
	
	Transfer register: 100 from: sourceAccount to: destinationAccount.
	Transfer register: 200 from: sourceAccount to: destinationAccount.
		
	self assert: sourceAccount transferNet equals: -300.
	self assert: destinationAccount transferNet equals: 300.! !


!classDefinition: #SummaryVisitorTest category: 'Portfolio-Solucion'!
TestCase subclass: #SummaryVisitorTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!SummaryVisitorTest methodsFor: 'tests' stamp: 'TC&OLT 10/24/2022 15:21:32'!
test01EmptyAccountSummaryIsBalance
	
	| account summaryVisitor |
	
	account := ReceptiveAccount new.
	summaryVisitor := SummaryVisitor for: account.
	
	self assert: (OrderedCollection with: 'Balance = 0') equals: summaryVisitor result.! !

!SummaryVisitorTest methodsFor: 'tests' stamp: 'TC&OLT 10/24/2022 15:21:09'!
test02AccountWithSingleDepositSummaryIsDepositWithBalance
	
	| account summaryVisitor |
	
	account := ReceptiveAccount new.
	
	Deposit register: 100 on: account.
	
	summaryVisitor := SummaryVisitor for: account.
	
	self assert: (OrderedCollection with: 'Depósito por 100.' with: 'Balance = 100') equals: summaryVisitor result.! !

!SummaryVisitorTest methodsFor: 'tests' stamp: 'TC&OLT 10/24/2022 15:28:01'!
test03AccountWithDepositandWithdrawSummaryIsDepositAndWithdrawWithBalance
	
	| account summaryVisitor |
	
	account := ReceptiveAccount new.
	
	Deposit register: 100 on: account.
	Withdraw register: 100 on: account.
	
	summaryVisitor := SummaryVisitor for: account.
	
	self assert: (OrderedCollection with: 'Depósito por 100.' with: 'Extracción por 100.' with: 'Balance = 0') equals: summaryVisitor result.! !

!SummaryVisitorTest methodsFor: 'tests' stamp: 'TC&OLT 10/24/2022 16:26:20'!
test04AccountsWithTransferSummaryHasTransfers
	
	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortfolio summaryVisitor |
	
	simplePortfolioAccount := ReceptiveAccount new.
	Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	Withdraw register: 50 on: composedPortfolioAccount.
	Transfer register: 50 from: simplePortfolioAccount to: composedPortfolioAccount.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	summaryVisitor := SummaryVisitor for: composedPortfolio.
	
	self assert: (OrderedCollection with: 'Depósito por 100.' with: 'Salida por transferencia de 50.' with: 'Extracción por 50.' with: 'Entrada por transferencia de 50.' with: 'Balance = 50') equals: summaryVisitor result.! !


!classDefinition: #TransferNetVisitorTest category: 'Portfolio-Solucion'!
TestCase subclass: #TransferNetVisitorTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferNetVisitorTest methodsFor: 'tests' stamp: 'TC&OLT 10/24/2022 16:31:48'!
test01AccountsWithZeroTransfersHaveTransferNetZero
	
	| account transferNetVisitor |
	
	account := ReceptiveAccount new.
	
	transferNetVisitor := TransferNetVisitor for: account.
	
	self assert: 0 equals: transferNetVisitor result.! !

!TransferNetVisitorTest methodsFor: 'tests' stamp: 'TC&OLT 10/24/2022 16:40:52'!
test02SingleTransferBetweenAccountsReflectsOnTransferNet
	
	| sourceAccount destinationAccount transferNetVisitorSourceAccount transferNetVisitorDestinationAccount |
	
	sourceAccount := ReceptiveAccount new.
	destinationAccount := ReceptiveAccount new.
	
	Transfer register: 100 from: sourceAccount to: destinationAccount.
	
	transferNetVisitorSourceAccount := TransferNetVisitor for: sourceAccount.
	
	transferNetVisitorDestinationAccount := TransferNetVisitor for: destinationAccount.
	
	self assert: -100 equals: transferNetVisitorSourceAccount result.
	self assert: 100 equals: transferNetVisitorDestinationAccount result.! !


!classDefinition: #TransferTest category: 'Portfolio-Solucion'!
TestCase subclass: #TransferTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferTest methodsFor: 'tests' stamp: 'TC&OLT 10/24/2022 10:29:05'!
test1SingleTransferReflectsOnAccountBalance
	
	| sourceAccount destinationAccount |
	
	sourceAccount := ReceptiveAccount new.
	
	destinationAccount := ReceptiveAccount new.
	
	Transfer register: 100 from: sourceAccount to: destinationAccount.
	
	self assert: sourceAccount balance equals: -100.
	self assert: destinationAccount balance equals: 100.! !

!TransferTest methodsFor: 'tests' stamp: 'TC&OLT 10/24/2022 10:28:57'!
test2MultipleTransfersReflectOnAccountBalance
	
	| sourceAccount destinationAccount |
	
	sourceAccount := ReceptiveAccount new.
	
	destinationAccount := ReceptiveAccount new.
	
	Transfer register: 100 from: sourceAccount to: destinationAccount.
	
	Transfer register: 50 from: sourceAccount to: destinationAccount.
	
	self assert: sourceAccount balance equals: -150.
	self assert: destinationAccount balance equals: 150.! !

!TransferTest methodsFor: 'tests' stamp: 'TC&OLT 10/24/2022 10:28:00'!
test3TransferLegsAreRegisteredOnAccount
	
	| sourceAccount destinationAccount transfer |
	
	sourceAccount := ReceptiveAccount new.
	
	destinationAccount := ReceptiveAccount new.
	
	transfer := Transfer register: 100 from: sourceAccount to: destinationAccount.
	
	self assert: (sourceAccount hasRegistered: transfer withdrawLeg).
	self assert: (destinationAccount hasRegistered: transfer depositLeg).! !

!TransferTest methodsFor: 'tests' stamp: 'TC&OLT 10/24/2022 11:27:44'!
test4TransferLegsCanNavigateBackToTransfer
	
	| sourceAccount destinationAccount transfer |
	
	sourceAccount := ReceptiveAccount new.
	
	destinationAccount := ReceptiveAccount new.
	
	transfer := Transfer register: 100 from: sourceAccount to: destinationAccount.
	
	self assert: (transfer withdrawLeg transferRoot) equals: transfer.
	self assert: (transfer depositLeg transferRoot) equals: transfer.
	
	"Podríamos chequear con un test5 que el valor no sea redundante (algo como que los objetos a los que refieren los colaboradores internos de un transfer y sus patas sean distintos), pero no sería un test funcional y entendemos que no es la idea del ejercicio."! !


!classDefinition: #Account category: 'Portfolio-Solucion'!
Object subclass: #Account
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Account methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:23:47'!
hasRegistered: aTransaction

	self subclassResponsibility ! !

!Account methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:24:25'!
isComposedBy: anAccount

	self subclassResponsibility ! !


!Account methodsFor: 'balance' stamp: 'HAW 5/25/2019 12:23:40'!
balance

	self subclassResponsibility ! !


!Account methodsFor: 'transactions' stamp: 'HAW 5/25/2019 12:23:27'!
addTransactionsTo: aCollectionOfTransactions

	self subclassResponsibility ! !

!Account methodsFor: 'transactions' stamp: 'HAW 5/25/2019 12:23:15'!
transactions

	self subclassResponsibility ! !


!Account methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:24:04'!
addedTo: aPortfolio

	self subclassResponsibility ! !


!classDefinition: #Portfolio category: 'Portfolio-Solucion'!
Account subclass: #Portfolio
	instanceVariableNames: 'accounts parents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 11:49:20'!
accountsIncludes: anAccount

	^accounts includes: anAccount ! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:05:04'!
accountsIsEmpty
	
	^accounts isEmpty ! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 11:49:06'!
accountsSize
	
	^accounts size! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:19:20'!
add: accountToAdd

	self assertCanAdd: accountToAdd.
		
	accounts add: accountToAdd.
	accountToAdd addedTo: self 
	! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:17:31'!
rootParents
	
	| rootParents |
	
	rootParents := Set new.
	self addRootParentsTo: rootParents.
	
	^ rootParents! !


!Portfolio methodsFor: 'initialization' stamp: 'HAW 5/25/2019 12:03:18'!
initialize

	accounts := OrderedCollection new.
	parents := OrderedCollection new.! !


!Portfolio methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:19:36'!
balance
	
	^accounts sum: [ :anAccount | anAccount balance ] ifEmpty: [ 0 ]! !


!Portfolio methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:42:55'!
addTransactionsTo: aCollectionOfTransactions

	accounts do: [ :anAccount | anAccount addTransactionsTo: aCollectionOfTransactions ]! !

!Portfolio methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:38:32'!
transactions
	
	| transactions |
	
	transactions := OrderedCollection new.
	accounts do: [ :anAccount | anAccount addTransactionsTo: transactions ].
	
	^transactions ! !


!Portfolio methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:02:59'!
addedTo: aPortfolio 
	
	parents add: aPortfolio ! !


!Portfolio methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:20:56'!
anyRootParentIsComposedBy: accountToAdd

	^self rootParents anySatisfy: [ :aParent | aParent isComposedBy: accountToAdd]! !

!Portfolio methodsFor: 'testing' stamp: 'HAW 5/25/2019 11:28:29'!
hasRegistered: aTransaction

	^accounts anySatisfy: [ :anAccount | anAccount hasRegistered: aTransaction ]! !

!Portfolio methodsFor: 'testing' stamp: 'HAW 5/29/2019 16:24:54'!
isComposedBy: anAccount

	^ self = anAccount or: [ accounts anySatisfy: [ :composedAccount | (composedAccount isComposedBy: anAccount) or: [ anAccount isComposedBy: composedAccount ]]]! !


!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 12:17:31'!
addRootParentsTo: rootParents

	parents 
		ifEmpty: [ rootParents add: self ] 
		ifNotEmpty: [ parents do: [ :aParent | aParent addRootParentsTo: rootParents ]]! !

!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 12:20:36'!
assertCanAdd: accountToAdd

	(self anyRootParentIsComposedBy: accountToAdd) ifTrue: [ self signalCanNotAddAccount ].
! !

!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 11:48:34'!
signalCanNotAddAccount
	
	self error: self class canNotAddAccountErrorMessage! !


!Portfolio methodsFor: 'as yet unclassified' stamp: 'TC&OLT 10/24/2022 16:18:28'!
accept: aVisitor
	
	aVisitor visitPortfolio: self.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: 'Portfolio-Solucion'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:48:55'!
canNotAddAccountErrorMessage
	
	^'Can not add repeated account to a portfolio'! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:18:21'!
with: anAccount

	^self new 
		add: anAccount;
		yourself! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:23:59'!
with: anAccount with: anotherAccount

	^self new 
		add: anAccount;
		add: anotherAccount;
		yourself! !


!classDefinition: #ReceptiveAccount category: 'Portfolio-Solucion'!
Account subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:35'!
initialize

	super initialize.
	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:38:52'!
addTransactionsTo: aCollectionOfTransactions

	aCollectionOfTransactions addAll: transactions ! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
transactions 

	^ transactions copy! !


!ReceptiveAccount methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:24:46'!
balance

	^transactions 
		inject: 0
		into: [ :currentBalance :transaction | transaction affectBalance: currentBalance ]! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'NR 10/21/2019 18:55:56'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !

!ReceptiveAccount methodsFor: 'testing' stamp: 'HAW 5/25/2019 11:54:51'!
isComposedBy: anAccount

	^self = anAccount ! !


!ReceptiveAccount methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:03:32'!
addedTo: aPortfolio 
	
	! !


!ReceptiveAccount methodsFor: 'summary' stamp: 'TC&OLT 10/24/2022 12:24:25'!
accountSummary
	
	| summary |
	
	summary := OrderedCollection new.
	
	transactions do: [
		:aTransaction |
		summary add: aTransaction summaryLine.
	].
	
	summary add: 'Balance = ', self balance asString.
	
	^summary.! !


!ReceptiveAccount methodsFor: 'category-name' stamp: 'TC&OLT 10/24/2022 14:29:15'!
transferNet

	^transactions 
		inject: 0
		into: [ :currentTransferNet :aTransaction | aTransaction affectTransferNet: currentTransferNet ]
	

! !


!ReceptiveAccount methodsFor: 'accept' stamp: 'TC&OLT 10/24/2022 15:09:25'!
accept: aVisitor
	
	aVisitor visitReceptiveAccount: self.! !


!classDefinition: #AccountTransaction category: 'Portfolio-Solucion'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountTransaction methodsFor: 'value' stamp: 'HernanWilkinson 9/12/2011 12:25'!
value 

	self subclassResponsibility ! !


!AccountTransaction methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:39'!
affectBalance: aBalance

	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: 'Portfolio-Solucion'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'TC&OLT 10/24/2022 10:33:41'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
	
	^ transaction! !


!classDefinition: #Deposit category: 'Portfolio-Solucion'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Deposit methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:45'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:38'!
value

	^ value! !


!Deposit methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:02'!
affectBalance: aBalance

	^aBalance + value ! !


!Deposit methodsFor: 'as yet unclassified' stamp: 'TC&OLT 10/24/2022 14:22:39'!
affectTransferNet: aTransferNet

	^aTransferNet.! !

!Deposit methodsFor: 'as yet unclassified' stamp: 'TC&OLT 10/24/2022 12:19:53'!
summaryLine

	^'Depósito por ' , (self value asString) , '.'.! !


!Deposit methodsFor: 'accept' stamp: 'TC&OLT 10/24/2022 15:24:16'!
accept: aVisitor
	
	aVisitor visitDeposit: self.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: 'Portfolio-Solucion'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Withdraw category: 'Portfolio-Solucion'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Withdraw methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:46'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:33'!
value

	^ value! !


!Withdraw methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:15'!
affectBalance: aBalance

	^aBalance - value! !


!Withdraw methodsFor: 'as yet unclassified' stamp: 'TC&OLT 10/24/2022 15:32:10'!
accept: aVisitor
	
	aVisitor visitWithdraw: self.! !

!Withdraw methodsFor: 'as yet unclassified' stamp: 'TC&OLT 10/24/2022 14:22:32'!
affectTransferNet: aTransferNet

	^aTransferNet.! !

!Withdraw methodsFor: 'as yet unclassified' stamp: 'TC&OLT 10/24/2022 12:27:19'!
summaryLine

	^'Extracción por ' , (self value asString) , '.'.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: 'Portfolio-Solucion'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #AccountTransactionFromTransfer category: 'Portfolio-Solucion'!
Object subclass: #AccountTransactionFromTransfer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountTransactionFromTransfer methodsFor: 'value' stamp: 'TC&OLT 10/24/2022 12:05:01'!
value 

	self subclassResponsibility ! !


!AccountTransactionFromTransfer methodsFor: 'balance' stamp: 'TC&OLT 10/24/2022 12:05:16'!
affectBalance: aBalance

	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransactionFromTransfer class' category: 'Portfolio-Solucion'!
AccountTransactionFromTransfer class
	instanceVariableNames: ''!

!AccountTransactionFromTransfer class methodsFor: 'instance creation' stamp: 'TC&OLT 10/24/2022 11:36:16'!
on: anAccount for: aTransfer

	| transaction |
	
	transaction := self for: aTransfer.
	anAccount register: transaction.
	
	^ transaction! !


!classDefinition: #DepositFromTransfer category: 'Portfolio-Solucion'!
AccountTransactionFromTransfer subclass: #DepositFromTransfer
	instanceVariableNames: 'transferRoot'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!DepositFromTransfer methodsFor: 'navigation' stamp: 'TC&OLT 10/24/2022 10:41:20'!
transferRoot
	
	^transferRoot.! !


!DepositFromTransfer methodsFor: 'initialization' stamp: 'TC&OLT 10/24/2022 11:30:37'!
initializeFor: aTransfer

	transferRoot := aTransfer.! !


!DepositFromTransfer methodsFor: 'balance' stamp: 'TC&OLT 10/24/2022 11:31:13'!
affectBalance: aBalance

	^aBalance + transferRoot value.! !


!DepositFromTransfer methodsFor: 'value' stamp: 'TC&OLT 10/24/2022 12:06:55'!
value

	^transferRoot value.! !


!DepositFromTransfer methodsFor: 'as yet unclassified' stamp: 'TC&OLT 10/24/2022 15:42:30'!
accept: aVisitor
	
	aVisitor visitDepositFromTransfer: self.! !

!DepositFromTransfer methodsFor: 'as yet unclassified' stamp: 'TC&OLT 10/24/2022 14:21:58'!
affectTransferNet: aTransferNet

	^aTransferNet + self value.

! !

!DepositFromTransfer methodsFor: 'as yet unclassified' stamp: 'TC&OLT 10/24/2022 12:27:04'!
summaryLine

	^'Entrada por transferencia de ' , (self value asString) , '.'.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DepositFromTransfer class' category: 'Portfolio-Solucion'!
DepositFromTransfer class
	instanceVariableNames: ''!

!DepositFromTransfer class methodsFor: 'instance creation' stamp: 'TC&OLT 10/24/2022 11:30:12'!
for: aTransfer.

	^ self new initializeFor: aTransfer.! !


!classDefinition: #WithdrawFromTransfer category: 'Portfolio-Solucion'!
AccountTransactionFromTransfer subclass: #WithdrawFromTransfer
	instanceVariableNames: 'transferRoot'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!WithdrawFromTransfer methodsFor: 'navigation' stamp: 'TC&OLT 10/24/2022 10:41:38'!
transferRoot
	
	^transferRoot.! !


!WithdrawFromTransfer methodsFor: 'initialization' stamp: 'TC&OLT 10/24/2022 11:30:32'!
initializeFor: aTransfer

	transferRoot := aTransfer.! !


!WithdrawFromTransfer methodsFor: 'balance' stamp: 'TC&OLT 10/24/2022 11:31:24'!
affectBalance: aBalance

	^aBalance - transferRoot value.! !


!WithdrawFromTransfer methodsFor: 'value' stamp: 'TC&OLT 10/24/2022 12:07:01'!
value

	^transferRoot value.! !


!WithdrawFromTransfer methodsFor: 'as yet unclassified' stamp: 'TC&OLT 10/24/2022 15:39:12'!
accept: aVisitor
	
	aVisitor visitWithdrawFromTransfer: self.! !

!WithdrawFromTransfer methodsFor: 'as yet unclassified' stamp: 'TC&OLT 10/24/2022 14:22:19'!
affectTransferNet: aTransferNet

	^aTransferNet - self value.! !

!WithdrawFromTransfer methodsFor: 'as yet unclassified' stamp: 'TC&OLT 10/24/2022 12:27:12'!
summaryLine

	^'Salida por transferencia de ' , (self value asString) , '.'.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'WithdrawFromTransfer class' category: 'Portfolio-Solucion'!
WithdrawFromTransfer class
	instanceVariableNames: ''!

!WithdrawFromTransfer class methodsFor: 'instance creation' stamp: 'TC&OLT 10/24/2022 11:30:21'!
for: aTransfer.

	^ self new initializeFor: aTransfer.! !


!classDefinition: #AccountVisitor category: 'Portfolio-Solucion'!
Object subclass: #AccountVisitor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!
!AccountVisitor commentStamp: '<historical>' prior: 0!
Podríamos haber derivado la estructura polimórfica de Visitor mediante TDD (haciendo primero dos objetos 'visitor' distintos de clases distintas con interfaces distintas, uno para summary y otro para transferNet, que luego confluyeran en una misma clase abstracta con la misma interfaz), pero no tuvimos tiempo.!


!AccountVisitor methodsFor: 'initialization' stamp: 'TC&OLT 10/24/2022 16:32:59'!
initializeWith: anAccount
	
	self subclassResponsibility.! !


!AccountVisitor methodsFor: 'result' stamp: 'TC&OLT 10/24/2022 16:33:10'!
result
	
	self subclassResponsibility.! !


!AccountVisitor methodsFor: 'visit' stamp: 'TC&OLT 10/24/2022 16:33:28'!
visitDeposit: aDeposit
	
	self subclassResponsibility.! !

!AccountVisitor methodsFor: 'visit' stamp: 'TC&OLT 10/24/2022 16:34:01'!
visitDepositFromTransfer: aDepositFromTransfer
	
	self subclassResponsibility.! !

!AccountVisitor methodsFor: 'visit' stamp: 'TC&OLT 10/24/2022 16:34:15'!
visitPortfolio: aPortfolio
	
	self subclassResponsibility.! !

!AccountVisitor methodsFor: 'visit' stamp: 'TC&OLT 10/24/2022 16:34:29'!
visitReceptiveAccount: aReceptiveAccount
	
	self subclassResponsibility.! !

!AccountVisitor methodsFor: 'visit' stamp: 'TC&OLT 10/24/2022 16:34:39'!
visitWithdraw: aWithdraw
	
	self subclassResponsibility.! !

!AccountVisitor methodsFor: 'visit' stamp: 'TC&OLT 10/24/2022 16:34:52'!
visitWithdrawFromTransfer: aWithdrawFromTransfer
	
	self subclassResponsibility.! !


!classDefinition: #SummaryVisitor category: 'Portfolio-Solucion'!
AccountVisitor subclass: #SummaryVisitor
	instanceVariableNames: 'account result'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!SummaryVisitor methodsFor: 'initialization' stamp: 'TC&OLT 10/24/2022 15:11:05'!
initializeWith: anAccount
	
	result := OrderedCollection new.
	account := anAccount.! !


!SummaryVisitor methodsFor: 'result' stamp: 'TC&OLT 10/24/2022 15:10:16'!
result
	
	account accept: self.
	^result.! !


!SummaryVisitor methodsFor: 'visit' stamp: 'TC&OLT 10/24/2022 15:25:56'!
visitDeposit: aDeposit
	
	result add: 'Depósito por ' , aDeposit value asString , '.'.! !

!SummaryVisitor methodsFor: 'visit' stamp: 'TC&OLT 10/24/2022 15:43:04'!
visitDepositFromTransfer: aDepositFromTransfer
	
	result add: 'Entrada por transferencia de ' , aDepositFromTransfer value asString , '.'.! !

!SummaryVisitor methodsFor: 'visit' stamp: 'TC&OLT 10/24/2022 16:18:57'!
visitPortfolio: aPortfolio
	
	aPortfolio transactions do: [
		:aTransaction |
		aTransaction accept: self.
	].
	
	result add: 'Balance = ' , aPortfolio balance asString.! !

!SummaryVisitor methodsFor: 'visit' stamp: 'TC&OLT 10/24/2022 15:30:16'!
visitReceptiveAccount: aReceptiveAccount
	
	aReceptiveAccount transactions do: [
		:aTransaction |
		aTransaction accept: self.
	].
	
	result add: 'Balance = ' , aReceptiveAccount balance asString.! !

!SummaryVisitor methodsFor: 'visit' stamp: 'TC&OLT 10/24/2022 15:32:39'!
visitWithdraw: aWithdraw
	
	result add: 'Extracción por ' , aWithdraw value asString , '.'.! !

!SummaryVisitor methodsFor: 'visit' stamp: 'TC&OLT 10/24/2022 15:42:05'!
visitWithdrawFromTransfer: aWithdrawFromTransfer
	
	result add: 'Salida por transferencia de ' , aWithdrawFromTransfer value asString , '.'.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SummaryVisitor class' category: 'Portfolio-Solucion'!
SummaryVisitor class
	instanceVariableNames: ''!

!SummaryVisitor class methodsFor: 'instance creation' stamp: 'TC&OLT 10/24/2022 15:06:41'!
for: anAccount
	
	^self new initializeWith: anAccount.! !


!classDefinition: #TransferNetVisitor category: 'Portfolio-Solucion'!
AccountVisitor subclass: #TransferNetVisitor
	instanceVariableNames: 'account result'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferNetVisitor methodsFor: 'initialization' stamp: 'TC&OLT 10/24/2022 16:37:36'!
initializeWith: anAccount
	
	result := 0.
	account := anAccount.! !


!TransferNetVisitor methodsFor: 'result' stamp: 'TC&OLT 10/24/2022 16:42:06'!
result
	
	account accept: self.
	^result.! !


!TransferNetVisitor methodsFor: 'as yet unclassified' stamp: 'TC&OLT 10/24/2022 16:43:16'!
visitReceptiveAccount: aReceptiveAccount
	
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TransferNetVisitor class' category: 'Portfolio-Solucion'!
TransferNetVisitor class
	instanceVariableNames: ''!

!TransferNetVisitor class methodsFor: 'instance creation' stamp: 'TC&OLT 10/24/2022 16:32:16'!
for: anAccount
	
	^self new initializeWith: anAccount.! !


!classDefinition: #Transfer category: 'Portfolio-Solucion'!
Object subclass: #Transfer
	instanceVariableNames: 'value withdrawLeg depositLeg'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Transfer methodsFor: 'initialization' stamp: 'TC&OLT 10/24/2022 13:38:46'!
initializeWith: anAmountToTransfer from: aSourceAccount to: aDestinationAccount
	
	value := anAmountToTransfer.
	withdrawLeg := WithdrawFromTransfer on: aSourceAccount for: self.
	depositLeg := DepositFromTransfer on: aDestinationAccount for: self.! !


!Transfer methodsFor: 'legs' stamp: 'TC 10/20/2022 20:20:53'!
depositLeg
	
	^depositLeg.! !

!Transfer methodsFor: 'legs' stamp: 'TC 10/20/2022 20:21:06'!
withdrawLeg
	
	^withdrawLeg.! !


!Transfer methodsFor: 'value' stamp: 'TC&OLT 10/24/2022 11:31:33'!
value
	
	^value.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Transfer class' category: 'Portfolio-Solucion'!
Transfer class
	instanceVariableNames: ''!

!Transfer class methodsFor: 'instance creation' stamp: 'TC&OLT 10/24/2022 11:01:32'!
register: anAmountToTransfer from: aSourceAccount to: aDestinationAccount
	
	^(Transfer new) initializeWith: anAmountToTransfer from: aSourceAccount to: aDestinationAccount.! !
