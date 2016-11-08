USE CardsHumanity
GO
--Create a new round in a game. Validate before making the round
/* **Will fail if**
- Supplied game id is not active
- Not three or more active players in the game
- There are not enough black cards associated with the game id to start the round
*/
CREATE PROCEDURE spCreateRound @activeGame int
AS

DECLARE @valid bit = 1

-- Make sure game is still active before create a round
IF
(SELECT active FROM games WHERE gameID = @activeGame) = 0
SET @valid = 0

--Make sure there is enough players to start a round
IF
(SELECT count(*) FROM gamePlayers WHERE gameID =@activeGame) < 3
SET @valid = 0


--Make sure there are black cards left to start a round
IF(SELECT COUNT(*) FROM blackDeck WHERE used = 0 AND gameID = @activeGame) = 0
SET @valid = 0
PRINT @valid

--IF Valid create round
IF @Valid = 1
BEGIN
	DECLARE @reader INT
	DECLARE @firstPlayer INT =  (SELECT TOP 1 userID FROM gamePlayers WHERE gameID = @activeGame ORDER BY userID)
	--Determine round reader
	--Set player if first round
	IF (SELECT count(*) FROM rounds WHERE gameID = @activeGame) =0
	BEGIN
		SET @reader = @firstPlayer--Get first game player arranged by user id
	END
	ELSE --Set player if not first round
	BEGIN
		--Get Reader from previous round for current game
			DECLARE @previousReader INT = (SELECT TOP 1 readerID FROM rounds WHERE gameID = @activeGame ORDER BY roundID DESC)
		--Determine next player
		DECLARE @nextPlayer int = (SELECT TOP 1 userID FROM gamePlayers WHERE userID > @previousReader)
		IF @nextPlayer IS NULL
		BEGIN
			SET @reader = @firstPlayer
		END
		ELSE
		BEGIN
			SET @reader = @nextPlayer
		END
	END--END Select reader
	PRINT @reader

	--SELECT BlackCard
	DECLARE @roundCard int = (SELECT TOP 1 bCardID FROM blackDeck WHERE used = 0)
	
	--CREATE ROUND
	INSERT INTO rounds
	VALUES(@activeGame,@reader,@roundCard,0)

	--SET Black Card as used
	UPDATE blackDeck
	SET used = 1
	WHERE bCardID = @roundCard
END

GO