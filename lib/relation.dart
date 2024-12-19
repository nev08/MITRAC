import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ct_dash.dart';
import 'common.dart';

class CareTakerPatientRelationship extends StatefulWidget {
  final String c_id;

  CareTakerPatientRelationship({required this.c_id});

  @override
  _CareTakerPatientRelationshipState createState() =>
      _CareTakerPatientRelationshipState();
}

class _CareTakerPatientRelationshipState
    extends State<CareTakerPatientRelationship> {
  String? _selectedRelationship;
  TextEditingController _patientIdController = TextEditingController();

  Future<void> sendDataToServer() async {
    // Endpoint URL for PHP script
    var url = Uri.parse(verifyr); // Update with your PHP URL

    // Data to be sent to the server
    var data = jsonEncode({
      'patient_id': _patientIdController.text,
      'relation': _selectedRelationship,
      'c_id': widget.c_id, // Send caretaker ID
    });

    print('Data sent to server: $data');

    // Send POST request to the server
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'}, // Set the content type to JSON
      body: data,
    );

    // Handle response from the server
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print('Relation response: $jsonResponse');

      if (jsonResponse['status'] == 'success') {
        // Verification successful, navigate to the caretaker dashboard
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ct_dash(
              selectedRelationship: _selectedRelationship,
              c_id: widget.c_id,
              patientId: _patientIdController.text,
            ),
          ),
        );
      } else {
        // Show dialog box if verification fails
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Verification Failed'),
              content: Text(jsonResponse['message']),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Show dialog box if an error occurs
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Error: ${response.body}'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                color: Colors.indigo[300],
              ),
              child: Center(
                child: Text(
                  "CareTaker-Patient Relationship",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
                ),
              ),
            ),
            SizedBox(height: 150),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Patient ID      :",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: TextField(
                            controller: _patientIdController,
                            decoration: InputDecoration(
                              hintText: '1234',
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
                    Row(
                      children: [
                        Text(
                          "Relationship :",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: DropdownButton<String>(
                            value: _selectedRelationship,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedRelationship = newValue;
                              });
                            },
                            items: <String?>[
                              'Mother',
                              'Father',
                              'Guardian'
                            ].map((String? value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value ?? ''),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
                    Center(
                      child: ElevatedButton(
                        onPressed: sendDataToServer,
                        child: Text("NEXT -->"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
