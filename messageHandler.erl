-module(messageHandler).
%-include("speakout_userinfo_DB_API.hrl").
-compile([export_all]).
 -record(userinfo, {'_id', user_id, phone, name, status, languageId, profilePic}).
-record(data, { format,langauge,length,type,binary, timeStamp}).
-record(conversation, {'_id', id, users, data, sender_id}).

%sendMessage(Data, Sender_id, UsersList, SenderId, TimeStamp) ->.
storeMessage(UsersList,Sender_id, Data) -> 
	case 

