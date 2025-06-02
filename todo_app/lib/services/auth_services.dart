import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final authServicesNotifier = ValueNotifier<AuthServices>(AuthServices());

class AuthServices {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? get user => firebaseAuth.currentUser;
  Stream<User?> get userStream => firebaseAuth.authStateChanges();
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> signUpWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        await userCredential.user?.updateProfile(displayName: displayName);
      }
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> deleteAccount() async {
    try {
      await firebaseAuth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> updateEmail(String email) async {
    try {
      await firebaseAuth.currentUser?.verifyBeforeUpdateEmail(email);
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> updatePassword(String password) async {
    try {
      await firebaseAuth.currentUser?.updatePassword(password);
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }
}
