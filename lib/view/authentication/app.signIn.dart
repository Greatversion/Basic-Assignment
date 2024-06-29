// lib/views/auth/login_screen.dart

import 'package:basic_internship_assignment/provider/notifiers/authentication.notifier.dart';
import 'package:basic_internship_assignment/routes/routes.name.dart';
import 'package:basic_internship_assignment/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Importing the signup screen for navigation

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    final AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);

    // ValueNotifier to manage loading state
    ValueNotifier<bool> _isLoading = ValueNotifier(false);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: AppColors.primary,
        title: const Text(
          'Youtube',
          style: TextStyle(
            fontFamily: 'ReadexPro',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.buttonText,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontFamily: 'ReadexPro',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(
                    color: AppColors.textSecondary,
                    fontFamily: 'ReadexPro',
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                cursorColor: AppColors.primary,
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(
                    color: AppColors.textSecondary,
                    fontFamily: 'ReadexPro',
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                cursorColor: AppColors.primary,
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    // Handle forgot password action
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontFamily: 'ReadexPro',
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _isLoading,
                    builder: (context, isLoading, child) {
                      return ElevatedButton(
                        onPressed: isLoading
                            ? null // Disable button if loading
                            : () async {
                                _isLoading.value = true;

                                // Check if email and password fields are not empty
                                if (_emailController.text.isNotEmpty &&
                                    _passwordController.text.isNotEmpty) {
                                  // Perform sign-up
                                  await authenticationNotifier
                                      .signIn(_emailController.text,
                                          _passwordController.text)
                                      .then((value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Logging in..."),
                                      ),
                                    );
                                    Navigator.pushReplacementNamed(
                                        context, RoutesName.mainScreen);
                                  }).onError((error, stackTrace) {
                                    print(error.toString());
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(error.toString()),
                                      ),
                                    );
                                  });
                                } else {
                                  // Show error message if password doesn't match confirm password
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Passwords do not match or fields are empty"),
                                    ),
                                  );
                                }

                                _isLoading.value = false;
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: AppColors.buttonText,
                              )
                            : const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontFamily: 'ReadexPro',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.buttonText,
                                ),
                              ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to login screen
                      Navigator.pushNamed(context, RoutesName.signUpScreen);
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
