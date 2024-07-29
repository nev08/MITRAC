import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'common.dart';

class AddPatient extends StatefulWidget {
  final double borderWidth;
  final double padding;

  const AddPatient({Key? key, this.borderWidth = 1.0, this.padding = 10.0})
      : super(key: key);

  @override
  _AddPatientState createState() => _AddPatientState();
}

class _AddPatientState extends State<AddPatient> {
  final _formKey = GlobalKey<FormState>();
  File? _image;

  final _picker = ImagePicker();
  final TextEditingController _caretakerIdController = TextEditingController();
  final TextEditingController _caretakerNameController = TextEditingController();
  final TextEditingController _caretakerPasswordController = TextEditingController();
  final TextEditingController _caretakerAgeController = TextEditingController();
  final TextEditingController _caretakerSexController = TextEditingController();
  final TextEditingController _caretakerMobileNumberController = TextEditingController();
  final TextEditingController _caretakerQualificationController = TextEditingController();
  final TextEditingController _caretakerAddressController = TextEditingController();
  final TextEditingController _caretakerMaritalStatusController = TextEditingController();
  final TextEditingController _caretakerRelationshipController = TextEditingController();

  final TextEditingController _patientIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _maritalStatusController = TextEditingController();
  final TextEditingController _diseaseStatusController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text('Take a photo'),
                  onTap: () async {
                    Navigator.pop(context);
                    try {
                      final pickedImage = await _picker.pickImage(source: ImageSource.camera);
                      if (pickedImage != null) {
                        setState(() {
                          _image = File(pickedImage.path);
                        });
                      }
                    } catch (e) {
                      print('Error picking image from camera: $e');
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.image),
                  title: Text('Choose from gallery'),
                  onTap: () async {
                    Navigator.pop(context);
                    try {
                      final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
                      if (pickedImage != null) {
                        setState(() {
                          _image = File(pickedImage.path);
                        });
                      }
                    } catch (e) {
                      print('Error picking image from gallery: $e');
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label       :',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Enter $label',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter $label';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _saveCaretakerFormData();
      _savePatientFormData();
      _saveRelationData(); // Save relation data
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all required fields.'),
        ),
      );
    }
  }

  void _saveCaretakerFormData() async {
    Map<String, dynamic> formData = {
      'c_id': _caretakerIdController.text,
      'password': _caretakerPasswordController.text,
      'name': _caretakerNameController.text,
      'age': _caretakerAgeController.text,
      'sex': _caretakerSexController.text,
      'mobile_number': _caretakerMobileNumberController.text,
      'qualification': _caretakerQualificationController.text,
      'address': _caretakerAddressController.text,
      'marital_status': _caretakerMaritalStatusController.text,
    };

    var url = (addct); // Update with your PHP URL
    try {
      var response = await http.post(Uri.parse(url), body: formData);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print('Caretaker response: $jsonResponse');
        if (jsonResponse['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Caretaker successfully added'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add caretaker: ${jsonResponse['message']}'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to communicate with server. Status code: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      print('Error sending request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to communicate with server. Please try again.'),
        ),
      );
    }
  }

  void _savePatientFormData() async {
    String? base64Image;
    try {
      if (_image != null) {
        List<int> imageBytes = await _image!.readAsBytes();
        base64Image = base64Encode(imageBytes);
      }
    } catch (e) {
      print('Error reading image file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error with image file. Please try again.'),
        ),
      );
      return;
    }

    Map<String, dynamic> formData = {
      'patient_id': _patientIdController.text,
      'name': _nameController.text,
      'age': _ageController.text,
      'sex': _sexController.text,
      'education': _educationController.text,
      'mobile_number': _mobileNumberController.text,
      'address': _addressController.text,
      'marital_status': _maritalStatusController.text,
      'disease_status': _diseaseStatusController.text,
      'duration': _durationController.text,
      'profile_pic': base64Image,
    };

    var url = (addpatient); // Update with your PHP URL
    try {
      var response = await http.post(Uri.parse(url), body: jsonEncode(formData));
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print('Patient response: $jsonResponse');
        if (jsonResponse['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Patient successfully added'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add patient: ${jsonResponse['message']}'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to communicate with server. Status code: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      print('Error sending request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to communicate with server. Please try again.'),
        ),
      );
    }
  }

  void _saveRelationData() async {
    Map<String, dynamic> formData = {
      'patient_id': _patientIdController.text,
      'c_id': _caretakerIdController.text,
      'relation': _caretakerRelationshipController.text,
    };

    var url = (relation); // Update with your PHP URL
    try {
      var response = await http.post(Uri.parse(url), body: formData);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print('Relation response: $jsonResponse');
        if (jsonResponse['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Relation successfully added'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add relation: ${jsonResponse['message']}'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to communicate with server. Status code: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      print('Error sending request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to communicate with server. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                      'Add Patient',
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
              Text(
                'Patient Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(

                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.indigo),
                    borderRadius: BorderRadius.circular(10.0),
                  ),

                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: Center(
                          child: _image == null
                              ? Icon(
                            Icons.person_add_alt_1_rounded,
                            size: 80,
                          )
                              : Image.file(
                            _image!,
                            height: 150,
                          ),
                        ),
                      ),
                      _buildTextField('Patient ID', _patientIdController),
                      _buildTextField('Name', _nameController),
                      _buildTextField('Age', _ageController),
                      _buildTextField('Sex', _sexController),
                      _buildTextField('Education', _educationController),
                      _buildTextField('Mobile Number', _mobileNumberController),
                      _buildTextField('Address', _addressController),
                      _buildTextField('Marital Status', _maritalStatusController),
                      _buildTextField('Disease Status', _diseaseStatusController),
                      _buildTextField('Duration', _durationController),
                    ],
                  ),
                ),
              ),
              Text(
                'Caretaker Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.indigo),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      _buildTextField('Caretaker ID', _caretakerIdController),
                      _buildTextField('Password', _caretakerPasswordController),
                      _buildTextField('Name', _caretakerNameController),
                      _buildTextField('Age', _caretakerAgeController),
                      _buildTextField('Sex', _caretakerSexController),
                      _buildTextField('Mobile Number', _caretakerMobileNumberController),
                      _buildTextField('Qualification', _caretakerQualificationController),
                      _buildTextField('Address', _caretakerAddressController),
                      _buildTextField('Marital Status', _caretakerMaritalStatusController),
                      _buildTextField('Relationship', _caretakerRelationshipController),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Save'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
