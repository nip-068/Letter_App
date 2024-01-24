import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letter/model/app_user.dart';
import 'package:letter/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class SingUp extends StatefulWidget {
  const SingUp({super.key});

  @override
  State<StatefulWidget> createState() => _SingUpState();
}

class _SingUpState extends State<SingUp> {
  bool _accept = false;
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _eMailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  File? _fileProfileImage;

  @override
  void dispose() {
    _userNameController.dispose();
    _eMailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userMode = Provider.of<UserViewModel>(context);

    if (userMode.appUser != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
    }

    return (userMode.state == ViewState.Idle)
        ? Scaffold(
            appBar: _appBar(),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: _profileImage(),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: const Center(
                      child: Text(
                        'let\'s get started!',
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 16.0, left: 16.0, right: 16.0),
                    child: _username(userMode),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 16.0, left: 16.0, right: 16.0),
                    child: _password(userMode),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 16.0, left: 16.0, right: 16.0),
                    child: _email(userMode),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 16.0, left: 16.0, right: 16.0),
                    child: _phone(userMode),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: _checkBox(),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 16.0),
                    child: FilledButton(
                      onPressed: _accept
                          ? () {
                              _onPressedSignUp(userMode);
                            }
                          : null,
                      child: const Text('Sign Up'),
                    ),
                  )
                ],
              ),
            ),
          )
        : Scaffold(
            body: Center(
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
            ),
          );
  }

  _profileImage() => SizedBox(
        height: 100,
        width: 100,
        child: IconButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          child: TextButton(
                              onPressed: () {
                                _getImageFromGallery();
                                Navigator.of(context).pop();
                              },
                              child: Row(
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(
                                          right: 8.0, left: 8.0),
                                      child: const Icon(Icons.image)),
                                  const Text('Go to gallery')
                                ],
                              )),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          child: TextButton(
                              onPressed: () {
                                _getImageFromCamera();
                                Navigator.of(context).pop();
                              },
                              child: Row(
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(
                                          right: 8.0, left: 8.0),
                                      child: const Icon(Icons.camera_alt)),
                                  const Text('Go to camera')
                                ],
                              )),
                        )
                      ],
                    );
                  });
            },
            icon: _fileProfileImage == null
                ? Image.asset("images/profile_image.png")
                : SizedBox(
                    width: 100,
                    height: 100,
                    child: CircleAvatar(
                      backgroundImage: FileImage(_fileProfileImage!),
                    ))),
      );

  _onPressedSignUp(UserViewModel model) async {
    try {
      if (_fileProfileImage != null) {
        AppUser? loginUser = await model.createUserEmailAndPassword(
            _userNameController.text,
            _passwordController.text,
            _eMailController.text,
            _phoneController.text,
            _fileProfileImage!.path);
      } else {
        AppUser? loginUser = await model.createUserEmailAndPassword(
            _userNameController.text,
            _passwordController.text,
            _eMailController.text,
            _phoneController.text,
            'images/profile_image.jpg');
      }
    } catch (e) {
      if (mounted) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Record Creation Error'),
                  content: const Text('This Account Is Being Used'),
                  actions: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(primary: Colors.red),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('close'),
                    )
                  ],
                ));
      }
      debugPrint("error (_onPressedSignUp): ${e}");
    }
  }

  _checkBox() => Row(
        children: [
          Checkbox(
              value: _accept,
              onChanged: (bool? value) {
                setState(() {
                  _accept = value!;
                });
              }),
          const Text(
            'I accept the terms of use',
            textAlign: TextAlign.center,
          ),
        ],
      );

  _email(UserViewModel userMode) => TextField(
        controller: _eMailController,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.email),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
            labelText: 'Enter your E-mail',
            errorText: userMode.warningMassage),
      );

  _phone(UserViewModel userMode) => TextField(
        controller: _phoneController,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.phone),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
            labelText: 'phone number(+90)',
            errorText: userMode.warningMassage),
      );

  _username(UserViewModel userMode) => TextField(
        controller: _userNameController,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.account_circle),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
            labelText: 'Enter a username',
            errorText: userMode.warningMassageUserName),
      );

  _password(UserViewModel userMode) => TextField(
        controller: _passwordController,
        obscureText: true,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
            labelText: 'Enter a password',
            errorText: userMode.warningMassage),
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
              "Sign Up",
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
        centerTitle: true,
      );

  void _getImageFromGallery() async {
    XFile? f = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _fileProfileImage = f != null ? File(f.path) : null;
    });
  }

  void _getImageFromCamera() async {
    var f = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _fileProfileImage = f != null ? File(f.path) : null;
    });
  }
}
