
import 'package:letter/model/app_user.dart';

abstract class AuthBase {

  Future<AppUser?> currentUser();
  Future<AppUser?> signInAnonymously();
  Future<bool> signOutAnonymously();
  Future<AppUser?> signInEmailAndPassword(String password, String email);
  Future<AppUser?> createUserEmailAndPassword(String username, String password, String email, String? phoneNumber, String? profileURL);
  Future<bool> signOutEmailAndPassword();

}