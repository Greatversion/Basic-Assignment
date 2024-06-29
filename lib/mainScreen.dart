import 'package:basic_internship_assignment/models/profile.model.dart';
import 'package:basic_internship_assignment/utils/colors.dart';
import 'package:basic_internship_assignment/view/profile/app.profileScreen.dart';
import 'package:basic_internship_assignment/view/screens/app.homeScreen.dart';
import 'package:basic_internship_assignment/view/screens/app.videoUploadScreen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers

    List<Widget> screens = [
      HomeScreen(),
      const VideoUploadScreen(),
      ProfileScreen(
        profile: Profile(name: "Guest", email: "email", photoUrl: "photoUrl"),
      ),
    ];
    List<BottomNavigationBarItem> bottomItems = [
      const BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
      const BottomNavigationBarItem(
          label: 'Upload', icon: Icon(Icons.add_circle_outline_sharp)),
      const BottomNavigationBarItem(label: 'Profile', icon: Icon(Icons.person)),
    ];
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.buttonBackground,
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        items: bottomItems,
      ),
    );
  }
}
