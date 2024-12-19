import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'common.dart';

class AddVideosScreen extends StatefulWidget {
  @override
  _AddVideosScreenState createState() => _AddVideosScreenState();
}

class _AddVideosScreenState extends State<AddVideosScreen> {
  File? videoFile; // Initialize videoFile as nullable
  String? videoFileName; // Initialize videoFileName as nullable
  TextEditingController titleController = TextEditingController(); // Controller for title text field
  TextEditingController descriptionController = TextEditingController(); // Controller for description text field

  Future<void> uploadVideo(File? videoFile) async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      // Show error message or handle empty fields as desired
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter title and description'),
        ),
      );
      return;
    }

    var request = http.MultipartRequest('POST', Uri.parse(addvid));

    if (videoFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'uploaded_file',
          videoFile.path,
        ),
      );
    } else {
      // Handle case where videoFile is null (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a video first.'),
        ),
      );
      return;
    }

    request.fields['title'] = titleController.text;
    request.fields['description'] = descriptionController.text;

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Video uploaded successfully');

      // Clear fields and reset state after successful upload
      setState(() {
        videoFile = null;
        videoFileName = null;
        titleController.clear();
        descriptionController.clear();
      });

      // Show Snackbar indicating success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Video uploaded successfully'),
        ),
      );

      // Show dialog to confirm upload
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Video Uploaded'),
          content: Text('The selected video has been uploaded.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      print('Error uploading video: ${response.reasonPhrase}');
      // Handle error cases as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  color: Colors.indigo[300], // You can replace this with your color
                ),
                child: Center(
                  child: Text(
                    'Videos Selection',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 150, // Set a fixed height for the description box
                      child: TextField(
                        controller: descriptionController,
                        maxLines: null, // Allows the text field to grow as user types
                        expands: true, // Allows the text field to fill the container
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        final picker = ImagePicker();
                        final pickedFile = await picker.pickVideo(source: ImageSource.gallery);


                        if (pickedFile != null) {
                          setState(() {
                            videoFile = File(pickedFile.path);
                            videoFileName = videoFile!.path.split('/').last;
                          });
                        }
                      },
                      child: Image.asset(
                        'assets/selection.png',
                        width: 100,
                        height: 120,
                      ),
                    ),
                    Text('Select Video'),
                    SizedBox(height: 10),
                    if (videoFileName != null)
                      Text(
                        videoFileName!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    SizedBox(height: 40),
                    GestureDetector(
                      onTap: () {
                        uploadVideo(videoFile);
                      },
                      child: Image.asset(
                        'assets/arrow.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Upload Video'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AddVideosScreen(),
  ));
}
