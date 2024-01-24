import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:letter/model/app_user.dart';
import 'package:letter/view/chat_page.dart';
import 'package:letter/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isOnline = false;
  bool _isMassage = false;
  bool _isFabVisible = true;
  bool _isCall = false;

  @override
  Widget build(BuildContext context) {
    final userMode = Provider.of<UserViewModel>(context);
    return (userMode.state == ViewState.Idle)
        ? DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: _appBar(userMode),
              body: TabBarView(children: [
                _chatBody(userMode),
                _calls(userMode),
              ]), /*
              floatingActionButton:
                  _isFabVisible ? _floatingActionButton() : null,*/
            ),
          )
        : Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.asset('images/background_image.png'),
                  ),
                ),
                const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                    color: Colors.indigo,
                  ),
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 16.0),
                    child: const Text(
                      'Loading...',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  _calls(UserViewModel model) => FutureBuilder<List<AppUser>>(
        future: model.getAllAppUsers(),
        builder: (context, res) {
          if (res.hasData) {
            List<AppUser>? users = res.data;
            if (users != null && users.isNotEmpty) {
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  if (!(users[index].userId.contains(model.appUser!.userId))) {
                    return ListTile(
                      onTap: () {
                        debugPrint(users[index].userId);
                      },
                      trailing: const Icon(Icons.phone),
                      leading: CircleAvatar(
                        backgroundImage: _getProfile(users[index]),
                      ),
                      title: Text(users[index].username!),
                      subtitle: Text(users[index].phoneNumber ?? ''),
                    );
                  } else {
                    return Container();
                  }
                },
              );
            } else {
              return const Center(
                child: Text('no users'),
              );
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
      );

  _chatBody(UserViewModel model) => FutureBuilder<List<AppUser>>(
        future: model.getAllAppUsers(),
        builder: (context, res) {
          if (res.hasData) {
            List<AppUser>? users = res.data;
            if (users != null && users.isNotEmpty) {
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  if (!(users[index].userId.contains(model.appUser!.userId))) {
                    return ListTile(
                      onTap: () {
                        //debugPrint(users[index].userId);
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => ChatPage(model.appUser!, users[index]),
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        backgroundImage: _getProfile(users[index]),
                      ),
                      title: Text(users[index].username!),
                      subtitle: Text(users[index].eMail),
                    );
                  } else {
                    return Container();
                  }
                },
              );
            } else {
              return const Center(
                child: Text('no users'),
              );
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
      );

  _onPressed(UserViewModel userMode) async {
    await userMode.signOutEmailAndPassword();
  }

  _appBar(UserViewModel userMode) => AppBar(
        leading: Container(
            margin: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
            child:
                CircleAvatar(backgroundImage: _getProfile(userMode.appUser!))),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userMode.appUser!.username!),
            Row(
              children: [
                Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: const Icon(
                      Icons.email,
                      size: 12,
                    )),
                Text(
                  userMode.appUser!.eMail,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: const Icon(
                      Icons.phone,
                      size: 12,
                    )),
                Text(userMode.appUser!.phoneNumber!,
                    style: const TextStyle(fontSize: 12)),
              ],
            )
          ],
        ),
        actions: [
          IconButton(
              onPressed: () => _onPressed(userMode),
              icon: const Icon(Icons.exit_to_app))
        ],
        bottom: _tabBar(),
      );

  _tabBar() => const TabBar(indicatorSize: TabBarIndicatorSize.tab, tabs: [
        Tab(text: 'Chat', icon: Icon(Icons.email)),
        Tab(text: 'Calls', icon: Icon(Icons.phone))
      ]);

  _getProfile(AppUser user) {
    if (user.profileURL!.contains('images/profile_image.jpg')) {
      return const AssetImage('images/profile_image.png');
    } else {
      return NetworkImage(user.profileURL!);
    }
  }
}
