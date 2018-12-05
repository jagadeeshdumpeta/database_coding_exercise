CREATE OR REPLACE PROCEDURE get_matches(username varchar(600))
LANGUAGE plpgsql
AS $$
														 
	DECLARE 
			row RECORD;
	BEGIN	
		select * into row from Users where userdisplayname = username;	
														 
	--returns matched users 
		--1. when all the matching conditions are satisfied
		--2. when not all, gives user matches based on the order of importance specified in the problem.
	--orally This result set contains all the matching users.
														 
		select usm.userpk from users usm 
		where (point(row.lat,row.lon) <@> point(usm.lon,usm.lat)) = (select DistanceInMiles from Configurations)
		and age between (row.age-5, row.age+5) 
		and ((row.CatsOwned>0 and LikeCats='true') or row.CatsOwned=0)
		and ((PokemonCathRate*100>=row.PokemonCathRate*100-30) or (row.PokemonCathRate*100=70 and (row.PokemonCathRate-PokemonCathRate)*100<15))
		and Religion = row.Religion
		UNION
		select usm.userpk from users usm 
		where (point(row.lat,row.lon) <@> point(usm.lon,usm.lat)) = (select DistanceInMiles from Configurations)													   
		UNION
		select usm.userpk from users usm 
		where age >= row.age-5 and age <= row.age+5
		UNION
		select usm.userpk from users usm 
		where ((row.CatsOwned>0 and LikeCats='true') or row.CatsOwned=0)
		UNION
		select usm.userpk from users usm 
		where ((PokemonCathRate*100>=row.PokemonCathRate*100-30) or (row.PokemonCathRate*100=70 and (row.PokemonCathRate-PokemonCathRate)*100<15))
		UNION
		select usm.userpk from users usm 
		where Religion = row.Religion;															   

	END;					  
$$;
