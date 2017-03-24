-module(speakout_userinfo_DB_API).

-compile([export_all]).

%-export([add_mappings/0, insertSampleUsers/0, getAllUsers/0, getUserbyID/1, getUserbyPhone/1, insertUser/1, deleteUser/1, updateUserInfo/2]).
 -include_lib("mongrel/include/mongrel_macros.hrl").

% the userinfo is the colletion name
% The field names should exactly match with the database field names.
% all the fields should start with small letters
  -record(userinfo, {'_id', user_id, phone, name, status, languageId, profilePic}).
getFileData(Filename) ->
	{ok,File} = file:read_file(Filename),
	File.
createFile(Filename, Data) ->
	file:write_file(Filename, Data).

add_mappings() ->
        % For mongrel to work, we need to specify how to map books, authors and reviews.
        mongrel_mapper:add_mapping(?mapping(userinfo)).


 insertSampleUsers() ->
        % Create some users
	 % make sure that left hand side variable should start with Upper case letter
 	User2 = #userinfo{?id(), user_id = 1, phone = 4012344567, name = "kiran", status = "cool", languageId = 10},
	io:fwrite([User2]),
       {ok, Connection} = mongo:connect(localhost),
        mongrel:do(safe, master, Connection, speakout, 
                           fun() ->
                                           mongrel:insert_all([User2])
                           end).

getAllUsers() ->
        {ok, Connection} = mongo:connect(localhost),
        mongrel:do(safe, master, Connection, speakout, 
                           fun() ->
                                           Cursor = mongrel:find(#userinfo{}),
                                           mongrel_cursor:rest(Cursor)
                           end).
 
getUserbyID(Id)-> 
	{ok, Connection} = mongo:connect(localhost),
	{ok, Result} =  mongrel:do(safe, master, Connection, speakout, 
                           fun() ->
					   mongrel:find_one(#userinfo{user_id = Id})
			   end),
			Result.
getUserbyPhone(Phone)-> 
	{ok, Connection} = mongo:connect(localhost),
        mongrel:do(safe, master, Connection, speakout, 
                           fun() ->
					   Cursor = mongrel:find(#userinfo{phone = Phone}),
					   mongrel_cursor:rest(Cursor)
					 
			   end).


deleteUser(Id)-> 
	{ok, Connection} = mongo:connect(localhost),
        mongrel:do(safe, master, Connection, speakout, 
                           fun() ->
					   mongrel:delete_one(#userinfo{user_id = Id})
			   end).
insertUser(User)-> 
	{ok, Connection} = mongo:connect(localhost),
        mongrel:do(safe, master, Connection, speakout, 
                           fun() ->
					   mongrel:insert(User)
			   end).
updateUserInfo(UserId, NewDocument)->
	{ok, Connection} = mongo:connect(localhost),
        mongrel:do(safe, master, Connection, speakout, 
                           fun() ->
					   OldDocument = mongrel:find_one(#userinfo{user_id = UserId}),
					   mongrel:replace(OldDocument, NewDocument)
			   end).
updateUserProfilePic(UserId, Data)->
	{ok, Connection} = mongo:connect(localhost),
        mongrel:do(safe, master, Connection, speakout, 
                           fun() ->
					   Document = mongrel:find_one(#userinfo{user_id = UserId}),
					   mongrel:replace(Document, Document#userinfo{profilePic = Data})
			   end).
getUserProfilePic(Id) ->
	{ok, Connection} = mongo:connect(localhost),
	{ok, Result} =  mongrel:do(safe, master, Connection, speakout, 
                           fun() ->
					   mongrel:find_one(#userinfo{user_id = Id})
			   end),
	 Result#userinfo.profilePic.		
