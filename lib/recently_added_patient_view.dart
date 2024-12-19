import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'common.dart';
import 'package:schizo/patient_profile_edit.dart';


class Seeall extends StatefulWidget {
  const Seeall({Key? key}) : super(key: key);

  @override
  _SeeallState createState() => _SeeallState();
}

class _SeeallState extends State<Seeall> {
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> filteredPatients = [];
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    fetchData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.post(
        Uri.parse(searchpatient),
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          data = List<Map<String, dynamic>>.from(jsonData);
          filteredPatients = List.from(data);
          // Sort patients by some criteria, for example, by patient ID
          filteredPatients.sort((a, b) => b['patient_id'].compareTo(a['patient_id']));
        });
      } else {
        print('Failed to load patients');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Widget buildProfileImage(String? base64Image) {
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

  void _onSearchChanged() {
    setState(() {
      filteredPatients = data.where((patient) =>
      patient['patient_id']!.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          patient['name']!.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          patient['sex']!.toLowerCase().contains(_searchController.text.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Patients List',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Set the text color to white
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.indigo[300],
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Patient id',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              ),
            ),
          ),
          SizedBox(height: 15),
          // Display recently added patients in cards
          Expanded(
            child: ListView.builder(
              itemCount: filteredPatients.length,
              itemBuilder: (context, index) {
                final patient = filteredPatients[index];
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
                        //Text('Mobile Number: ${patient['mobile_number']}'),
                        // Add other patient details as needed
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
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
        title: Text(
          'Patients Details',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Set the text color to white
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.indigo[300],
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
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
                        ip +"/"+ patientDetails['img1'],
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
