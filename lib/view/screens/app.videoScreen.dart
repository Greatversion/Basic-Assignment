import 'package:basic_internship_assignment/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:basic_internship_assignment/models/videoUpload.model.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoScreen extends StatefulWidget {
  final VideoDetails video;

  const VideoScreen({required this.video, Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();

    // Initialize the VideoPlayerController with the network URL
    _videoPlayerController =
        VideoPlayerController.network(widget.video.videoUrl)
          ..initialize().then((_) {
            // Once the video is initialized, update the state to refresh the UI
            setState(() {});

            // Initialize the ChewieController with the VideoPlayerController
            _chewieController = ChewieController(
              videoPlayerController: _videoPlayerController,
              aspectRatio: _videoPlayerController.value.aspectRatio,
              autoPlay: true,
              looping: true,
              // Additional options for customization
              errorBuilder: (context, errorMessage) {
                return Center(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
              // Customizing the placeholder when the video is loading or buffering
              placeholder: Container(
                color: Colors.black,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          });
  }

  @override
  void dispose() {
    // Dispose both controllers when the widget is disposed
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.video.title,
          style: TextStyle(
            fontFamily: 'ReadexPro',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.buttonText,
          ),
        ),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: _chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized
            ? Chewie(
                controller: _chewieController!,
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
