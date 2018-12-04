CREATE OR REPLACE PROCEDURE reject_match(UserPk int, MatchedUserPk int)
LANGUAGE plpgsql
AS $$
	BEGIN
		UPDATE UsersMatchSet 
		set UsersMatchSet.IsMatched=0 
		where usersmatchset.UserID = UserPk and usersmatchset.UsersMatchSet.MatchedUserID = MatchedUserPk and usersmatchset.IsMatched=1;
	END;					  
$$;
