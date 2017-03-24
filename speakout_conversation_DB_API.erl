-module(speakout_conversation_DB_API).
-compile([export_all]).
-include_lib("mongrel/include/mongrel_macros.hrl").
-record(conversation, {'_id', id, users, data, sender_id}).
add_mappings() ->
	mongrel_mapper:add_mapping(?mapping(conversation)).
getConversationId(UserList) ->

	{ok, Connection} = mongo:connect(localhost),
	{ok, Result} =  mongrel:do(safe, master, Connection, speakout, 
                           fun() ->
					   mongrel:find_one(#conversation{users = UserList})
			   end),
	 Result#conversation.id.

