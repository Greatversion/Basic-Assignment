import 'dart:io';
import 'package:basic_internship_assignment/models/videoUpload.model.dart';
import 'package:basic_internship_assignment/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VideoUploadScreen extends StatefulWidget {
  const VideoUploadScreen({Key? key}) : super(key: key);

  @override
  _VideoUploadScreenState createState() => _VideoUploadScreenState();
}

class _VideoUploadScreenState extends State<VideoUploadScreen> {
  final picker = ImagePicker();
  String? _thumbnailPath;
  String? _videoPath;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> _pickThumbnail() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _thumbnailPath = pickedFile.path;
      });
    }
  }

  Future<void> _pickVideo() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null) {
      setState(() {
        _videoPath = result.files.single.path;
      });
    }
  }

  Future<void> _uploadToSupabase() async {
    if (_videoPath == null || _thumbnailPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select both a video and a thumbnail')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Uploading..."),
      ),
    );

    final storage = Supabase.instance.client.storage
        .from('videos'); // Ensure 'videos' is your storage bucket name
    String? thumbnailUrl;
    String? videoUrl;

    try {
      // Upload the thumbnail
      final thumbnailFile = File(_thumbnailPath!);
      final thumbnailFileName =
          'thumbnails/${thumbnailFile.uri.pathSegments.last}';
      final thumbnailUploadResponse =
          await storage.upload(thumbnailFileName, thumbnailFile);

      // Ensure the URL is correctly formed
      thumbnailUrl = storage.getPublicUrl(thumbnailFileName);
      print('Thumbnail URL: $thumbnailUrl');

      // Upload the video
      final videoFile = File(_videoPath!);
      final videoFileName = 'videos/${videoFile.uri.pathSegments.last}';
      final videoUploadResponse =
          await storage.upload(videoFileName, videoFile);

      // Ensure the URL is correctly formed
      videoUrl = storage.getPublicUrl(videoFileName);
      print('Video URL: $videoUrl');

      // Save the metadata to the Supabase database
      final videoDetails = VideoDetails(
        title: _titleController.text,
        description: _descriptionController.text,
        thumbnailUrl: thumbnailUrl!,
        videoUrl: videoUrl!,
      );

      await Supabase.instance.client
          .from('videos') // Replace with your table name
          .insert(videoDetails.toJson());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Files uploaded and metadata saved successfully!')),
      );

      // Clear fields after successful upload
      setState(() {
        _thumbnailPath = null;
        _videoPath = null;
        _titleController.clear();
        _descriptionController.clear();
      });
    } catch (e) {
      print('Error uploading files: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Upload Details',
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
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontFamily: 'ReadexPro',
                  ),
                ),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontFamily: 'ReadexPro',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _pickThumbnail,
                    child: const Text(
                      'Pick Thumbnail',
                      style: TextStyle(
                        fontFamily: 'ReadexPro',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.buttonText,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _pickVideo,
                    child: const Text(
                      'Pick Video',
                      style: TextStyle(
                        fontFamily: 'ReadexPro',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.buttonText,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _uploadToSupabase,
                child: const Text(
                  'Upload',
                  style: TextStyle(
                    fontFamily: 'ReadexPro',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.buttonText,
                  ),
                ),
              ),
              if (_thumbnailPath != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Thumbnail selected: $_thumbnailPath'),
                ),
              if (_videoPath != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Video selected: $_videoPath'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
