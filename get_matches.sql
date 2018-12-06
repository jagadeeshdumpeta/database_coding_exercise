CREATE OR REPLACE PROCEDURE get_matches(username varchar(600))
returns table(useridvaue int)
AS $$
												 
DECLARE 
	MatchGenerate CURSOR for Select userpk, age, lat,lon,PokemonCathRate,CatsOwned,LikeCats,Religion from users where userdisplayname = username;
	row  RECORD;
  
	BEGIN
  	open MatchGenerate;
  LOOP
    FETCH FROM MatchGenerate INTO row;
    EXIT WHEN NOT FOUND;
	
	--storing into match table
	--1. when all the matching conditions are satisfied
	--2. when not all, inserts user matches based on the order of importance specified in the problem.
	--orally This stores 2 matching users for each user every time it is called.
		RETURN QUERY 
		select  usm.userpk from users usm where (point(row.lat,row.lon) <@> point(usm.lon,usm.lat)) = (select DistanceInMiles from Configurations)
		and	usm.age >= row.age-5 and usm.age <= row.age+5
		and ((row.CatsOwned>0 and usm.LikeCats='true') or row.CatsOwned=0)
		and ((usm.PokemonCathRate*100>=row.PokemonCathRate*100-30) or (row.PokemonCathRate*100=70 and (row.PokemonCathRate-usm.PokemonCathRate)*100<15))
		and usm.Religion = row.Religion		 
		and not exists (select 1 from UsersMatchSet where UserID = row.UserPK and MatchedUserID = usm.userpk and IsMatched=1)
		UNION
		select  usm.userpk from users usm 
		where (point(row.lat,row.lon) <@> point(usm.lon,usm.lat)) = (select DistanceInMiles from Configurations)	
		and not exists (select 1 from UsersMatchSet where UserID = row.UserPK and MatchedUserID = usm.userpk and IsMatched=1)
		UNION
		select  usm.userpk from users usm 
		where usm.age >= row.age-5 and usm.age <= row.age+5
		and not exists (select 1 from UsersMatchSet where UserID = row.UserPK and MatchedUserID = usm.userpk and IsMatched=1)
		UNION
		select  usm.userpk from users usm 
		where ((row.CatsOwned>0 and usm.LikeCats='true') or row.CatsOwned=0)
		and not exists (select 1 from UsersMatchSet where UserID = row.UserPK and MatchedUserID = usm.userpk and IsMatched=1)
		UNION
		select  usm.userpk from users usm 
		where ((usm.PokemonCathRate*100>=row.PokemonCathRate*100-30) or (row.PokemonCathRate*100=70 and (row.PokemonCathRate-usm.PokemonCathRate)*100<15))
		and not exists (select 1 from UsersMatchSet where UserID = row.UserPK and MatchedUserID = usm.userpk and IsMatched=1)
		UNION
		select  usm.userpk from users usm 
		where usm.Religion = row.Religion	
		and not exists (select 1 from UsersMatchSet where UserID = row.UserPK and MatchedUserID = usm.userpk and IsMatched=1);
							
  END LOOP;												   
 
	END;					  
$$ LANGUAGE plpgsql;
