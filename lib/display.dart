import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'excercise_video.dart'; // Import the file with the Video class

class VideoPlayerPage extends StatefulWidget {
  final Video video;

  const VideoPlayerPage({Key? key, required this.video}) : super(key: key);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.video.url);
    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (_controller.value.hasError) {
                    return Center(child: Text('Error: ${_controller.value.errorDescription}'));
                  }
                  return Container(
                    color: Colors.black,
                    height: 300, // Fixed height for the video container
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Center(
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                        ),
                        VideoProgressIndicator(_controller, allowScrubbing: true),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: _ControlsOverlay(controller: _controller),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.video.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.video.description,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key? key, required this.controller}) : super(key: key);

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.fast_rewind, color: Colors.white),
            onPressed: () {
              controller.seekTo(controller.value.position - Duration(seconds: 10));
            },
          ),
          IconButton(
            icon: Icon(controller.value.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
            onPressed: () {
              controller.value.isPlaying ? controller.pause() : controller.play();
            },
          ),
          IconButton(
            icon: Icon(Icons.fast_forward, color: Colors.white),
            onPressed: () {
              controller.seekTo(controller.value.position + Duration(seconds: 10));
            },
          ),
          IconButton(
            icon: Icon(controller.value.volume > 0 ? Icons.volume_up : Icons.volume_off, color: Colors.white),
            onPressed: () {
              controller.setVolume(controller.value.volume > 0 ? 0 : 1);
            },
          ),
        ],
      ),
    );
  }
}
