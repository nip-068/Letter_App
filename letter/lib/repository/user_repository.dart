import 'dart:io';

import 'package:letter/locator.dart';
import 'package:letter/model/app_user.dart';
import 'package:letter/model/chat_massage.dart';
import 'package:letter/services/auth_base.dart';
import 'package:letter/services/firebase_auth_service.dart';
import 'package:letter/services/firebase_store_services.dart';
import 'package:letter/services/firestore_db_services.dart';

enum AppMod { RELEASE, DEBUG }

class UserRepository implements AuthBase {
  final FirebaseAuthService _firebaseAuthService =
      locator<FirebaseAuthService>();
  final FirestoreDBBase _firestoreDBBase = locator<FirestoreDBBase>();
  final FirebaseStoreServices firebaseStoreServices =
      locator<FirebaseStoreServices>();
  AppMod appMod = AppMod.RELEASE;

  @override
  Future<AppUser?> currentUser() async {
    if (appMod == AppMod.RELEASE) {
      AppUser? appUser = await _firebaseAuthService.currentUser();
      return await _firestoreDBBase.reedUser(appUser!.userId);
    } else {
      return null;
    }
  }

  @override
  Future<AppUser?> signInAnonymously() async {
    if (appMod == AppMod.RELEASE) {
      return await _firebaseAuthService.signInAnonymously();
    } else {
      return null;
    }
  }

  @override
  Future<bool> signOutAnonymously() async {
    if (appMod == AppMod.RELEASE) {
      return await _firebaseAuthService.signOutAnonymously();
    } else {
      return false;
    }
  }

  @override
  Future<AppUser?> signInEmailAndPassword(String password, String email) async {
    if (appMod == AppMod.RELEASE) {
      AppUser? appUser =
          await _firebaseAuthService.signInEmailAndPassword(password, email);
      return await _firestoreDBBase.reedUser(appUser!.userId);
    } else {
      return null;
    }
  }

  Future<List<AppUser>> getAllAppUsers() async {
    if (appMod == AppMod.RELEASE) {
      return await _firestoreDBBase.getAllAppUsers();
    } else {
      return [];
    }
  }

  @override
  Future<AppUser?> createUserEmailAndPassword(String username, String password,
      String email, String? phoneNumber, String? profileURL) async {
    if (appMod == AppMod.RELEASE) {
      String? dawURL;
      bool result;
      AppUser? appUser = await _firebaseAuthService.createUserEmailAndPassword(
          username, password, email, phoneNumber, profileURL);
      if (profileURL != null &&
          !profileURL.contains('images/profile_image.jpg')) {
        File file = File(profileURL);
        dawURL = await firebaseStoreServices.upLoadFile(
            appUser!.userId, 'profile_image.jpg', file);
        result = await _firestoreDBBase.saveUser(
            appUser, username, phoneNumber, dawURL);
      } else {
        result = await _firestoreDBBase.saveUser(
            appUser, username, phoneNumber, profileURL);
      }
      return result ? await _firestoreDBBase.reedUser(appUser!.userId) : null;
    } else {
      return null;
    }
  }

  @override
  Future<bool> signOutEmailAndPassword() async {
    if (appMod == AppMod.RELEASE) {
      return await _firebaseAuthService.signOutEmailAndPassword();
    } else {
      return false;
    }
  }

  Stream<List<ChatMassage>> getMessages(String userId, String userId2) {
    try {
      var p = _firestoreDBBase.getMessages(userId, userId2);
      return p;
    } catch(e) {
      print('repo: getMessages: ${e.toString()}');
      return Stream.empty();
    }
  }

  Future<bool> saveMessage(ChatMassage theMessage) async {
    return await _firestoreDBBase.saveMessage(theMessage);
  }
}
