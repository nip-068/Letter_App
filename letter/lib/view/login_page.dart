import 'package:flutter/material.dart';
import 'package:letter/model/app_user.dart';
import 'package:letter/view/sing_up_page.dart';
import 'package:letter/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _eMailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userMode = Provider.of<UserViewModel>(context);

    return Scaffold(
        appBar: _appBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Center(
                  child: _backgroundImage(),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 8.0),
                child: const Center(
                  child: Text(
                    'welcome!',
                    style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                child: _username(userMode),
              ),
              Container(
                margin:
                    const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                child: _password(userMode),
              ),
              Container(
                margin:
                    const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                child: _singUpAndLogin(userMode),
              ),
              Container(
                margin: const EdgeInsets.only(
                    top: 16.0, left: 24.0, right: 16.0, bottom: 16.0),
                child: _forgotPassword(),
              )
            ],
          ),
        ),
      ); }

  _forgotPassword() => Row(
        children: [
          const Text('If you forgot your password, '),
          InkWell(
            onTap: () {},
            child: const Text(
              'click',
              style: TextStyle(color: Colors.indigo),
            ),
          )
        ],
      );

  _singUpAndLogin(UserViewModel userMode) => Row(
        children: [
          OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => const SingUp(),
                    ));
              },
              child: const Text('Sign Up')),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 16.0),
              child: FilledButton(
                onPressed: () => _onPressedLogin(userMode),
                child: const Text('Login'),
              ),
            ),
          ),
        ],
      );

  _onPressedLogin(UserViewModel userMode) async {
    try {
      AppUser? loginUser = await userMode.signInEmailAndPassword(
          _passwordController.text, _eMailController.text);
    } catch(e) {
      debugPrint("error (_onPressedLogin): ${e}");
    }
  }

  _username(UserViewModel userMode) => TextField(
        controller: _eMailController,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.email),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
            labelText: 'Enter your E mail',
            errorText: userMode.warningMassage),
      );

  _password(UserViewModel userMode) => TextField(
        controller: _passwordController,
        obscureText: true,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
            labelText: 'Enter your password',
            errorText: userMode.warningMassage),
      );

  _backgroundImage() => SizedBox(
        height: 100,
        width: 100,
        child: Image.asset('images/pigeon_image.png'),
      );

  _appBar() => AppBar(
        title: const Column(
          children: [
            Text(
              "Letter",
              style:
                  TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
            ),
            Text(
              "Login",
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
        centerTitle: true,
      );
}
