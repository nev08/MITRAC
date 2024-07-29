import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'common.dart';
import 'ct_dash.dart';

class ReasonsScreen extends StatefulWidget {
  final String? selectedRelationship;
  final String patientId;
  final String c_id;

  const ReasonsScreen({Key? key, this.selectedRelationship,required this.patientId, required this.c_id}) : super(key: key);

  @override
  _ReasonsScreenState createState() => _ReasonsScreenState();
}

class _ReasonsScreenState extends State<ReasonsScreen> {
  final TextEditingController _reasonsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 80.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                  color: Colors.indigo[300],
                ),
                child: Center(
                  child: Text(
                    'Reasons',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Padding(
                padding: EdgeInsets.only(left: 20.0),

              ),
              SizedBox(height: 30.0),
              Card(
                elevation: 30.0,
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 450.0,
                  padding: EdgeInsets.all(20.0),
                  child: TextField(
                    controller: _reasonsController,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Reasons Here',
                      hintStyle: TextStyle(fontSize: 20.0),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 20.0),
                    maxLines: null,
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {
                  saveReasons();
                },
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveReasons() async {
    final reasons = _reasonsController.text;
    final patientId = widget.patientId;

    final response = await http.post(
      Uri.parse(dres),
      body: {
        'reasons': reasons,
        'patient_id': patientId!,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['status'] == 'success') {
        // Handle success
        print('Reasons saved successfully');
        // Navigate to CT Dash screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ct_dash(
            selectedRelationship: widget.selectedRelationship,
            c_id: widget.c_id,
            patientId: widget.patientId,
          ),),
        );
      } else {
        // Handle error
        print('Failed to save reasons: ${responseData['message']}');
      }
    } else {
      // Handle network error
      print('Network error: ${response.statusCode}');
    }
  }
}
