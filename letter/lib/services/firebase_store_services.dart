
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:letter/services/storage_base.dart';

class FirebaseStoreServices extends StorageBase {

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  Reference? _ref;

  @override
  Future<String?> upLoadFile(String userId, String fileType, File? file) async {

    _ref = _firebaseStorage.ref().child(userId).child(fileType);
    var uploadTask = _ref!.putFile(file!);
    String? url;
    await uploadTask.whenComplete(() async{
      try{
        url = await _ref!.getDownloadURL();
      }catch(onError){
        print("------------------Error----------------------");
      }

    });
    url = url!;
    print('URL: ' + url!);
    return url!;
  }

}