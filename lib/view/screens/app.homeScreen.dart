import 'package:basic_internship_assignment/services/authServices/auth.services.dart';
import 'package:basic_internship_assignment/view/videos/app.videoCard.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:basic_internship_assignment/models/videoUpload.model.dart';
import 'package:basic_internship_assignment/services/database/app.databaseService.dart';
import 'package:basic_internship_assignment/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService databaseService = DatabaseService();
  late Future<List<VideoDetails>> _videosFuture;
  var _picUrl = '';
  @override
  void initState() {
    super.initState();

    getUserPicByEmail(supa.auth.currentUser!.email!);
    _loadVideos(); // Load videos when the screen initializes
  }

  void _loadVideos() {
    setState(() {
      _videosFuture = databaseService.fetchAllVideos();
    });
  }

  getUserPicByEmail(String email) async {
    // Perform the query to select the 'name' column for a specific email
    final response = await supa
        .from('Profile') // Specify the table name
        .select('photoUrl') // Select the 'name' column
        .eq('email', email) // Filter rows where 'email' matches
        .single(); // Fetch only a single row matching the filter

    // Extract the 'name' from the response
    setState(() {
      _picUrl = response['photoUrl'];
    });

    // print(data['photoUrl'])
  }

  // Function to add a sample video

  SupabaseClient supa = Supabase.instance.client;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          const Icon(Icons.trending_up, color: Colors.white),
          const SizedBox(width: 15),
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(_picUrl),
          ),
          const SizedBox(width: 10)
        ],
        title: const Text(
          'Youtube BASIC',
          style: TextStyle(
            fontFamily: 'ReadexPro',
            fontSize: 24,
            color: AppColors.buttonText,
          ),
        ),
        backgroundColor: Colors.red,
      ),
      body: FutureBuilder<List<VideoDetails>>(
        future: _videosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No videos found'));
          } else {
            final videos = snapshot.data!;
            return ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                return VideoCard(video: video);
              },
            );
          }
        },
      ),
    );
  }
}
