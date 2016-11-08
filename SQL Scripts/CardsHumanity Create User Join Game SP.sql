USE CardsHumanity
GO

--Create a new user
CREATE PROC spCreateUser @userName as varchar(10)
AS

INSERT INTO users
VALUES(@userName)

GO

--Create a user deck
CREATE PROC spCreateUserDeck @userID as int, @gameID int
AS
	--Build user deck of white cards bound to new game
INSERT INTO userDeck
	SELECT top 2 @userID, @gameID, wCardID
	FROM whiteDeck
	WHERE gameID = @gameID
	AND used=0
	ORDER BY NEWID()
--Set cards as used in white deck
UPDATE whiteDeck
SET used = 1
WHERE gameID = @gameID
AND wCardID IN
(
	SELECT cardID
	FROM userDeck
	WHERE gameID= @gameID
	AND userID = @userID
)
GO

--Place user into active game
CREATE PROC spJoinActiveGame @activeGame INT, @userID as int
AS
	--Add player to game
	INSERT INTO gamePlayers
	VALUES(@activeGame, @userID)
	print 'Start deck creation'
	--Create the users deck
	EXEC spCreateUserDeck @userID,@activeGame
	print 'End deck creation'
RETURN @activeGame
GO

--Place user into any game
--Create game if no active games
CREATE PROC spJoinGame @userID INT
AS
	DECLARE @game INT = (SELECT TOP 1 gameID FROM games WHERE active = 1) --Find active game
	PRINT @game

	IF @game IS NULL --No active games
	BEGIN
		EXEC @game = CardsHumanity.dbo.spCreateGame --Create a game
	END
	--Insert user into game that has been found or created
	INSERT INTO gamePlayers
	VALUES(@game,@userID)

	--Create a deck for the user
	EXEC spCreateUserDeck @userID,@game
GO
