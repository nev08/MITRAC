import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:schizo/common.dart';
import 'ct_profile_edit.dart';
import 'patient_profile_edit.dart';

class CaretakerProfile extends StatefulWidget {
  final String c_id;
  final String patient_id;

  CaretakerProfile({required this.c_id, required this.patient_id});

  @override
  _CaretakerProfileState createState() => _CaretakerProfileState();
}

class _CaretakerProfileState extends State<CaretakerProfile> {
  Map<String, dynamic> caretakerDetails = {};
  Map<String, dynamic> patientDetails = {};

  @override
  void initState() {
    super.initState();
    fetchCaretakerDetails();
    fetchPatientDetails();
  }

  Future<void> fetchCaretakerDetails() async {
    try {
      final response = await http.post(
        Uri.parse(ct_profile),
        body: {'c_id': widget.c_id},
      );

      if (response.statusCode == 200) {
        print('Caretaker response body: ${response.body}');
        Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          setState(() {
            caretakerDetails = responseData['data'][0] ?? {};
          });
        } else {
          print(
              'Failed to fetch Caretaker details: ${responseData['message']}');
        }
      } else {
        print('Failed to fetch Caretaker details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching Caretaker details: $e');
    }
  }

  Future<void> fetchPatientDetails() async {
    try {
      final response = await http.post(
        Uri.parse(viewpatient),
        body: {'id': widget.patient_id},
      );

      if (response.statusCode == 200) {
        print('Patient response body: ${response.body}');
        Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          patientDetails = responseData;
        });
      } else {
        print('Failed to fetch Patient details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching Patient details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
                color: Colors.indigo[300],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Center(
                  child: Text(
                    'Caretaker Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            Card(
              elevation: 25,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildCaretakerDetail('CareTaker ID            ', 'c_id'),
                    buildCaretakerDetail('Full Name                 ', 'name'),
                    buildCaretakerDetail(
                        'Age                            ', 'age'),
                    buildCaretakerDetail(
                        'Sex                            ', 'sex'),
                    buildCaretakerDetail(
                        'Mobile Number        ', 'mobile_number'),
                    buildCaretakerDetail(
                        'Qualification            ', 'qualification'),
                    buildCaretakerDetail(
                        'Address                   ', 'address'),
                    buildCaretakerDetail(
                        'Marital Status         ', 'marital_status'),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CaretakerProfileUpdate(
                                        c_id: widget.c_id,
                                        CaretakerDetails: caretakerDetails)),
                          ).then((updatedCaretakerDetails) {
                            if (updatedCaretakerDetails != null) {
                              setState(() {
                                caretakerDetails = updatedCaretakerDetails;
                              });
                            }
                          });
                        },
                        child: Text(
                          'Edit',
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
                color: Colors.indigo[300],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Center(
                  child: Text(
                    'Patient Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            Card(
              elevation: 25,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Placeholder image
                    ClipOval(
                      child: SizedBox(
                        width: 200,
                        // Adjust this value based on your layout
                        height: 200,
                        // Ensure width and height are equal for circular clipping
                        child: Center(
                          child: patientDetails['img1'] != null
                              ? Image.network(
                            ip +'/'+patientDetails['img1'],
                            fit: BoxFit.cover,
                            width: 200,
                            // Adjust this value to match the size of the SizedBox
                            height: 200, // Adjust this value to match the size of the SizedBox
                          )
                              : Icon(
                            Icons.person,
                            size: 100,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    // Patient details
                    buildPatientDetail('Patient ID', 'tx1'),
                    buildPatientDetail('Name', 'tx2'),
                    buildPatientDetail('Age', 'tx3'),
                    buildPatientDetail('Sex', 'tx4'),
                    buildPatientDetail('Education', 'tx5'),
                    buildPatientDetail('Mobile Number', 'tx6'),
                    buildPatientDetail('Address', 'tx7'),
                    buildPatientDetail('Marital Status', 'tx8'),
                    buildPatientDetail('Disease Status', 'tx9'),
                    buildPatientDetail('Duration', 'tx10'),
                    SizedBox(height: 5),
                    // Edit button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PatientProfileUpdate(
                                    patientId: widget.patient_id,
                                    patientDetails: patientDetails, // Pass patient details to PatientProfileUpdate
                                  ),
                            ),
                          );
                        },
                        child: Text('Edit'),
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

  Widget buildCaretakerDetail(String label, String key) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$label: ',
                style: TextStyle(fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              TextSpan(
                text: caretakerDetails[key] ?? 'N/A',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget buildPatientDetail(String label, String key) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Text(
                '   $label     :   ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                patientDetails[key] ?? 'N/A',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
