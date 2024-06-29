import 'package:basic_internship_assignment/models/videoUpload.model.dart';
import 'package:basic_internship_assignment/routes/routes.name.dart';
import 'package:basic_internship_assignment/services/authServices/auth.services.dart';
import 'package:basic_internship_assignment/utils/colors.dart';
import 'package:basic_internship_assignment/view/screens/app.videoScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VideoCard extends StatelessWidget {
  final VideoDetails video;

  const VideoCard({Key? key, required this.video}) : super(key: key);

  Future<String> getUserEmailById(String email) async {
    try {
      final response = await Supabase.instance.client
          .from('Profile') // Replace with your users table name
          .select('name') // Select the email column
          .eq('email', email) // Filter by userId or identifier for uploader
          .single(); // Fetch a single row

      final data = response;
      return data['name'] as String;
    } catch (e) {
      print('Error fetching user email: $e');
      return ''; // Return empty string or handle error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: AppColors.textSecondary,
      color: AppColors.background,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return VideoScreen(video: video);
              }));
            },
            child: CachedNetworkImage(
              imageUrl: video.thumbnailUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      video.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.more_vert_rounded)
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${video.description} • 10K views • Public',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                FutureBuilder<String>(
                  future: getUserEmailById(supabaseClient
                      .auth.currentUser!.email!), // Pass userId here
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text(
                        'Viewed By : Loading...', // Placeholder while loading
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Text(
                        'Viewed By : Error', // Error state
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      );
                    } else {
                      final userEmail = snapshot.data ??
                          'Unknown'; // Default value if data is null
                      return Text(
                        'Viewed By : $userEmail',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
