import 'dart:io';

abstract class StorageBase {
  Future<String?> upLoadFile(String userId, String fileType, File file);
}