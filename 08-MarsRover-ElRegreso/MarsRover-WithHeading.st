!classDefinition: #MarsRoverRecorderTest category: 'MarsRover-WithHeading'!
TestCase subclass: #MarsRoverRecorderTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverRecorderTest methodsFor: 'tests' stamp: 'OLT&TC 10/27/2022 12:06:55'!
test01PositionLoggerLogsNothingAfterProcessingEmptyCommandSequence
	
	| marsRover log logStream|
	
	marsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	"log := ReadWriteStream on: String new.
	
	marsRover logPositionWith: [:aPosition | log nextPutAll: aPosition asString]."
	
	log := MarsRoverLog new.
	
	marsRover recordPositionChangesOn: log.
		
	marsRover process: ''.
	
	logStream := log readStream.
	
	self assert: logStream atEnd.! !

!MarsRoverRecorderTest methodsFor: 'tests' stamp: 'OLT&TC 10/27/2022 12:33:25'!
test02PositionLoggerLogsPositionAfterMovingForwardHeadingNorth
	
	| marsRover log logStream|
	
	marsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	"
	log := ReadWriteStream on: String new.
	
	marsRover logPositionWith: [:aPosition | log nextPutAll: aPosition asString]."
	
	log := MarsRoverLog new.
	
	marsRover recordPositionChangesOn: log.
	
	marsRover process: 'f'.
	
	logStream := log readStream.
	
	self assert: '1@2' equals: logStream nextLine.
	self assert: logStream atEnd.! !

!MarsRoverRecorderTest methodsFor: 'tests' stamp: 'OLT&TC 10/27/2022 12:36:53'!
test03PositionLoggerLogsPositionAfterMovingForwardTwiceAndBackwardsHeadingNorth
	
	| marsRover log logStream|
	
	marsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	"log := ReadWriteStream on: String new.
		
	marsRover logPositionWith: [:aPosition | log nextPutAll: aPosition asString]."
	
	log := MarsRoverLog new.
	
	marsRover recordPositionChangesOn: log.
	
	marsRover process: 'ffb'.
	
	logStream := log readStream.
	
	self assert: '1@2' equals: logStream nextLine.
	self assert: '1@3' equals: logStream nextLine.
	self assert: '1@2' equals: logStream nextLine.
	
	self assert: logStream atEnd.! !

!MarsRoverRecorderTest methodsFor: 'tests' stamp: 'TC&OLT 10/27/2022 12:47:22'!
test04HeadingLoggerLogsNothingAfterProcessingEmptyCommandSequence
	
	| marsRover log logStream |
	
	marsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	"log := ReadWriteStream on: String new.
	
	marsRover logHeadingWith: [:aHeading | log nextPutAll: aHeading class asString]."
	
	log := MarsRoverLog new.
	
	marsRover recordHeadingChangesOn: log.
	
	marsRover process: ''.
	
	logStream := log readStream.
	
	self assert: logStream atEnd.! !

!MarsRoverRecorderTest methodsFor: 'tests' stamp: 'TC&OLT 10/27/2022 12:50:20'!
test05HeadingLoggerLogsHeadingAfterRotatingRightHeadingNorth
	
	| marsRover log logStream |
	
	marsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	log := MarsRoverLog new.
	
	marsRover recordHeadingChangesOn: log.
	
	marsRover process: 'r'.
	
	logStream := log readStream.
	
	self assert: 'MarsRoverHeadingEast' equals: logStream nextLine.
	self assert: logStream atEnd.! !

!MarsRoverRecorderTest methodsFor: 'tests' stamp: 'TC&OLT 10/27/2022 12:53:22'!
test06HeadingLoggerLogsHeadingAfterRotatingRightTwiceAndLeftHeadingNorth
	
	| marsRover log logStream |
	
	marsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	log := MarsRoverLog new.
	
	marsRover recordHeadingChangesOn: log.
	
	marsRover process: 'rrl'.
	
	logStream := log readStream.
	
	self assert: 'MarsRoverHeadingEast' equals: logStream nextLine. 
	self assert: 'MarsRoverHeadingSouth' equals: logStream nextLine.
	self assert: 'MarsRoverHeadingEast' equals: logStream nextLine.
	self assert: logStream atEnd.! !

!MarsRoverRecorderTest methodsFor: 'tests' stamp: 'TC&OLT 10/27/2022 13:04:27'!
test07WindowLoggerLogsNothingAfterProcessingEmptyCommandSequence
	
	| marsRover log logStream|
	
	marsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	log := MarsRoverWindow new.
	
	marsRover recordPositionChangesOn: log.
		
	marsRover process: ''.
	
	logStream := log readStream.
	
	self assert: logStream atEnd.! !

!MarsRoverRecorderTest methodsFor: 'tests' stamp: 'TC&OLT 10/27/2022 13:29:44'!
test08WindowLoggerLogsPositionAfterMovingAndRotatingMultipleTimesHeadingNorth
	
	| marsRover log logStream|
	
	marsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	log := MarsRoverWindow new.
	
	marsRover recordPositionChangesOn: log.
	
	marsRover recordHeadingChangesOn: log.
		
	marsRover process: 'flbr'.
	
	logStream := log readStream.
	
	self assert: 'MarsRoverHeadingNorth' equals: logStream nextLine.
	self assert: logStream atEnd.! !


!classDefinition: #MarsRoverTest category: 'MarsRover-WithHeading'!
TestCase subclass: #MarsRoverTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:21:23'!
test01DoesNotMoveWhenNoCommand

	self 
		assertIsAt: 1@2 
		heading: self north 
		afterProcessing: '' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:28:12'!
test02IsAtFailsForDifferentPosition

	| marsRover |
	
	marsRover := MarsRover at: 1@1 heading: self north . 
	
	self deny: (marsRover isAt: 1@2 heading: self north)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:28:31'!
test03IsAtFailsForDifferentHeading

	| marsRover |
	
	marsRover := MarsRover at: 1@1 heading: self north . 
	
	self deny: (marsRover isAt: 1@1 heading: self south)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:30:17'!
test04IncrementsYAfterMovingForwardWhenHeadingNorth

	self 
		assertIsAt: 1@3 
		heading: self north 
		afterProcessing: 'f' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:30:11'!
test06DecrementsYAfterMovingBackwardsWhenHeadingNorth

	self 
		assertIsAt: 1@1 
		heading: self north 
		afterProcessing: 'b' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:59'!
test07PointToEashAfterRotatingRightWhenHeadingNorth

	self 
		assertIsAt: 1@2 
		heading: self east 
		afterProcessing: 'r' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:51'!
test08PointsToWestAfterRotatingLeftWhenPointingNorth

	self 
		assertIsAt: 1@2 
		heading: self west 
		afterProcessing: 'l' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:45'!
test09DoesNotProcessInvalidCommand

	| marsRover |
	
	marsRover := MarsRover at: 1@2 heading: self north.
	
	self 
		should: [ marsRover process: 'x' ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: marsRover invalidCommandErrorDescription.
			self assert: (marsRover isAt: 1@2 heading: self north) ]! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:39'!
test10CanProcessMoreThanOneCommand

	self 
		assertIsAt: 1@4 
		heading: self north 
		afterProcessing: 'ff' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:31'!
test11IncrementsXAfterMovingForwareWhenHeadingEast

	self 
		assertIsAt: 2@2 
		heading: self east 
		afterProcessing: 'f' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:19'!
test12DecrementsXAfterMovingBackwardWhenHeadingEast

	self 
		assertIsAt: 0@2 
		heading: self east 
		afterProcessing: 'b' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:14'!
test13PointsToSouthAfterRotatingRightWhenHeadingEast

		self 
		assertIsAt: 1@2 
		heading: self south 
		afterProcessing: 'r' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:05'!
test14PointsToNorthAfterRotatingLeftWhenPointingEast

		self 
		assertIsAt: 1@2 
		heading: self north 
		afterProcessing: 'l' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:00'!
test15ForwardBackwardsAndRotateRightWorkAsExpectedWhenPointingSouth

	self 
		assertIsAt: 1@1 
		heading: self west 
		afterProcessing: 'ffblrr' 
		whenStartingAt: 1@2 
		heading: self south 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:28:52'!
test16ForwardBackwardsAndRotateRightWorkAsExpectedWhenPointingWest

	self 
		assertIsAt: 0@2 
		heading: self north 
		afterProcessing: 'ffblrr' 
		whenStartingAt: 1@2 
		heading: self west 
! !


!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:31'!
east

	^ MarsRoverHeadingEast ! !

!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:38'!
north

	^ MarsRoverHeadingNorth ! !

!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:45'!
south

	^ MarsRoverHeadingSouth ! !

!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:54'!
west

	^ MarsRoverHeadingWest ! !


!MarsRoverTest methodsFor: 'assertions' stamp: 'HAW 10/7/2021 20:20:47'!
assertIsAt: newPosition heading: newHeadingType afterProcessing: commands whenStartingAt: startPosition heading: startHeadingType

	| marsRover |
	
	marsRover := MarsRover at: startPosition heading: startHeadingType. 
	
	marsRover process: commands.
	
	self assert: (marsRover isAt: newPosition heading: newHeadingType)! !


!classDefinition: #MarsRover category: 'MarsRover-WithHeading'!
Object subclass: #MarsRover
	instanceVariableNames: 'position head'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRover methodsFor: 'command processing' stamp: 'HAW 6/30/2018 19:48:26'!
process: aSequenceOfCommands

	aSequenceOfCommands do: [:aCommand | self processCommand: aCommand ]
! !

!MarsRover methodsFor: 'command processing' stamp: 'HAW 8/22/2019 12:08:50'!
processCommand: aCommand

	(self isForwardCommand: aCommand) ifTrue: [ ^ self moveForward ].
	(self isBackwardCommand: aCommand) ifTrue: [ ^ self moveBackward ].
	(self isRotateRightCommand: aCommand) ifTrue: [ ^ self rotateRight ].
	(self isRotateLeftCommand: aCommand) ifTrue: [ ^ self rotateLeft ].

	self signalInvalidCommand.! !


!MarsRover methodsFor: 'exceptions' stamp: 'HAW 6/30/2018 19:48:45'!
invalidCommandErrorDescription
	
	^'Invalid command'! !

!MarsRover methodsFor: 'exceptions' stamp: 'HAW 6/30/2018 19:50:26'!
signalInvalidCommand
	
	self error: self invalidCommandErrorDescription ! !


!MarsRover methodsFor: 'heading' stamp: 'TC 10/27/2022 15:11:52'!
headEast
	
	head changeValueTo: (MarsRoverHeadingEast for: self).! !

!MarsRover methodsFor: 'heading' stamp: 'TC 10/27/2022 15:11:55'!
headNorth
	
	head changeValueTo: (MarsRoverHeadingNorth for: self).! !

!MarsRover methodsFor: 'heading' stamp: 'TC 10/27/2022 15:11:59'!
headSouth
	
	head changeValueTo: (MarsRoverHeadingSouth for: self).! !

!MarsRover methodsFor: 'heading' stamp: 'TC 10/27/2022 15:12:02'!
headWest
	
	head changeValueTo: (MarsRoverHeadingWest for: self).! !

!MarsRover methodsFor: 'heading' stamp: 'TC 10/27/2022 15:12:04'!
rotateLeft
	
	head rotateLeft.! !

!MarsRover methodsFor: 'heading' stamp: 'TC 10/27/2022 15:12:07'!
rotateRight
	
	head rotateRight.! !


!MarsRover methodsFor: 'initialization' stamp: 'TC 10/27/2022 15:12:12'!
initializeAt: aPosition heading: aHeadingType
	
	position := RecordableObject with: aPosition.
	head := RecordableObject with: (aHeadingType for: self).! !


!MarsRover methodsFor: 'moving' stamp: 'TC 10/27/2022 15:12:32'!
moveBackward
	
	head moveBackward.! !

!MarsRover methodsFor: 'moving' stamp: 'TC 10/27/2022 15:12:36'!
moveEast
	
	position changeValueTo: (position + (1@0)).! !

!MarsRover methodsFor: 'moving' stamp: 'TC 10/27/2022 15:12:38'!
moveForward
	
	head moveForward.! !

!MarsRover methodsFor: 'moving' stamp: 'TC 10/27/2022 15:12:41'!
moveNorth
	
	position changeValueTo: (position + (0@1)).! !

!MarsRover methodsFor: 'moving' stamp: 'TC 10/27/2022 15:12:43'!
moveSouth
	
	position changeValueTo: (position + (0@-1)).! !

!MarsRover methodsFor: 'moving' stamp: 'TC 10/27/2022 15:12:46'!
moveWest
	
	position changeValueTo: (position + (-1@0)).! !


!MarsRover methodsFor: 'recorder addition' stamp: 'TC 10/27/2022 15:12:54'!
recordHeadingChangesOn: aHeadRecorder 
	
	head addRecordingBlock: [ :headValue | aHeadRecorder informOfChangeOn: headValue class asString.].! !

!MarsRover methodsFor: 'recorder addition' stamp: 'TC 10/27/2022 15:12:57'!
recordPositionChangesOn: aPositionRecorder 

	position addRecordingBlock: [ :positionValue | aPositionRecorder informOfChangeOn: positionValue asString. ].! !


!MarsRover methodsFor: 'testing' stamp: 'TC 10/27/2022 15:11:32'!
isAt: aPosition heading: aHeadingType

	^position value = aPosition and: [ head isHeading: aHeadingType ]! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:16:51'!
isBackwardCommand: aCommand

	^aCommand = $b! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:16:19'!
isForwardCommand: aCommand

	^aCommand = $f ! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:17:51'!
isRotateLeftCommand: aCommand

	^aCommand = $l! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:17:21'!
isRotateRightCommand: aCommand

	^aCommand = $r! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRover class' category: 'MarsRover-WithHeading'!
MarsRover class
	instanceVariableNames: 'headings'!

!MarsRover class methodsFor: 'instance creation' stamp: 'HAW 10/7/2021 20:10:30'!
at: aPosition heading: aHeadingType
	
	^self new initializeAt: aPosition heading: aHeadingType! !


!classDefinition: #MarsRoverHeading category: 'MarsRover-WithHeading'!
Object subclass: #MarsRoverHeading
	instanceVariableNames: 'marsRover'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeading methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft

	self subclassResponsibility ! !

!MarsRoverHeading methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight

	self subclassResponsibility ! !


!MarsRoverHeading methodsFor: 'testing' stamp: 'HAW 10/7/2021 20:15:38'!
isHeading: aHeadingType

	^self isKindOf: aHeadingType ! !


!MarsRoverHeading methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward

	self subclassResponsibility ! !

!MarsRoverHeading methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward

	self subclassResponsibility ! !


!MarsRoverHeading methodsFor: 'initialization' stamp: 'HAW 10/7/2021 20:11:59'!
initializeFor: aMarsRover 
	
	marsRover := aMarsRover.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverHeading class' category: 'MarsRover-WithHeading'!
MarsRoverHeading class
	instanceVariableNames: ''!

!MarsRoverHeading class methodsFor: 'instance creation' stamp: 'HAW 10/7/2021 20:11:35'!
for: aMarsRover 
	
	^self new initializeFor: aMarsRover ! !


!classDefinition: #MarsRoverHeadingEast category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingEast
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingEast methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	^marsRover moveWest! !

!MarsRoverHeadingEast methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveEast! !


!MarsRoverHeadingEast methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headNorth! !

!MarsRoverHeadingEast methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headSouth! !


!classDefinition: #MarsRoverHeadingNorth category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingNorth
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingNorth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	^marsRover moveSouth! !

!MarsRoverHeadingNorth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveNorth! !


!MarsRoverHeadingNorth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headWest! !

!MarsRoverHeadingNorth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headEast! !


!classDefinition: #MarsRoverHeadingSouth category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingSouth
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingSouth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	^marsRover moveNorth! !

!MarsRoverHeadingSouth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveSouth! !


!MarsRoverHeadingSouth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headEast! !

!MarsRoverHeadingSouth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headWest! !


!classDefinition: #MarsRoverHeadingWest category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingWest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingWest methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward

	^marsRover moveEast! !

!MarsRoverHeadingWest methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveWest! !


!MarsRoverHeadingWest methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headSouth! !

!MarsRoverHeadingWest methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headNorth! !


!classDefinition: #MarsRoverRecorder category: 'MarsRover-WithHeading'!
Object subclass: #MarsRoverRecorder
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverRecorder methodsFor: 'informing' stamp: 'TC&OLT 10/27/2022 13:24:19'!
informOfChangeOn: aChangedVariable

	self subclassResponsibility.! !


!MarsRoverRecorder methodsFor: 'reading' stamp: 'TC&OLT 10/27/2022 13:25:05'!
readStream
	
	self subclassResponsibility.! !


!classDefinition: #MarsRoverLog category: 'MarsRover-WithHeading'!
MarsRoverRecorder subclass: #MarsRoverLog
	instanceVariableNames: 'changesStream'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverLog methodsFor: 'informing' stamp: 'TC&OLT 10/27/2022 13:09:29'!
informOfChangeOn: aChangedVariable

	changesStream nextPutAll: aChangedVariable asString. "Estaría bueno que se ocupe alguien más de procesar el objeto que se registra."
	changesStream newLine.
! !


!MarsRoverLog methodsFor: 'initialization' stamp: 'OLT&TC 10/27/2022 12:30:45'!
initialize
	
	changesStream := WriteStream on: String new.! !


!MarsRoverLog methodsFor: 'reading' stamp: 'OLT&TC 10/27/2022 12:30:45'!
readStream
	
	^ ReadStream on: changesStream contents.! !


!classDefinition: #MarsRoverWindow category: 'MarsRover-WithHeading'!
MarsRoverRecorder subclass: #MarsRoverWindow
	instanceVariableNames: 'changesStream'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverWindow methodsFor: 'informing' stamp: 'TC&OLT 10/27/2022 13:09:43'!
informOfChangeOn: aChangedVariable

	changesStream resetContents.
	changesStream nextPutAll: aChangedVariable asString. "Estaría bueno que se ocupe alguien más de procesar el objeto que se registra."! !


!MarsRoverWindow methodsFor: 'initialization' stamp: 'TC&OLT 10/27/2022 12:57:51'!
initialize
	
	changesStream := WriteStream on: String new.! !


!MarsRoverWindow methodsFor: 'reading' stamp: 'TC&OLT 10/27/2022 12:57:42'!
readStream
	
	^ ReadStream on: changesStream contents.! !


!classDefinition: #RecordableObject category: 'MarsRover-WithHeading'!
Object subclass: #RecordableObject
	instanceVariableNames: 'value recordingBlocks'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!RecordableObject methodsFor: 'messaging' stamp: 'TC 10/27/2022 15:18:12'!
doesNotUnderstand: aMessage
	
	^aMessage sendTo: value.
	"Esto lo hacemos para no enviar 'value' constantemente a las variables de instancia de MarsRover que son de esta clase. Es ineficiente, pero funciona."! !


!RecordableObject methodsFor: 'recording' stamp: 'TC 10/27/2022 14:52:53'!
addRecordingBlock: aRecorderExecutionBlock
	
	recordingBlocks add: aRecorderExecutionBlock.! !


!RecordableObject methodsFor: 'value' stamp: 'TC 10/27/2022 14:50:28'!
changeValueTo: aNewValue
	
	value := aNewValue.
	
	recordingBlocks do: [ 
		:aRecordingBlock |
		aRecordingBlock value: value.
	]! !

!RecordableObject methodsFor: 'value' stamp: 'TC 10/27/2022 14:10:02'!
value
	
	^value.! !


!RecordableObject methodsFor: 'initialization' stamp: 'TC 10/27/2022 14:56:24'!
initializeWith: aValue
	
	value := aValue.
	recordingBlocks := OrderedCollection new.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'RecordableObject class' category: 'MarsRover-WithHeading'!
RecordableObject class
	instanceVariableNames: ''!

!RecordableObject class methodsFor: 'instance creation' stamp: 'TC 10/27/2022 14:59:50'!
with: aValue
	
	^self new initializeWith: aValue.! !
