1.  What are we targeting – Stepover Language Barrier with fun!

2.  Who are we targeting – Multi Lingual group of friends

3.  How?

    1.  Mobile, Tab – Application

        1.  Logging – Phone number and Authentication over SMS or Voice.

        2.  Media – Record {Noise level reduction}, compression, playing quality
            and Qualify {Clear level, Language, Unknown and Transcribed data }.

        3.  User Information & Category {Naive, Pro, Observer}.

        4.  Groups – Create, Manage, Type {Broadcast or Local}.

        5.  Privacy – Visibility, Broadcast Receiver.

        6.  Device – Connectivity, Contacts sync

        7.  Agreement.

    2.  Server with audio compression and distribution.

        1.  Manage: Authentication, Users, Media, Group, Transfer, Validation,
            broadcast channel.

            1.  Authentication – Call or SMS the user to provide an OTP.

            2.  Users –

                1.  Based on phone numbers

                2.  Send identification list for identifying in user’s contacts.

                3.  Maintain user information

                    1.  Phone Number

                    2.  Name, Nick

                    3.  Visibility

                    4.  Broadcaster?

                    5.  Category

                    6.  Languages known

            3.  Media –

                4.  Compressing based on media size.

                5.  Noise cancellation

                6.  Send and receive methods.

                7.  Storage cap per user.

                8.  Broadcasting option

                9.  Smart Detect

            4.  Group –

                10. Group Name

                11. Description

                12. User List

                13. Invitation

                14. Manage Replies

                15. Broadcasting option switch.

            5.  Transfer –

                16. User – Server – User

                    7.  User1, User2 Information

                    8.  Language Transfer request type

                    9.  Languages Involved

                    10. Date and Time

                    11. Media Processing

                    12. Send to User1, User2

                17. User – Server – Group

                    13. User List Information

                    14. Languages Known to User List

                    15. Language transfer request type

                    16. Date and Time

                    17. Media Processing

                    18. Send to All in UserList?

                    19. Validation

        2.  Association

            1.  Primary: Phone

            2.  Pools: Languages, Friends, Visibility

        3.  Input API: Phone Number, language name *smart detect*, compressed
            media.

        4.  Output API: Compressed Media or Server uncompressed media,
            Notification.

4.  Infrastructure:

    1.  DB: MongoDB

    2.  Lang: ErLang, Haskel, Java, python

Problems Faced:

1.  1 Star - 3 star comments from the following

    1.  <https://play.google.com/store/apps/details?id=com.mforn.Activities>

    2.  <https://play.google.com/store/apps/details?id=com.hellotalk>

2.  Sleek UI Design.

    1.  Less details from talker.

    2.  Speed issue.

    3.  Data issue.

    4.  Make it more fun oriented.

    5.  **Abuse!! Eradication measures.**

DBase:

UserInfo: {User\_id, Phone, Name, Onlinestatus, DOB, ProfPic, Language\_id}

Language: {Language\_id, Language\_Name}

Blocked\_Person: {User\_Id, Blocked\_User[]}

Data: {Data\_id, Type, Length,format,Language\_Id}

Messages : {\_id, user[], message {data\_id,timestamp,sender}}

Dump of MongoDB Columns. The code for dumping is from [Stack overflow
link](http://stackoverflow.com/questions/2298870/mongodb-get-names-of-all-keys-in-collection)

-   *userinfo* [ "\_id", "languageId", "name", "phone", "status", "user\_id" ]

-   *language* [ "\_id", "l\_id", "name" ]

-   *blockTable* [ "\_id", "blocked\_ids", "blocker\_id" ]

-   *messages* [ "\_id", "data", "id", "sender\_id", "timestamp", "users" ]

-   *data* [ "\_id", "data\_id", "format", "language", "length", "type",
    “binary” ]

Due to the overhead of storing large amount of data in one record we are
changing the design:

1.  Store all the data at user side. No storage of data at user side.

2.  Implement a table “pending\_data” which includes the data details and users
    list to whom messages should sent.

table structure:

pending\_data [“\_id”,”sender\_id”, “binary”, “format”, “language\_id”,
“timestamp”, “[users List]”, “sent?”]

The API calls to mongoDB from the server side( erl scripts):

1.  getAllUsers() -- output all users data

2.  getUserbyID(user\_id)

3.  getUserbyPhone(phone)

4.  getUsersbyLanguage(l\_id)

5.  insertUser(user\_record)

6.  insertSampleUser(user\_id)

7.  deleteUser(user\_id)

8.  updateUserInfo(user\_id, user\_record) -- this is used update any
    information of the user

9.  getAllLanguages()

10. getLanguagebyId(l\_id)

11. getBlockedIds(user\_id)

12. isUserBlocked(main\_user, second\_user)

13. getMessagesBySenderId(user\_id)

14. getMessageLanguage(messageId)

15. getMessagesOfUser(userId,groupid)

16. getUserInformationbyUserId(usr\_id\_list,colums\_list-*optional default =
    all\_colums*)

**Rest API document.**

Request API:

ADD/Register:

1.  *{*

2.  *“rq-operation”: “ADD”*

3.  *“status”: XXX XXX XXXX*

4.  *“arguement” :*

    1.  *{ /\*User info json\*/*

    2.  *}*

5.  *“” :*

6.  *}*

7.  *{*

8.  *“resp-operation”:”AUTH”*

9.  *“status” : “OK”*

10. *“arguement” : user\_info json containing “user\_Id”*

11. *“auth\_tok”: “User\_id”*

12. *}*

Authentication:

1.  *{*

2.  *“rq-operation”: “AUTH”*

3.  *“status”:””*

4.  *“arguement” :*

    1.  *{*

    2.  *phone:*

    3.  *name:*

    4.  *user\_tok:*

    5.  *}*

5.  *“auth\_tok” :*

6.  *}*

7.  *{*

8.  *“resp-operation”:”AUTH”*

9.  *“status” : “OK”*

10. *“arguement” : user\_info json containing “user\_Id”*

11. *“auth\_tok”: “User\_id”*

12. *}*

General messages:

1.  *{*

2.  *“rq-operation”:”MSG”*

3.  *“status” : “SEND/RESEND/SENT/DELIVARY NOTIFICATION”*

4.  *“arguments”: “{sender\_id: users\_list: data:{binary,format,size}}”*

5.  *“argument-size”: “”*

6.  *“last-op” : “”*

7.  *“timestamp”:*

8.  *“auth\_tok”: “” (Recieved while authenticate)*

9.  *}*

*Response API:*

1.  *{*

2.  *“resp-operation”: “MSG”*

3.  *“status” : “OK”*

4.  *“arguement” : “”*

5.  *“auth\_tok”:*

6.  *}*

rq-operation:

Specify the API that is intended to be called.

status:

SUCCESS

INVALID\_REQUEST

INVALID\_RESPONSE

INVALID\_ARG

1.  *Register User:*

2.  *Send Message:*

3.  *Receive Message:*

*https://developer.android.com/google/gcm/index.html*

1.  *Notification:*

    1.  *Create Group:*

    2.  *{*

    3.  *“rq-operation”: “ADD”*

    4.  *“status”: XXX XXX XXXX*

    5.  *“arguement” :*

        1.  *{ /\*User info json\*/*

        2.  *}*

    6.  *“” :*

    7.  *}*

    8.  *{*

    9.  *“resp-operation”:”AUTH”*

    10. *“status” : “OK”*

    11. *“arguement” : user\_info json containing “user\_Id”*

    12. *“auth\_tok”: “User\_id”*

    13. *}*

2.  *Delete Group:*

3.  *Exit Group:*

4.  *Sync Contact for other SpeakOut users:*

5.  *Broadcast Message:*

6.  *Update Settings:*
