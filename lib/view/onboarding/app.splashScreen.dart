import 'dart:async';
import 'package:basic_internship_assignment/routes/routes.name.dart';
import 'package:basic_internship_assignment/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  User? _currentUser;
  @override
  void initState() {
    super.initState();
    _currentUser = supabase.auth.currentUser;
    if (_currentUser == null) {
      Timer(const Duration(seconds: 3), () {
        Navigator.of(context).pushReplacementNamed(RoutesName.signUpScreen);
      });
    } else {
      Timer(const Duration(seconds: 3), () {
        Navigator.of(context).pushReplacementNamed(RoutesName.mainScreen);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height:200 ,
              child: Image.asset("assets/youtube_logo.png")),
            const Text(
              'BASIC',
              style: TextStyle(
                fontFamily: 'ReadexPro',
                fontWeight: FontWeight.bold,
                fontSize: 80,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
