import 'package:basic_internship_assignment/mainScreen.dart';
import 'package:basic_internship_assignment/routes/routes.name.dart';
import 'package:basic_internship_assignment/view/onboarding/app.splashScreen.dart';
import 'package:basic_internship_assignment/view/authentication/app.signIn.dart';
import 'package:basic_internship_assignment/view/authentication/app.signUp.dart';
import 'package:basic_internship_assignment/view/profile/app.profileScreen.dart';
import 'package:basic_internship_assignment/view/screens/app.videoScreen.dart';

import 'package:flutter/material.dart';

class AppRoutes {
  static Route<dynamic>? generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splashScreen:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      case RoutesName.signUpScreen:
        return MaterialPageRoute(
          builder: (context) => const SignUpScreen(),
        );
      case RoutesName.signInScreen:
        return MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        );
      case RoutesName.mainScreen:
        return MaterialPageRoute(
          builder: (context) => const MainScreen(),
        );
      //  case RoutesName.profileScreen:
      // return MaterialPageRoute(
      //   builder: (context) => ProfileScreen(),
      // );
      //   case RoutesName.videoScreen:
      // return MaterialPageRoute(
      //   builder: (context) =>  const VideoScreen(video: null,),
      // );
    }
    return MaterialPageRoute(
      builder: (context) => const SplashScreen(),
    );
  }
}
