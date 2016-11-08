USE CardsHumanity
GO

--Create view displaying game id and black card phrase
CREATE VIEW vwGameBlackDeck as
(
	SELECT gameID,bd.bCardID cardID, phrase,used
	FROM blackDeck bd
	JOIN blackCards bc ON bd.bCardID = bc.bCardID
)
GO

--Create view displaying game id and white card phrase
CREATE VIEW vwGameWhiteDeck as
(
	SELECT gameID,wd.wCardID cardID,phrase,used
	FROM whiteDeck wd
	JOIN whiteCards wc ON wd.wCardID = wc.wCardID
)
GO


--Create view of players deck consisiting of game id, user id, card id, and phrase
CREATE VIEW vwPlayerDeck AS
SELECT gameID,userID,ud.cardID cardID, phrase
FROM userDeck ud
JOIN whiteCards wc ON ud.cardID = wc.wCardID
GO