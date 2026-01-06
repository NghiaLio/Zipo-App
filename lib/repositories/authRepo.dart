
// ignore_for_file: file_names

import 'package:maintain_chat_app/models/userModels.dart';

abstract class Authrepo {
  Future<UserApp?> login(String email, String password);
  Future<UserApp?> register(String name, String email, String password);
  Future<void> logOut();
  Future<UserApp?> checkAuth();
  Future<String?> resetPassword(String email);
  Future<void> getFirebaseMessagingToken();
}
