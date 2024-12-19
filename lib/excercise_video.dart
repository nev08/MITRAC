import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'common.dart';
import 'display.dart';

class DisplayVideos extends StatefulWidget {
  @override
  _DisplayVideosState createState() => _DisplayVideosState();
}

class _DisplayVideosState extends State<DisplayVideos> {
  late Future<List<Video>> _videos;

  @override
  void initState() {
    super.initState();
    _videos = fetchVideos();
  }

  Future<List<Video>> fetchVideos() async {
    final response = await http.post(Uri.parse(dispvid));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> videosJson = data['videos'];
      List<Video> videos = videosJson.map((video) => Video.fromJson(video)).toList();

      return videos;
    } else {
      throw Exception('Failed to load videos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[300],
        title: Text('Videos'),
      ),
      body: FutureBuilder<List<Video>>(
        future: _videos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No videos found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final video = snapshot.data![index];
                return ListTile(
                  leading: SizedBox(
                    width: 100,
                    height: 56,
                    child: video.thumbnail != null && video.thumbnail!.isNotEmpty
                        ? Image.network(
                      video.thumbnail!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/vid2.png'); // Single slash
                      },
                    )
                        : Image.asset('assets/vid2.png'), // Single slash
                  ),
                  title: Text(video.title),
                  subtitle: Text(video.description),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerPage(video: video),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class Video {
  final String url;
  final String title;
  final String description;
  final String? thumbnail;

  Video({
    required this.url,
    required this.title,
    required this.description,
    this.thumbnail,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      url: json['url'] ?? '',
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      thumbnail: json['thumbnail'],
    );
  }
}
