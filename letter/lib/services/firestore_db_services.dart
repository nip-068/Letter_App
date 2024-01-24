
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:letter/model/app_user.dart';
import 'package:letter/model/chat_massage.dart';
import 'package:letter/services/database_base.dart';

class FirestoreDBBase implements DBBase {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(AppUser? user, String? userName, String? phoneNumber, String? profileURL) async {
    try {
      user!.phoneNumber = phoneNumber;
      user.profileURL = profileURL;
      user.username = userName;
      await _firestore.collection('User').doc(user.userId).set(user.getUserMap());
      return true;
    } catch(e) {
      debugPrint('firebase store save user error: ${e.toString()}');
      return false;
    }
  }

  @override
  Future<AppUser?> reedUser(String userId) async {
    AppUser reedUser;
    try {
      DocumentSnapshot dS = await _firestore.collection('User').doc(userId).get();
      Map<String, dynamic> userData = dS.data() as Map<String, dynamic>;
      reedUser = AppUser.fromMap(userData);
      print(reedUser.toString());
      return reedUser;
    } catch(e) {
      debugPrint('reed user error: ${e.toString()}');
    }
    return null;
  }

  @override
  Future<List<AppUser>> getAllAppUsers() async {
    List<AppUser> appUsers = [];
    QuerySnapshot qs = await _firestore.collection('User').get();
    for(DocumentSnapshot user in qs.docs) {
      AppUser appUser = AppUser.fromMap(user.data() as Map<String, dynamic>);
      appUsers.add(appUser);
    }

    return appUsers;
  }

  @override
  Stream<List<ChatMassage>> getMessages(String currentUserId, String toUserId) {
    var sp = _firestore.collection('speeches').doc(currentUserId+'--'+toUserId).collection('messages').orderBy('date').snapshots();

    return sp.map((massageList) => massageList.docs.map((message) => ChatMassage.fromMap(message.data())).toList());
  }

  @override
  Future<bool> saveMessage(ChatMassage theMessage) async {
    var messageId = _firestore.collection('speeches').doc().id;
    var myDocId = theMessage.fromUserId+'--'+theMessage.toUserId;
    var receiverDocId = theMessage.toUserId+'--'+theMessage.fromUserId;
    await _firestore.collection('speeches').doc(myDocId).collection('messages').doc(messageId).set(theMessage.toMap());

    Map<String, dynamic> yourMap = theMessage.toMap();
    yourMap.update('isMyMessage', (value) => false);
    await _firestore.collection('speeches').doc(receiverDocId).collection('messages').doc(messageId).set(yourMap);

    return true;

  }




}

