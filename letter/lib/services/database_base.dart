
import 'package:letter/model/app_user.dart';
import 'package:letter/model/chat_massage.dart';

abstract class DBBase {
  Future<bool> saveUser(AppUser user, String? userName, String? phoneNumber, String? profileURL);
  Future<AppUser?> reedUser(String userId);
  Future<List<AppUser>> getAllAppUsers();
  Stream<List<ChatMassage>> getMessages(String currentUserId, String toUserId);
  Future<bool> saveMessage(ChatMassage theMessage);
}
