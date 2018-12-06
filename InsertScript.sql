--uploaded given json data from data.json file to user.csv excel file.
--from the excel file, below query will copy the data to users table.

COPY users(UserDisplayName,Age,JobTitle,Height,CityName,lat,lon,Photo,PokemonCathRate,CatsOwned,LikeCats,Religion) 
FROM 'C:\Users\jagadeesh.dumpeta\Downloads\users.csv' DELIMITER ',' CSV HEADER;
