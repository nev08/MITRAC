import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'admin_login.dart';
import 'package:flutter/cupertino.dart';
import 'common.dart';


class ALogin extends StatefulWidget {
  @override
  State<ALogin> createState() => _ALoginState();
}

class _ALoginState extends State<ALogin> {
  bool _isDownloading = false;

  Future<void> downloadCSV(BuildContext context) async {
    setState(() {
      _isDownloading = true;
    });
    final String url = '$download';
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
        _isDownloading = false;
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double cardWidth = screenWidth * 0.8;
    double cardHeight = screenHeight * 0.58;
    double buttonWidth = cardWidth * 0.75;
    double buttonHeight = screenHeight * 0.07;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminLoginPage()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xfffddbdc),
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminLoginPage()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 25,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            GestureDetector(
              onTap: () {
                _showDownloadDialog(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/bell.png',
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ],
        ),
        body: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Container(
              width: cardWidth,
              height: cardHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/pinky.png',
                    width: 250,
                    height: 250,
                  ),
                  SizedBox(height: 20),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        backgroundColor: Color(0xfffddbdc),
      ),
    );
  }
}