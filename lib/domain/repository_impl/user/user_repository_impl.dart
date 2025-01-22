import 'package:order_app/domain/entities/user_firestore/add_user_data.dart';

import 'package:order_app/domain/entities/user_firestore/update_user_req.dart';

import 'package:order_app/domain/entities/user.dart';
import 'package:order_app/services/service_locator.dart';

import '../../repository/user/user_repository.dart';
import '../../sources/firestore/firestore_service.dart';

class UserRepositoryImpl extends UserRepository {
  @override
  Future<void> addCurrentUserData(AddUserReq addUserReq) {
    return serviceLocator<FirestoreService>().addCurrentUserData(addUserReq);
  }

  @override
  Future<UserModel?>? getCurrentUserData() {
    return serviceLocator<FirestoreService>().getCurrentUserData();
  }

  @override
  Future<UserModel?>? getUserData(String userID) {
    return serviceLocator<FirestoreService>().getUserData(userID);
  }

  // @override
  // Future<void> updateCurrentUserData(UpdateUserReq updateUserReq) {
  //   return serviceLocator<FirestoreService>()
  //       .updateCurrentUserData(updateUserReq);
  // }

  @override
  Future<String> checkRoleUser() {
    return serviceLocator<FirestoreService>().checkRoleUser();
  }
}
