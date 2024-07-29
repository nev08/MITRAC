import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:schizo/patient_profile_edit.dart';
import 'package:schizo/search_medicine_timings.dart';
import 'package:schizo/Add_patient.dart';
import 'package:schizo/add_videos.dart';
import 'package:schizo/appointment.dart';
import 'package:schizo/doc_profile.dart';
import 'package:schizo/notification.dart';
import 'package:schizo/recently_added_patient_view.dart';
import 'package:schizo/search_view_reasons.dart';
import 'package:schizo/view_ans.dart';
import 'common.dart';

// Your other dependencies and pages imports here

void main() {
  runApp(MyApp(d_id: "your_doctor_id_here"));
}

class MyApp extends StatefulWidget {
  final String d_id;

  MyApp({required this.d_id});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<dynamic> patients = [];

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    final response = await http.post(
      Uri.parse(seeall),
    );

    if (response.statusCode == 200) {
      setState(() {
        patients = jsonDecode(response.body)['patients'];
        // Sort patients by some criteria, for example, by patient ID
        patients.sort((a, b) => b['patient_id'].compareTo(a['patient_id']));
      });
    } else {
      print('Failed to load patients');
    }
  }

  Widget buildProfileImage(String base64Image) {
    if (base64Image == null || base64Image.isEmpty) {
      return CircleAvatar(
        child: Icon(Icons.person),
      );
    } else {
      return CircleAvatar(
        backgroundImage: MemoryImage(
          base64Decode(base64Image),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0), // Adjust as needed
          child: AppBar(
            backgroundColor: Colors.indigo[300],
            elevation: 20,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30), // Adjust as needed
              ),
            ),
            title: Text(
              'Welcome Doctor',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Notifications()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.5),
                    ),
                    child: Icon(
                      Icons.notifications,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DoctorProfile(d_id: widget.d_id)),
                    );
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/doc.png'),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 10,
                  child: Container(
                    width: 360,
                    height: 410,
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => AddPatient()),
                                    );
                                  },
                                  child: Image.asset(
                                    'assets/addpatient.png',
                                    width: 80,
                                    height: 100,
                                  ),
                                ),
                                Text('Add Patient'),
                              ],
                            ),
                            SizedBox(height: 10),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => AddVideosScreen()),
                                    );
                                  },
                                  child: Image.asset(
                                    'assets/vid.png',
                                    width: 80,
                                    height: 100,
                                  ),
                                ),
                                Text('Videos'),
                              ],
                            ),
                            SizedBox(height: 10),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => StatusPage()),
                                    );
                                  },
                                  child: Image.asset(
                                    'assets/medical.png',
                                    width: 80,
                                    height: 100,
                                  ),
                                ),
                                Text('Appointment'),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => SearchViewReasons()),
                                    );
                                  },
                                  child: Image.asset(
                                    'assets/clipboard.png',
                                    width: 75,
                                    height: 100,
                                  ),
                                ),
                                Text('View reasons'),
                              ],
                            ),
                            SizedBox(height: 10),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => SearchAddMedicine()),
                                    );
                                  },
                                  child: Image.asset(
                                    'assets/tab.png',
                                    width: 80,
                                    height: 100,
                                  ),
                                ),
                                Text('Medicine Timings'),
                              ],
                            ),
                            SizedBox(height: 10),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ViewAnswersScreen()),
                                    );
                                  },
                                  child: Image.asset(
                                    'assets/sheet.png',
                                    width: 75,
                                    height: 100,
                                  ),
                                ),
                                Text('View Answers'),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      'Recently added Patients',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 50),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Seeall()),
                        );
                      },
                      child: Text('See All ->'),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                // Display recently added patients in cards
                ...patients.map((patient) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PatientDetailsPage(patientId: patient['patient_id']),
                          ),
                        );
                      },
                      leading: buildProfileImage(patient['img']),
                      title: Text('Patient ${patient['patient_id']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: ${patient['name']}'),
                          Text('Sex: ${patient['sex']}'),
                          Text('Mobile Number: ${patient['mobile_number']}'),
                          // Add other patient details as needed
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
 // Import the PatientProfileUpdate page


class PatientDetailsPage extends StatefulWidget {
  final String patientId;

  PatientDetailsPage({required this.patientId});

  @override
  _PatientDetailsPageState createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  Map<String, dynamic> patientDetails = {};

  @override
  void initState() {
    super.initState();
    fetchPatientDetails();
  }

  Future<void> fetchPatientDetails() async {
    var url = viewpatient;
    var response = await http.post(Uri.parse(url), body: {'id': widget.patientId});

    if (response.statusCode == 200) {
      setState(() {
        patientDetails = jsonDecode(response.body);
      });
    } else {
      // Handle error
      print('Failed to fetch patient details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Card(
          elevation: 5,
          margin: EdgeInsets.all(10),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Placeholder image
                ClipOval(
                  child: SizedBox(
                    width: 200, // Adjust this value based on your layout
                    height: 200, // Ensure width and height are equal for circular clipping
                    child: Center(
                      child: patientDetails['img1'] != null
                          ? Image.network(
                        'http://'+ip+'/app/' + patientDetails['img1'],
                        fit: BoxFit.cover,
                        width: 200, // Adjust this value to match the size of the SizedBox
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
                SizedBox(height: 10),
                // Patient details
                buildRow('Patient ID', patientDetails['tx1']),
                buildRow('Name', patientDetails['tx2']),
                buildRow('Age', patientDetails['tx3']),
                buildRow('Sex', patientDetails['tx4']),
                buildRow('Education', patientDetails['tx5']),
                buildRow('Mobile Number', patientDetails['tx6']),
                buildRow('Address', patientDetails['tx7']),
                buildRow('Marital Status', patientDetails['tx8']),
                buildRow('Disease Status', patientDetails['tx9']),
                buildRow('Duration', patientDetails['tx10']),
                SizedBox(height: 5),
                // Edit button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PatientProfileUpdate(
                            patientId: widget.patientId,
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
      ),
    );
  }

  Widget buildRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 150, // Adjust the width based on your preference
            child: Text(
              '$label',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
          ),
          SizedBox(width: 5),
          Text(
            ':',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(width: 35),
          Expanded(
            child: Text(
              value != null ? value.toString() : 'N/A',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}








