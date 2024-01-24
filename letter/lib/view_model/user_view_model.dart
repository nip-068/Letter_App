import 'dart:io';

import 'package:flutter/material.dart';
import 'package:letter/locator.dart';
import 'package:letter/model/chat_massage.dart';
import 'package:letter/repository/user_repository.dart';
import 'package:letter/services/auth_base.dart';

import '../model/app_user.dart';

enum ViewState { Idle, Busy }

class UserViewModel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.Idle;
  final UserRepository _userRepository = locator<UserRepository>();
  AppUser? _appUser;
  String? _warningMassage;
  String? _warningMassageUserName;

  AppUser? get appUser => _appUser;

  ViewState get state => _state;


  String? get warningMassage => _warningMassage;
  String? get warningMassageUserName => _warningMassageUserName;

  set state(ViewState state) {
    _state = state;
    notifyListeners();
  }

  UserViewModel() {
    currentUser();
  }

  @override
  Future<AppUser?> currentUser() async {
    try {
      state = ViewState.Busy;
      await Future.delayed(const Duration(seconds: 2));
      _appUser = await _userRepository.currentUser();
      return _appUser;
    } catch (e) {
      debugPrint('User View Model Current User Error: ${e.toString()}');
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<AppUser?> signInAnonymously() async {
    try {
      state = ViewState.Busy;
      await Future.delayed(const Duration(seconds: 2));
      _appUser = await _userRepository.signInAnonymously();
      return _appUser;
    } catch (e) {
      debugPrint('User View Model Sing In User Error: ${e.toString()}');
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> signOutAnonymously() async {
    try {
      state = ViewState.Busy;
      await Future.delayed(const Duration(seconds: 2));
      bool result = await _userRepository.signOutAnonymously();
      _appUser = null;
      return result;
    } catch (e) {
      debugPrint('User View Model Sing Out Error: ${e.toString()}');
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<AppUser?> signInEmailAndPassword(String password, String email) async {
    try {
      state = ViewState.Busy;
      await Future.delayed(const Duration(seconds: 2));
      if (_allCheck(password, email)) {
        _appUser = await _userRepository.signInEmailAndPassword(password, email);
      } else {
        _appUser = null;
      }
      return _appUser;
    }  finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<AppUser?> createUserEmailAndPassword(
      String username, String password, String email, String? phoneNumber, String? profileURL) async {
    try {
      state = ViewState.Busy;
      await Future.delayed(const Duration(seconds: 2));
      if (_allCheck(password, email) && _usernameCheck(username)) {
        _appUser = await _userRepository.createUserEmailAndPassword(
          username, password, email, phoneNumber, profileURL);
      } else {
        _appUser = null;
      }
      return _appUser;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> signOutEmailAndPassword() async {
    try {
      state = ViewState.Busy;
      await Future.delayed(const Duration(seconds: 2));
      bool result = await _userRepository.signOutEmailAndPassword();
      _appUser = null;
      return result;
    } catch (e) {
      debugPrint(
          'User View Model Sing Out Email And Password Error: ${e.toString()}');
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }


  bool _allCheck(String password, String email) {
    if (!_emailCheck(email) || !_passwordCheck(password)) {
      _warningMassage = 'invalid email or password';
      return false;
    } else {
      _warningMassage = null;
    }

    return true;
  }

  bool _usernameCheck(String username) {
    if (username.isNotEmpty && !_searchChar(username)) {
      _warningMassageUserName = null;
      return true;
    } else {
      _warningMassageUserName = 'invalid username';
      return false;
    }
  }

  bool _emailCheck(String email) {
    if (email.isNotEmpty && email.contains('.com')) {
      String s = email.replaceAll('.com', '');
      var a = s.split('@');
      if (a.length != 2 || _searchChar(s) || a[0].isEmpty || a[1].isEmpty) {
        return false;
      }
    } else {
      return false;
    }
    return true;
  }

  Future<List<AppUser>> getAllAppUsers() async {

    return await _userRepository.getAllAppUsers();
  }




  bool _passwordCheck(String password) {
    if (password.isNotEmpty && password.length < 10 && !_searchChar(password)) {
      return true;
    }
    return false;
  }

  bool _searchChar(String s) {
    if (s.contains(' ') ||
        s.contains('.') ||
        s.contains(',') ||
        s.contains(':') ||
        s.contains(';') ||
        s.contains('?') ||
        s.contains('*') ||
        s.contains('/') ||
        s.contains('+') ||
        s.contains('^') ||
        s.contains('(') ||
        s.contains(')') ||
        s.contains('=') ||
        s.contains('-') ||
        s.contains('|') ||
        s.contains('<') ||
        s.contains('!') ||
        s.contains('>') ||
        s.contains('\'') ||
        s.contains('\\') ||
        s.contains('#') ||
        s.contains('\$') ||
        s.contains('&') ||
        s.contains('{') ||
        s.contains('}') ||
        s.contains('[') ||
        s.contains(']') ||
        s.contains('"') ||
        s.contains('é') ||
        s.contains('%') ||
        s.contains('¨') ||
        s.contains('½') ||
        s.contains('~') ||
        s.contains('€')) {
      return true;
    } else {
      return false;
    }
  }

  Stream<List<ChatMassage>> getMessages(String userId, String userId2) {
      return _userRepository.getMessages(userId, userId2);
  }

  Future<bool> saveMessage(ChatMassage theMessage) async {
    return await _userRepository.saveMessage(theMessage);
  }


}
