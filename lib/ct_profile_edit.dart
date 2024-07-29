import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'common.dart';

class CaretakerProfileUpdate extends StatefulWidget {
  final String c_id;
  final Map<String, dynamic> CaretakerDetails;

  CaretakerProfileUpdate({required this.c_id, required this.CaretakerDetails});

  @override
  _CaretakerProfileUpdateState createState() => _CaretakerProfileUpdateState();
}

class _CaretakerProfileUpdateState extends State<CaretakerProfileUpdate> {
   TextEditingController doctorIdController = TextEditingController();
   TextEditingController fullNameController = TextEditingController();
   TextEditingController ageController = TextEditingController();
   TextEditingController sexController = TextEditingController();
   TextEditingController mobileNumberController = TextEditingController();
   TextEditingController qController = TextEditingController();
   TextEditingController addressController = TextEditingController();
   TextEditingController maritalStatusController = TextEditingController();

   @override
   void initState() {
     super.initState();
     // Initialize _nameController with the value from doctorDetails or an empty string if it's null
     fullNameController =
         TextEditingController(text: widget.CaretakerDetails['name'] ?? '');
     ageController =
         TextEditingController(text: widget.CaretakerDetails['age'] ?? '');
     sexController =
         TextEditingController(text: widget.CaretakerDetails['sex'] ?? '');
     mobileNumberController = TextEditingController(
         text: widget.CaretakerDetails['mobile_number'] ?? '');
     qController =
         TextEditingController(text: widget.CaretakerDetails['qualification'] ?? '');
     addressController =
         TextEditingController(text: widget.CaretakerDetails['address'] ?? '');
     maritalStatusController = TextEditingController(
         text: widget.CaretakerDetails['marital_status'] ?? '');
   }

   Future<void> dispCaretakerDetails() async {
     try {
       final response = await http.post(
         Uri.parse(ct_profile),
         body: {
           'c_id': widget.c_id, // Include the doctor ID
           'name': fullNameController.text,
           'age': ageController.text,
           'sex': sexController.text,
           'mobile_number': mobileNumberController.text,
           'qualification': qController.text,
           'address': addressController.text,
           'marital_status': maritalStatusController.text,
         },
       );

       if (response.statusCode == 200) {
         // If the update was successful, pass the updated details back to DoctorProfile page
         Navigator.pop(context, {
           'name': fullNameController.text,
           'age': ageController.text,
           'sex': sexController.text,
           'mobile_number': mobileNumberController.text,
           'qualification': qController.text,
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
              buildTextField("Age", ageController),
              buildTextField("Sex", sexController),
              buildTextField("Mobile Number", mobileNumberController),
              buildTextField("Qualification", qController),
              buildTextField("Address", addressController),
              buildTextField("Marital Status", maritalStatusController),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Call a function to update the doctor details
                    updateCaretakerDetails();
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

   Future<void> updateCaretakerDetails() async {
     try {
       final response = await http.post(
         Uri.parse(ct_profile_edit),
         body: {
           'c_id': widget.c_id, // Include the doctor ID
           'name': fullNameController.text,
           'age': ageController.text,
           'sex': sexController.text,
           'mobile_number': mobileNumberController.text,
           'qualification': qController.text,
           'address': addressController.text,
           'marital_status': maritalStatusController.text,
         },
       );

       if (response.statusCode == 200) {
         // If the update was successful, fetch the updated details
         await dispCaretakerDetails();
         Navigator.pop(context, widget.CaretakerDetails);
       } else {
         print('Failed to update Caretaker details: ${response.statusCode}');
       }
     } catch (e) {
       print('Error updating Caretaker details: $e');
     }
   }

}