CREATE EXTENSION postgis;
--table to store all user data
CREATE TABLE Users
(
  UserPK SERIAL PRIMARY KEY,
  UserDisplayName varchar(600) NOT NULL,
  Age  integer,
	JobTitle varchar(400),
	Height  integer,
	CityName varchar(600),
	LocationPoint geography,
	Photo varchar(600),
	PokemonCathRate decimal,
	CatsOwned integer,
	LikeCats integer,
	Religion varchar(200)
);
CREATE INDEX ON Users5 USING LocationPoint(geog);

--table to store matched user id data for a user
--IsMatched=1: matched, 0: match rejected
CREATE table UsersMatchSet
(
	UserID integer not null REFERENCES Users2(UserPK),	
	MatchedUserID integer not null REFERENCES Users2(UserPK),
	IsMatched integer not null default(1)	
);

--configuration table where we specify distance(in meters) between users to be matched.
CREATE table Configurations
(
	DistanceInMeters integer not null
);
