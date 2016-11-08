USE CardsHumanity
GO

EXEC createGame
GO

SELECT *
FROM games

EXEC spCreateUser 'Brian'

SELECT *
FROM users

EXEC spJoinActiveGame 1, 2

SELECT *
FROM gamePlayers

SELECT *
FROM userDeck

