import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/UserModel.dart';
import 'Isar_services/Isar_service.dart';

class Authentication {
  final currentUsers = FirebaseAuth.instance.currentUser?.email;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  User? getCurrentuser() {
    return _firebaseAuth.currentUser;
  }

  Future<UserCredential> signIn(String email, String password) async {
    try {
      UserCredential? userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<UserCredential?> createdAccount(
    String name,
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = UserModel()
        ..uid = userCredential.user!.uid
        ..name = name
        ..email = email
        ..timestamp = DateTime.now();

      await IsarService.addUser(context, user);

      // await firestore
      //     .collection('Users')
      //     .doc(userCredential.user!.uid)
      //     .set({
      //   'uid': userCredential.user!.uid,
      //   'email': email,
      //   'username': name,
      //   'AddedUser': false,
      // });

      return userCredential;
    } catch (e) {
      print('Error creating account: $e');
      return null;
    }
  }

  Future<void> logOut() async {
    return await _firebaseAuth.signOut();
  }
}
