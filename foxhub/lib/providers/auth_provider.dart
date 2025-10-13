import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foxhub/services/auth_service.dart';
import 'package:foxhub/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? userModel;

  // Fetch extended profile data from Firestore
  Future<Map<String, dynamic>?> fetchUserDataFromFirestore(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  // LOGIN
  Future<bool> login(String email, String password) async {
    try {
      final firebaseUser = await _authService.login(email, password); // returns Firebase User
      if (firebaseUser != null) {
        final userData = await fetchUserDataFromFirestore(firebaseUser.uid);
        if (userData != null) {
          userModel = UserModel.fromMap(userData);
          userModel!.uid = firebaseUser.uid;
          notifyListeners();
          return true;
        }
        print('User data not found in Firestore.');
        return false;
      }
      return false;
    } catch (e) {
      print("Login error: $e");
      return false;
    }
  }

  // REGISTER
  Future<bool> register(UserModel user, String password) async {
    try {
      // 1️⃣ Create Firebase Auth user
      UserCredential cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );

      // 2️⃣ Save user info to Firestore
      String uid = cred.user!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'fullName': user.fullName,
        'username': user.username,
        'email': user.email,
        'course': user.course,
        'number': user.number,
      });

      // 3️⃣ Store userModel locally
      userModel = user;
      userModel!.uid = uid;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth register error: ${e.code} - ${e.message}");
      return false;
    } catch (e) {
      print("Other register error: $e");
      return false;
    }
  }

  // LOGOUT
  void logout() {
    _authService.signOut();
    userModel = null;
    notifyListeners();
  }
}
