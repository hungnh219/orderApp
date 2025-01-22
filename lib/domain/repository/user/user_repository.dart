import 'package:order_app/domain/entities/user_firestore/add_user_data.dart';

import '../../entities/user.dart';

abstract class UserRepository {
  Future<UserModel?>? getUserData(String userID);

  Future<UserModel?>? getCurrentUserData();

  Future<void> addCurrentUserData(AddUserReq addUserReq);

  // Future<void> updateCurrentUserData(UpdateUserReq updateUserReq);

  Future<String> checkRoleUser();
}
