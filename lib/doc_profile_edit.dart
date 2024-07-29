import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'common.dart';

class DoctorProfileUpdate extends StatefulWidget {
  final String d_id;
  final Map<String, dynamic> doctorDetails;

  DoctorProfileUpdate({required this.d_id, required this.doctorDetails});

  @override
  _DoctorProfileUpdateState createState() => _DoctorProfileUpdateState();
}

class _DoctorProfileUpdateState extends State<DoctorProfileUpdate> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController sexController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController specializationController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController maritalStatusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize _nameController with the value from doctorDetails or an empty string if it's null
    fullNameController =
        TextEditingController(text: widget.doctorDetails['name'] ?? '');
    designationController =
        TextEditingController(text: widget.doctorDetails['designation'] ?? '');
    sexController =
        TextEditingController(text: widget.doctorDetails['sex'] ?? '');
    mobileNumberController = TextEditingController(
        text: widget.doctorDetails['mobile_number'] ?? '');
    emailController =
        TextEditingController(text: widget.doctorDetails['email'] ?? '');
    specializationController = TextEditingController(
        text: widget.doctorDetails['specialization'] ?? '');
    addressController =
        TextEditingController(text: widget.doctorDetails['address'] ?? '');
    maritalStatusController = TextEditingController(
        text: widget.doctorDetails['marital_status'] ?? '');
  }

  Future<void> dispDoctorDetails() async {
    try {
      final response = await http.post(
        Uri.parse(doc_profile_edit),
        body: {
          'd_id': widget.d_id, // Include the doctor ID
          'name': fullNameController.text,
          'designation': designationController.text,
          'sex': sexController.text,
          'mobile_number': mobileNumberController.text,
          'email': emailController.text,
          'specialization': specializationController.text,
          'address': addressController.text,
          'marital_status': maritalStatusController.text,
        },
      );

      if (response.statusCode == 200) {
        // If the update was successful, pass the updated details back to DoctorProfile page
        Navigator.pop(context, {
          'name': fullNameController.text,
          'designation': designationController.text,
          'sex': sexController.text,
          'mobile_number': mobileNumberController.text,
          'email': emailController.text,
          'specialization': specializationController.text,
          'address': addressController.text,
          'marital_status': maritalStatusController.text,
        });
      } else {
        print('Failed to update doctor details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating doctor details: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Doctor Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField("Full Name", fullNameController),
              buildTextField("Designation", designationController),
              buildTextField("Sex", sexController),
              buildTextField("Mobile Number", mobileNumberController),
              buildTextField("Email", emailController),
              buildTextField("Specialization", specializationController),
              buildTextField("Address", addressController),
              buildTextField("Marital Status", maritalStatusController),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Call a function to update the doctor details
                    updateDoctorDetails();
                  },
                  child: Text('Update Details'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Future<void> updateDoctorDetails() async {
    try {
      final response = await http.post(
        Uri.parse(doc_profile_edit),
        body: {
          'd_id': widget.d_id, // Include the doctor ID
          'name': fullNameController.text,
          'designation': designationController.text,
          'sex': sexController.text,
          'mobile_number': mobileNumberController.text,
          'email': emailController.text,
          'specialization': specializationController.text,
          'address': addressController.text,
          'marital_status': maritalStatusController.text,
        },
      );

      if (response.statusCode == 200) {
        // If the update was successful, fetch the updated details
        await dispDoctorDetails();
        Navigator.pop(context, widget.doctorDetails);
      } else {
        print('Failed to update doctor details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating doctor details: $e');
    }
  }

}