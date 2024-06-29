import 'package:basic_internship_assignment/services/authServices/auth.credentials.dart';
import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
final SupabaseClient supabaseClient = Supabase.instance.client;
class AuthService {
  
  // ignore: prefer_typing_uninitialized_variables

  Future<String?> signUp(String email, String password) async {
    try {
      AuthResponse authResponse = await supabaseClient.auth
          .signUp(email: email, password: password);

     final userEmail = authResponse.user!.email;
      return userEmail;
    } on AuthApiException catch (e) {
      print(e);
    }
    return null;
  }

  Future<String?> signIn(String email, String password) async {
    try {
      AuthResponse authResponse =
          await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (authResponse.user != null) {
      final  userEmail = authResponse.user!.email;
        return userEmail;
      }
    } on AuthException catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
    } on AuthException catch (e) {
      print(e);
    }
  }
}
