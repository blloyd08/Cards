USE master
GO

DROP DATABASE CardsHumanity
GO

CREATE DATABASE CardsHumanity
GO

USE CardsHumanity
GO

--Black cards hold the main sentance with a blank spot
CREATE TABLE blackCards
(
bCardID INT IDENTITY NOT NULL PRIMARY KEY,
phrase varchar(255) NOT NULL,
blanks int NOT NULL CHECK (blanks between 1 and 3)
)
GO

--Holds the phrase that is placed in a blank spot
CREATE TABLE whiteCards
(
wCardID INT IDENTITY NOT NULL PRIMARY KEY,
phrase varchar(255) NOT NULL
)
GO

--Users that will be playing the game
CREATE TABLE users
(
userID INT IDENTITY NOT NULL PRIMARY KEY,
userName varchar(20) NOT NULL
)
GO

--Game holds rounds and users
CREATE TABLE games
(
gameID INT IDENTITY NOT NULL PRIMARY KEY,
createTime DATETIME	NOT NULL DEFAULT getDate(),
active bit NOT NULL DEFAULT 1
)
GO

-- players assigned to a specific game
CREATE TABLE gamePlayers
(
gameID INT NOT NULL,
userID INT NOT NULL,
CONSTRAINT uk_game_user UNIQUE(gameID,userID)
)
GO

--Collection of black cards that will be played in a game
CREATE TABLE blackDeck
(
gameID INT NOT NULL
	REFERENCES games,
bCardID INT NOT NULL REFERENCES blackCards,
used bit NOT NULL
)
GO

--Collection of white cards that will be played in a game
CREATE TABLE whiteDeck
(
gameID INT NOT NULL
	REFERENCES games,
wCardID INT NOT NULL
	REFERENCES whiteCards,
used bit NOT NULL
)
GO

--Collection of white cards for each user for each game
CREATE TABLE userDeck
(
userID INT NOT NULL
	REFERENCES users,
gameID INT NOT NULL
	REFERENCES games,
cardID INT NOT NULL
	REFERENCES whiteCards
)
GO

--Every round within a game
CREATE TABLE rounds
(
roundID INT IDENTITY NOT NULL PRIMARY KEY,
gameID INT NOT NULL
	REFERENCES games,
readerID INT NOT NULL
	REFERENCES users,
bCardID INT NOT NULL
	REFERENCES blackCards,
finished BIT NOT NULL DEFAULT 0
)
GO

-- Holds the selected white cards before winner is selected
CREATE TABLE roundCards
(
roundID INT NOT NULL
	REFERENCES rounds,
userID INT NOT NULL
	REFERENCES users,
cardPosition INT NOT NULL
	CHECK (cardPosition between 1 and 3),
cardID INT NOT NULL
	REFERENCES whiteCards,
CONSTRAINT ck_unique_position UNIQUE (cardPosition,userID,cardID,roundID)
)
GO

--Players in a round (Round is bound to game)
CREATE TABLE roundPlayers
(
roundID INT NOT NULL
	REFERENCES rounds,
userID INT NOT NULL
	REFERENCES users
)
GO

--The winning cards
CREATE TABLE winCard
(
roundID INT NOT NULL
	REFERENCES rounds,
wCardID INT NOT NULL
	REFERENCES whiteCards
)
GO

--Black test cards
INSERT INTO blackCards
VALUES('He said | and I said |.',2),
('I dont know where I would be without |.',1),
('I want to go to |',1),
('I don''t want to go to school, I want to stay home and | with you.',1)


--White test cards
INSERT INTO whiteCards
VALUES('Dog'),
('Cat'),
('Hotel'),
('Dorrito'),
('Elephant'),
('the deft'),
('fire ants')

--test user
INSERT INTO users
VALUES ('test')
