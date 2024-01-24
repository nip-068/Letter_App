
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:letter/model/app_user.dart';

import 'auth_base.dart';

class FirebaseAuthService extends AuthBase {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<AppUser?> currentUser() async {
    try {
      User? fireUser = await _firebaseAuth.currentUser;
      return _userFromFirebase(fireUser);
    } catch(e) {
      debugPrint('current user error: ${e.toString()}');
      return null;
    }
  }

  AppUser? _userFromFirebase(User? user) {
    if (user != null) {

      return AppUser(null ,null ,null ,userId: user.uid, eMail: user.email!);
    } else {
      return null;
    }
}

  @override
  Future<AppUser?> signInAnonymously() async {
    try {
      var result = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(result.user);
    } catch(e) {
      debugPrint('sing in anonymously error: ${e.toString()}');
      return null;
    }
  }

  @override
  Future<bool> signOutAnonymously() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch(e) {
      debugPrint('sing out error: ${e.toString()}');
      return false;
    }
  }

  @override
  Future<AppUser?> signInEmailAndPassword(String password, String email) async {
      var result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(result.user);
  }

  @override
  Future<AppUser?> createUserEmailAndPassword(String username, String password, String email, String? phoneNumber, String? profileURL) async {

      var result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(result.user);

  }

  @override
  Future<bool> signOutEmailAndPassword() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch(e) {
      debugPrint('sing out error: ${e.toString()}');
      return false;
    }
  }



}