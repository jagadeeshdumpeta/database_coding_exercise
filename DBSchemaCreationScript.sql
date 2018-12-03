create extension cube;
create extension earthdistance;
--table to store all user data
CREATE TABLE Users
(
	UserPK SERIAL PRIMARY KEY,
	UserDisplayName varchar(600) NOT NULL,
	Age  integer,
	JobTitle varchar(400),
	Height  integer,
	CityName varchar(600),
	lat float8,
	lon float8,
	Photo varchar(600),
	PokemonCathRate float8,
	CatsOwned integer,
	LikeCats BOOLEAN,
	Religion varchar(200)
);

--table to store matched user id data for a user
--IsMatched=1: matched, 0: match rejected
CREATE table UsersMatchSet
(
	UserID integer not null REFERENCES Users(UserPK),	
	MatchedUserID integer not null REFERENCES Users(UserPK),
	IsMatched integer not null default(1)	
);

--configuration table where we specify distance(in miles) between users to be matched.
CREATE table Configurations
(
	DistanceInMiles integer not null
);
