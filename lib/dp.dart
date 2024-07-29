import 'package:flutter/material.dart';

class DoctorProfileProvider extends ChangeNotifier {
  late String doctorId;
  late String fullName;
  late String designation;
  late String sex;
  late String mobileNumber;
  late String specialization;
  late String address;
  late String maritalStatus;

  void updateProfile(Map<String, String> updatedData) {
    doctorId = updatedData['doctorId']!;
    fullName = updatedData['fullName']!;
    designation = updatedData['designation']!;
    sex = updatedData['sex']!;
    mobileNumber = updatedData['mobileNumber']!;
    specialization = updatedData['specialization']!;
    address = updatedData['address']!;
    maritalStatus = updatedData['maritalStatus']!;
    notifyListeners();
  }
}
