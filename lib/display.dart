import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'excercise_video.dart'; // Assuming this contains the Video class

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
        backgroundColor: Colors.indigo[300], // Soft indigo for a classic touch
        title: Text('Execrcise Video', style: TextStyle( color: Colors.black)),
        centerTitle: true, // Centered title for a clean look
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
                    print("not working");
                    return Center(child: Text('Error: ${_controller.value.errorDescription}'));
                  }
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15), // Rounded corners for the video section
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10, // Subtle shadow for depth
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.all(16), // Margin for proper spacing
                    height: 300, // Fixed height for the video container
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            ),
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.video.title,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[900], // Darker indigo for a classic contrast
                    ),
                  ),
                  SizedBox(height: 12), // Space between title and description
                  Text(
                    widget.video.description,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5, // Line height for better readability
                      color: Colors.black87,
                    ),
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
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.black54, // Semi-transparent background
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ), // Match video corner radius
      ),
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
