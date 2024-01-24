import 'package:flutter/material.dart';
import 'package:letter/model/app_user.dart';
import 'package:letter/model/chat_massage.dart';
import 'package:letter/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final AppUser _toUser;
  final AppUser _currentUser;

  const ChatPage(this._currentUser, this._toUser, {super.key});

  @override
  State<StatefulWidget> createState() => ChatPageState(_currentUser, _toUser);
}

class ChatPageState extends State<ChatPage> {
  final AppUser _toUser;
  final AppUser _currentUser;

  final TextEditingController _messageTextController = TextEditingController();

  ChatPageState(this._currentUser, this._toUser);

  @override
  Widget build(BuildContext context) {
    final userMode = Provider.of<UserViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${_toUser.username}'),
        leading: Container(
            margin: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
            child: CircleAvatar(backgroundImage: _getProfile(_toUser))),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder(
              stream: userMode.getMessages(_currentUser.userId, _toUser.userId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  var data = snapshot.data;
                  return ListView.builder(
                    itemCount: data != null ? data.length : 0,
                    itemBuilder: (context, index) {
                      return _messagingBox(data![index]);
                    },
                  );
                }
              },
            )),
            Container(
              margin: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageTextController,
                      cursorColor: Colors.indigo,
                      style:
                          const TextStyle(fontSize: 16.0, color: Colors.black),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Enter a message',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: FloatingActionButton(
                      elevation: 0,
                      backgroundColor: Colors.indigo,
                      child: const Icon(
                        Icons.navigation,
                        size: 35,
                        color: Colors.white70,
                      ),
                      onPressed: () async {
                        if (_messageTextController.text.trim().isNotEmpty) {
                          ChatMassage theMessage = ChatMassage(
                              _currentUser.userId,
                              _toUser.userId,
                              _messageTextController.text,
                              true,
                              null);
                          var s = await userMode.saveMessage(theMessage);
                          if (s) {
                            _messageTextController.clear();
                          }
                        }
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _getProfile(AppUser user) {
    if (user.profileURL!.contains('images/profile_image.jpg')) {
      return const AssetImage('images/profile_image.png');
    } else {
      return NetworkImage(user.profileURL!);
    }
  }

  Widget _messagingBox(ChatMassage chatMassage) {
    Color _fromMassageColor = Colors.indigo.shade100;
    Color _toMessageColor = Colors.blue;
    bool _meMassage = chatMassage.isMyMessage;
    if (_meMassage) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: _fromMassageColor),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(4),
            child: Text(chatMassage.message),
          )
        ]),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                    margin: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                    child: CircleAvatar(backgroundImage: _getProfile(_toUser))),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _toMessageColor),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(4),
                  child: Text(chatMassage.message),
                )
              ],
            )
          ],
        ),
      );
    }
  }
}
