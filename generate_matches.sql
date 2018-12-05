CREATE OR REPLACE PROCEDURE generate_matches()
LANGUAGE plpgsql
AS $$
DECLARE 
	
DECLARE 
	MatchGenerate CURSOR for Select userpk, age, lat,lon,PokemonCathRate,CatsOwned,LikeCats,Religion from users;
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
		insert into UsersMatchSet 
		select row.UserPK, userpk from users usm where age between (row.age-5, row.age+5) 
		and ((row.CatsOwned>0 and LikeCats='true') or row.CatsOwned=0)
		and ((PokemonCathRate*100>=row.PokemonCathRate*100-30) or (row.PokemonCathRate*100=70 and (row.PokemonCathRate-PokemonCathRate)*100<15))
		and Religion = row.Religion
		and (point(row.lat,row.lon) <@> point(usm.lon,usm.lat)) = (select DistanceInMiles from Configurations)
		and not exists (select 1 from UsersMatchSet where UserID = row.UserPK and MatchedUserID = usm.userpk and IsMatched=1)
		UNION
		select row.UserPK, userpk from users usm 
		where (point(row.lat,row.lon) <@> point(usm.lon,usm.lat)) = (select DistanceInMiles from Configurations)													   
		UNION
		select row.UserPK, userpk from users usm 
		where age >= row.age-5 and age <= row.age+5
		UNION
		select row.UserPK, userpk from users usm 
		where ((row.CatsOwned>0 and LikeCats='true') or row.CatsOwned=0)
		UNION
		select row.UserPK, userpk from users usm 
		where ((PokemonCathRate*100>=row.PokemonCathRate*100-30) or (row.PokemonCathRate*100=70 and (row.PokemonCathRate-PokemonCathRate)*100<15))
		UNION
		select row.UserPK, userpk from users usm 
		where Religion = row.Religion	
		LIMIT 2;
										
  END LOOP;
END;
					  
$$;
