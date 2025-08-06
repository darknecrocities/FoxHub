import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foxhub/services/auth_service.dart';
import 'package:foxhub/models/user_model.dart';


class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? userModel;

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
      final firebaseUser = await _authService.login(email, password); // returns Firebase User?
      if (firebaseUser != null) {
        // fetch extended profile data from Firestore
        final userData = await fetchUserDataFromFirestore(firebaseUser.uid);
        if (userData != null) {
          userModel = UserModel.fromMap(userData);
          userModel!.uid = firebaseUser.uid;
          notifyListeners();
          return true;
        }
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
      final newUser = await _authService.signUp(user, password);
      if (newUser != null) {
        userModel = newUser as UserModel?;  // Store registered user
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print("Register error: $e");
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
