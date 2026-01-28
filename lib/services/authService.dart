// ignore_for_file: file_names

import 'dart:developer';

import 'package:maintain_chat_app/repositories/authRepo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:maintain_chat_app/Caching/Database/Init.dart';
import 'package:maintain_chat_app/Caching/Database/ListFriends.dart';

import '../models/userModels.dart';

class Authservice implements Authrepo {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final IsarFriendsDao _isarFriendsDao = IsarFriendsDao(
    InitializedCaching.isar,
  );
  @override
  Future<UserApp?> login(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      //get User
      UserApp? currentUser = await _firebaseFirestore
          .collection('UserData')
          .doc(_firebaseAuth.currentUser!.uid)
          .get()
          .then((doc) => UserApp.fromJson(doc.data() ?? {}));
      // save to local storage
      final currentUserInlocal = await _isarFriendsDao.getUserById(
        _firebaseAuth.currentUser!.uid,
      );
      if (currentUserInlocal == null && currentUser != null) {
        await _isarFriendsDao.upsert(currentUser);
      }
      return currentUser;
    } on FirebaseAuthException catch (e) {
      log("lỗi $e");
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'auth_error_user_not_found';
          break;
        case 'wrong-password':
          errorMessage = 'auth_error_wrong_password';
          break;
        case 'invalid-email':
          errorMessage = 'auth_error_invalid_email';
          break;
        case 'user-disabled':
          errorMessage = 'auth_error_user_disabled';
          break;
        case 'too-many-requests':
          errorMessage = 'auth_error_too_many_requests';
          break;
        case 'network-request-failed':
          errorMessage = 'auth_error_network_failed';
          break;
        case 'invalid-credential':
          errorMessage = 'auth_error_invalid_credential';
          break;
        default:
          errorMessage = 'auth_error_default';
      }
      throw Exception(errorMessage);
    }
  }

  @override
  Future<UserApp?> checkAuth() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return null;
    }
    return await _firebaseFirestore
        .collection('UserData')
        .doc(user.uid)
        .get()
        .then((doc) => UserApp.fromJson(doc.data() ?? {}));
  }

  @override
  Future<UserApp?> register(String name, String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      UserApp currentUser = UserApp(
        id: userCredential.user!.uid,
        userName: name,
        email: email,
      );

      //save to cloud store
      await _firebaseFirestore
          .collection('UserData')
          .doc(currentUser.id)
          .set(currentUser.toJson());

      return currentUser;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'auth_error_email_already_in_use';
          break;
        case 'invalid-email':
          errorMessage = 'auth_error_invalid_email';
          break;
        case 'operation-not-allowed':
          errorMessage = 'auth_error_operation_not_allowed';
          break;
        case 'weak-password':
          errorMessage = 'auth_error_weak_password';
          break;
        case 'network-request-failed':
          errorMessage = 'auth_error_network_failed';
          break;
        default:
          errorMessage = 'auth_error_default';
      }
      throw Exception(errorMessage);
    }
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  //resetPass
  @override
  Future<String?> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return email;
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    }
  }

  //for accessing firebase messaging (Push Notification)
  FirebaseMessaging fMessaging = FirebaseMessaging.instance;
  //for getting firebase messaging token
  @override
  Future<String?> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();
    // print(x.authorizationStatus);
    final String? pushToken = await fMessaging.getToken().then((token) {
      if (token != null) {
        log('token: $token');
        return token;
      }
      return null;
    });
    return pushToken;
  }
}
