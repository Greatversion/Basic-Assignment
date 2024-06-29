import 'dart:io';

import 'package:basic_internship_assignment/mainScreen.dart';
import 'package:basic_internship_assignment/models/profile.model.dart';
import 'package:basic_internship_assignment/provider/notifiers/authentication.notifier.dart';
import 'package:basic_internship_assignment/routes/routes.name.dart';
import 'package:basic_internship_assignment/utils/colors.dart';
import 'package:basic_internship_assignment/view/screens/app.homeScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Profile Screen
class ProfileScreen extends StatelessWidget {
  final Profile profile;

  ProfileScreen({required this.profile});

  void _navigateToEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditProfileScreen(profile: profile)),
    );
  }

  final SupabaseClient supa = Supabase.instance.client;

  Future<Profile> getProfileById() async {
    final response = await Supabase.instance.client.from('Profile').select();

    final data = response;
    return Profile.fromJson(data.last);
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              authenticationNotifier.signOut().then((value) {
                Navigator.pushReplacementNamed(
                    context, RoutesName.signUpScreen);
              });
            },
            child: const Text("Log Out",
                style: TextStyle(
                  fontFamily: 'ReadexPro',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.buttonText,
                )),
          ),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        title: const Text('Profile',
            style: TextStyle(
              fontFamily: 'ReadexPro',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.buttonText,
            )),
      ),
      body: FutureBuilder<Profile>(
        future: getProfileById(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final details = snapshot.data!;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 65,
                    backgroundImage:
                        CachedNetworkImageProvider(details.photoUrl),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    details.name,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    details.email,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Additional profile details or actions can go here
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _navigateToEditProfile(context),
        tooltip: 'Edit Profile',
        child: const Icon(
          Icons.edit,
          color: AppColors.background,
        ),
      ),
    );
  }
}

// Edit Profile Screen (Placeholder)
class EditProfileScreen extends StatefulWidget {
  final Profile profile;

  EditProfileScreen({required this.profile});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final SupabaseClient supa = Supabase.instance.client;
  final picker = ImagePicker();
  String? _photoPath;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _photoPath = pickedFile.path;
      });
    }
  }

  // Logic to change the profile photo
  Future<void> _uploadDetails() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("wait.."),
      ),
    );
    await supa.storage
        .from('videos')
        .upload('photos/${File(_photoPath!).uri.pathSegments.last}',
            File(_photoPath!))
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Updated.."),
        ),
      );
    }).onError((error, stackTrace) {
      print(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    });

    String photoUrl = supa.storage
        .from('videos')
        .getPublicUrl('photos/${File(_photoPath!).uri.pathSegments.last}');

    final profileDetails = Profile(
        name: _nameController.text,
        email: _emailController.text,
        photoUrl: photoUrl);

    await supa
        .from('Profile') // Replace with your table name
        .insert(profileDetails.toJson());
    // ignore: use_build_context_synchronously
    setState(() {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const MainScreen();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        title: const Text('Edit Profile',
            style: TextStyle(
              fontFamily: 'ReadexPro',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.buttonText,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: _pickPhoto,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.textSecondary,
                  backgroundImage: _photoPath != null
                      ? const CachedNetworkImageProvider(
                          "https://t4.ftcdn.net/jpg/01/64/16/59/360_F_164165971_ELxPPwdwHYEhg4vZ3F4Ej7OmZVzqq4Ov.jpg")
                      : const CachedNetworkImageProvider("url"),
                  child: const Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.camera_alt,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _uploadDetails,
                child: const SizedBox(
                  width: 200,
                  child: Center(
                    child: Text('Save',
                        style: TextStyle(
                          fontFamily: 'ReadexPro',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.buttonText,
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
