import 'dart:io';

import 'package:order_app/domain/repository/storage/storage_repository.dart';
import 'package:order_app/domain/sources/storage/storage_service.dart';
import 'package:order_app/services/service_locator.dart';


class StorageRepositoryImpl extends StorageRepository {
  @override
  Future<String>? uploadPostImage(String folderName, File image) {
    return serviceLocator<StorageService>().uploadPostImage(folderName, image);
  }

  @override
  Future<String>? uploadAvatar(File image, String uid) {
    return serviceLocator<StorageService>().uploadAvatar(image, uid);
  }
}
