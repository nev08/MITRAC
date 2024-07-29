import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PatientProfileUpdate extends StatefulWidget {
  final String patientId;
  final Map<String, dynamic> patientDetails;

  PatientProfileUpdate({required this.patientId, required this.patientDetails});

  @override
  _PatientProfileUpdateState createState() => _PatientProfileUpdateState();
}

class _PatientProfileUpdateState extends State<PatientProfileUpdate> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController sexController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController educationController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController maritalStatusController = TextEditingController();
  TextEditingController diseaseStatusController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Populate text controllers with existing data
    nameController.text = widget.patientDetails['tx2'];
    ageController.text = widget.patientDetails['tx3'];
    sexController.text = widget.patientDetails['tx4'];
    mobileNumberController.text = widget.patientDetails['tx6'];
    educationController.text = widget.patientDetails['tx5'];
    addressController.text = widget.patientDetails['tx7'];
    maritalStatusController.text = widget.patientDetails['tx8'];
    diseaseStatusController.text = widget.patientDetails['tx9'];
    durationController.text = widget.patientDetails['tx10'];
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Patient Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField('Name', nameController),
              buildTextField('Age', ageController),
              buildTextField('Sex', sexController),
              buildTextField('Mobile Number', mobileNumberController),
              buildTextField('Education', educationController),
              buildTextField('Address', addressController),
              buildTextField('Marital Status', maritalStatusController),
              buildTextField('Disease Status', diseaseStatusController),
              buildTextField('Duration', durationController),
              SizedBox(height: 20),
              // Submit button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    updatePatientDetails();
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updatePatientDetails() async {
    String name = nameController.text;
    String age = ageController.text;
    String sex = sexController.text;
    String mobileNumber = mobileNumberController.text;
    String education = educationController.text;
    String address = addressController.text;
    String maritalStatus = maritalStatusController.text;
    String diseaseStatus = diseaseStatusController.text;
    String duration = durationController.text;

    // Make HTTP request to update patient details
    var url = 'http://172.18.73.27:80/app/update_patient_profile.php';
    var response = await http.post(Uri.parse(url), body: {
      'patient_id': widget.patientId,
      'name': name,
      'age': age,
      'sex': sex,
      'mobile_number': mobileNumber,
      'education': education,
      'address': address,
      'marital_status': maritalStatus,
      'disease_status': diseaseStatus,
      'duration': duration,
    });

    if (response.statusCode == 200) {
      // Handle success
      Navigator.pop(context); // Navigate back to previous page
    } else {
      // Handle error
      print('Failed to update patient details');
    }
  }
}
