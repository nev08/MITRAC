import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'doc_profile_edit.dart';
import 'common.dart';

class DoctorProfile extends StatefulWidget {
  final String d_id;

  DoctorProfile({required this.d_id});

  @override
  _DoctorProfileState createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  Map<String, dynamic> doctorDetails = {};

  @override
  void initState() {
    super.initState();
    fetchDoctorDetails();
  }

  Future<void> fetchDoctorDetails() async {
    try {
      final response = await http.post(
        Uri.parse(doc_profile),
        body: {'d_id': widget.d_id},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status']) {
          setState(() {
            doctorDetails = responseData['doctorDetails'] ?? {};
          });
        } else {
          print('Failed to fetch doctor details: ${responseData['message']}');
        }
      } else {
        print('Failed to fetch doctor details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching doctor details: $e');
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
                    'Doctor Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
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
                    ClipOval(
                      child: SizedBox(
                        width: 150, // Adjust this value based on your layout
                        height: 150, // Ensure width and height are equal for circular clipping
                        child: Center(
                          child: doctorDetails['img'] != null && doctorDetails['img'].isNotEmpty
                              ? Image.network(
                            ip+"/"+ doctorDetails['img'],
                            fit: BoxFit.cover,
                          )
                              : Icon(
                            Icons.person,
                            size: 100,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Align details to start
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildDoctorDetail('Doctor ID                 ', 'd_id'),
                          buildDoctorDetail('Full Name                ', 'name'),
                          buildDoctorDetail('Designation             ', 'designation'),
                          buildDoctorDetail('Sex                            ', 'sex'),
                          buildDoctorDetail('Mobile Number       ', 'mobile_number'),
                          buildDoctorDetail('Email                        ', 'email'),
                          buildDoctorDetail('Specialization         ', 'specialization'),
                          buildDoctorDetail('Address                   ', 'address'),
                          buildDoctorDetail('Marital Status         ', 'marital_status'),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorProfileUpdate(
                                d_id: widget.d_id,
                                doctorDetails: doctorDetails,
                              ),
                            ),
                          ).then((updatedDoctorDetails) {
                            // Check if updatedDoctorDetails is not null
                            if (updatedDoctorDetails != null) {
                              // Update doctorDetails with the updated details
                              setState(() {
                                doctorDetails = updatedDoctorDetails;
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
          ],
        ),
      ),
    );
  }

  Widget buildDoctorDetail(String label, String key) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0),
      child: Text(
        '$label: ${doctorDetails[key] ?? 'N/A'}',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }
}
