CREATE OR REPLACE PROCEDURE generate_matches()
LANGUAGE plpgsql
AS $$
DECLARE 
	useridVar integer;
	ageVar	integer;
	CatsOwnedVar integer;
	latVar float8; 
	lonVar float8; 
	PokemonCathRateVar float8;
	LikeCatsVar BOOLEAN;
	ReligionVar varchar(200);
	
--CREATE TABLE  TempMatchedUsers(userid int, matcheduserId int);
DECLARE 
	MatchGenerate CURSOR for Select userpk, age, lat,lon,PokemonCathRate,CatsOwned,LikeCats,Religion from users;
	row  RECORD;
	
	BEGIN
  	open MatchGenerate;
  LOOP
    FETCH FROM MatchGenerate INTO row;
    EXIT WHEN NOT FOUND;
	
	--storing into match table if all matching conditions are applied
		insert into UsersMatchSet 
		select row.UserPK, userpk from users usm where age between (row.age-5, row.age+5) 
		and ((row.CatsOwned>0 and LikeCats='true') or row.CatsOwned=0)
		and ((PokemonCathRate*100>=row.PokemonCathRate*100-30) or (row.PokemonCathRate*100=70 and (row.PokemonCathRate-PokemonCathRate)*100<15))
		and Religion = row.Religion
		and (point(row.lat,row.lon) <@> point(usm.lon,usm.lat)) = (select DistanceInMiles from Configurations)
		and not exists (select 1 from UsersMatchSet where UserID = row.UserPK and MatchedUserID = usm.userpk and IsMatched=1) 
		LIMIT 2;
										
  END LOOP;
END;
					  
$$;
