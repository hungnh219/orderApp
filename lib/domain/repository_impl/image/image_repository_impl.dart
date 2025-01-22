import 'package:order_app/domain/repository/image/image_repository.dart';
import 'package:order_app/domain/sources/firestore/firestore_service.dart';
import 'package:order_app/services/service_locator.dart';

class ImageRepositoryImpl extends ImageRepository {
  @override
  Future<void> uploadImageToFirebase(String assetPath) {
    return serviceLocator.get<FirestoreService>().uploadImageToFirebase(assetPath);
  }
}