import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart'; // For permissions
import 'add_doc.dart';
import 'common.dart'; // Import the ALogin page
import 'dart:io';
import 'package:http/http.dart' as http;

class ALogin extends StatefulWidget {
  @override
  State<ALogin> createState() => _ALoginState();
}

class _ALoginState extends State<ALogin> {
  bool _isDownloading = false; // Downloading status

  Future<void> downloadCSV(BuildContext context) async {
    setState(() {
      _isDownloading = true;
    });

    // Request storage permission based on Android version
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted == false) {
        await Permission.storage.request();
      }
      if (await Permission.manageExternalStorage.isGranted == false) {
        await Permission.manageExternalStorage.request();
      }
    }

    final String url = '$download'; // Replace $download with the actual URL

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        String? directoryPath = await FilePicker.platform.getDirectoryPath();
        if (directoryPath == null) {
          Fluttertoast.showToast(
            msg: 'No Directory Selected',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
          );
          return;
        }

        String fileName = 'patient_details_${DateTime.now().millisecondsSinceEpoch}.csv';
        String filePath = '$directoryPath/$fileName';
        File file = File(filePath);

        // Ensure file doesn't overwrite if already exists
        int counter = 1;
        while (await file.exists()) {
          fileName = 'patient_details_${DateTime.now().millisecondsSinceEpoch}_$counter.csv';
          filePath = '$directoryPath/$fileName';
          file = File(filePath);
          counter++;
        }

        await file.writeAsBytes(response.bodyBytes);
        print('CSV saved at: $filePath');

        Fluttertoast.showToast(
          msg: 'Saved Successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Error Downloading CSV',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      }
    } catch (e) {
      print('Error occurred: $e');
      Fluttertoast.showToast(
        msg: 'An error occurred',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    } finally {
      setState(() {
        _isDownloading = false; // Reset the downloading status
      });
    }
  }

  void _showDownloadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Download CSV'),
          content: Text('Do you want to download all the patient details?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                downloadCSV(context); // Call the function to download the CSV
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Wrap content in SingleChildScrollView
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg2.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100.0),
              Center(
                child: Container(
                  width: 350.0,
                  height: 450.0,
                  margin: EdgeInsets.only(top: 40.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.grey[300],
                    border: Border.all(
                      color: Colors.black!,
                      width: 2.0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showDownloadDialog(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _isDownloading
                              ? CircularProgressIndicator() // Show loading indicator if downloading
                              : Image.asset(
                            'assets/download.png',
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Placeholder for a tap action
                        },
                        child: Image.asset(
                          'assets/young.png',
                          width: 120,
                          height: 120,
                        ),
                      ),
                      SizedBox(height: 40), // Added SizedBox for spacing
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Adddoctor()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                        ),
                        child: Text('Add Doctor', style: TextStyle(fontSize: 20)),
                      ),
                      SizedBox(height: 30), // Added SizedBox for spacing
                    ],
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
