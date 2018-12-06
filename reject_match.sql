CREATE OR REPLACE PROCEDURE reject_match(UserPk int, MatchedUserPk int)
LANGUAGE plpgsql
AS $$
	BEGIN
		UPDATE UsersMatchSet 
		set IsMatched=0 
		where UserID = UserPk and MatchedUserID = MatchedUserPk and IsMatched=1;
	END;					  
$$;
