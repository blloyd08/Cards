USE CardsHumanity
GO
--Create a game, create a black deck for game, create a white deck for game
--Return the ID of the game that was created
CREATE PROCEDURE createGame AS
DECLARE @gameID int
DECLARE @tempTable table(id int)

--Create Game, output the new gameID from the identity
INSERT INTO games
OUTPUT inserted.gameID into @tempTable
VALUES(Default,DEFAULT)--Default is current time, Default is active bit = 0


SELECT @gameID = id from @tempTable
PRINT @gameID

--Build black deck bound to new game
INSERT INTO blackDeck
	SELECT top 2 @gameID, bCardID,0
	FROM blackCards
	ORDER BY NEWID()

--Build white deck bound to new game
INSERT INTO whiteDeck
	SELECT top 7 @gameID, wCardID,0
	FROM whiteCards
	ORDER BY NEWID()

RETURN @gameID --return the newly created game id
GO