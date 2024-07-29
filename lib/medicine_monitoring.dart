import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'common.dart'; // Assuming common.dart contains the required URLs

class MedicineMonitoring extends StatefulWidget {
  final String patientId;
  final String c_id;
  final String? selectedRelationship;

  const MedicineMonitoring({
    Key? key,
    required this.patientId,
    required this.c_id,
    required this.selectedRelationship,
  }) : super(key: key);

  @override
  _MedicineMonitoringState createState() => _MedicineMonitoringState();
}

class _MedicineMonitoringState extends State<MedicineMonitoring> {
  List<dynamic> _medicineData = [];
  Map<String, String?> _givenStatus = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchMedicineData();
  }

  Future<void> fetchMedicineData() async {
    try {
      var url = Uri.parse(medmoni);
      var data = jsonEncode({
        'id': widget.patientId,
        'date': DateTime.now().toString().substring(0, 10) // Fetching for the current date
      });

      var response = await http.post(url, body: data, headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        setState(() {
          var responseData = jsonDecode(response.body);
          if (responseData['status'] == 'success') {
            _medicineData = responseData['data'];
            _medicineData.forEach((medicine) {
              String medicineKey = '${medicine['Medicine_name']}_${medicine['Date']}';
              if (!_givenStatus.containsKey(medicineKey)) {
                _givenStatus[medicineKey] = medicine['status'].toString();
              }
            });
          } else {
            print('Error fetching medicine data: ${responseData['message']}');
          }
        });
      } else {
        print('Error fetching medicine data: ${response.body}');
      }
    } catch (e) {
      print('Exception during fetchMedicineData: $e');
    }
  }

  Future<void> updateMedicineStatus(String medicineName, String status) async {
    try {
      var url = Uri.parse(updatestatus); // Ensure updatestatus is defined in common.dart
      var data = jsonEncode({
        'id': widget.patientId,
        'Medicine_name': medicineName,
        'status': status,
      });

      var response = await http.post(url, body: data, headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['status'] == 'success') {
          print('Status updated successfully');
        } else {
          print('Error updating status: ${responseBody['message']}');
        }
      } else {
        print('Error updating status: ${response.body}');
      }
    } catch (e) {
      print('Exception during updateMedicineStatus: $e');
    }
  }

  void _saveStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      for (var medicineKey in _givenStatus.keys.toList()) {
        String? status = _givenStatus[medicineKey];
        if (status != null) {
          await updateMedicineStatus(medicineKey.split('_')[0], status);
        }
      }
    } finally {
      setState(() {
        _isLoading = false;
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thank You'),
            content: Text('Status updated successfully'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(true); // Pass true as a result to indicate success
                },
              ),
            ],
          );
        },
      ).then((value) {
        if (value == true) {
          Navigator.of(context).pop(true); // Pass true as a result to the previous screen
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine Monitoring'),
        backgroundColor: Colors.indigo[300],
      ),
      body: _medicineData.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No medicines prescribed'),
            Text('Your streak: 0%'),
          ],
        ),
      )
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _medicineData.map((medicine) {
            String medicineKey = '${medicine['Medicine_name']}_${medicine['Date']}';
            return Column(
              children: [
                _buildMedicineCard(
                  medicineKey,
                  medicine['Medicine_name'],
                  medicine['Dose'],
                  medicine['Type'],
                ),
                SizedBox(height: 20),
              ],
            );
          }).toList(),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _saveStatus,
          child: _isLoading ? CircularProgressIndicator(color: Colors.white) : Text('Save'),
        ),
      ),
    );
  }

  Widget _buildMedicineCard(String medicineKey, String medicineName, String dose, String type) {
    String? isGiven = _givenStatus[medicineKey];

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medicine: $medicineName',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Dose: $dose',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Type: $type',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Radio<String>(
                  value: "1",
                  groupValue: isGiven,
                  onChanged: (value) {
                    setState(() {
                      _givenStatus[medicineKey] = value;
                    });
                  },
                ),
                Text('Given'),
                Radio<String>(
                  value: "0",
                  groupValue: isGiven,
                  onChanged: (value) {
                    setState(() {
                      _givenStatus[medicineKey] = value;
                    });
                  },
                ),
                Text('Not Given'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
