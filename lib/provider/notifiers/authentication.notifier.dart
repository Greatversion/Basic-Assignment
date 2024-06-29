import 'package:basic_internship_assignment/services/authServices/auth.services.dart';
import 'package:flutter/material.dart';

class AuthenticationNotifier extends ChangeNotifier {
  final AuthService _authService = AuthService();
  Future<String?> signUp(String email, String password) async {
    await _authService.signUp(email, password);
  }

  Future<String?> signIn(String email, String password) async {
    await _authService.signUp(email, password);
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }
}
