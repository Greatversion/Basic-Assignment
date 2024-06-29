import 'dart:io';

import 'package:basic_internship_assignment/models/profile.model.dart';
import 'package:basic_internship_assignment/models/videoUpload.model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Import your VideoDetails model

class DatabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Insert video details into the database
  Future<void> insertVideoDetails(VideoDetails videoDetails) async {
    final response = await _supabase
        .from('videos') // Replace 'videos' with your table name
        .insert(videoDetails.toJson());

    if (response.error != null) {
      print('Error inserting video: ${response.error!.message}');
    } else {
      print('Video inserted successfully: ${response.data}');
    }
  }

  Future<List<VideoDetails>> fetchAllVideos() async {
    final response = await _supabase
        .from('videos') // Replace 'videos' with your table name
        .select('*');

    List<VideoDetails> videos =
        (response as List).map((data) => VideoDetails.fromJson(data)).toList();

    return videos;
  }

  Future<void> insertProfile(Profile profile) async {
     await _supabase
        .from('Profile') // Replace 'profiles' with your table name
        .insert(profile.toJson());
  
  
  }

  // Fetch all profiles from the database
  Future<Profile> fetchAllProfiles(String email) async {
    final response = await _supabase
            .from('Profile') // Replace with your table name in Supabase
            .select()
            .eq('email', email)
            .single() // Assuming there's only one profile per userId
        ;

    Profile profiles = response[Profile];

    return profiles;
  }
}

class StorageService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Insert video details into the database
  Future<void> insertVideo(VideoDetails videoDetails) async {
    final response = await _supabase
        .from('videos') // Replace 'videos' with your table name
        .insert(videoDetails.toJson());

    if (response.error != null) {
      print('Error inserting video: ${response.error!.message}');
    } else {
      print('Video inserted successfully: ${response.data}');
    }
  }
}
