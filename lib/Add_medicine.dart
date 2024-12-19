import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'common.dart';

class MedicineData extends StatefulWidget {
  final String patientId;

  const MedicineData({Key? key, required this.patientId}) : super(key: key);

  @override
  _MedicineDataState createState() => _MedicineDataState();
}

class _MedicineDataState extends State<MedicineData> {
  List<Map<String, dynamic>> medicineList = [];

  @override
  void initState() {
    super.initState();
    fetchMedicineData();
  }

  Future<void> fetchMedicineData() async {
    try {
      // Get current date in 'YYYY-MM-DD' format
      final currentDate = DateTime.now().toIso8601String().substring(0, 10);

      final response = await http.post(
        Uri.parse(medmoni),
        body: jsonEncode({'id': widget.patientId, 'date': currentDate}),
        headers: {'Content-Type': 'application/json'},
      );

      print('Server response: ${response.body}'); // Add this line to print the response

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['status'] == 'success') {
          setState(() {
            medicineList = List<Map<String, dynamic>>.from(jsonData['data']);
          });
        } else {
          print('Failed to fetch medicine data: ${jsonData['message']}');
        }
      } else {
        print('Failed to fetch medicine data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching medicine data: $e');
    }
  }

  Future<void> deleteMedicine(String medicineName) async {
    try {
      final response = await http.post(
        Uri.parse(deletemed),
        body: jsonEncode({
          'id': widget.patientId,
          'Medicine_name': medicineName,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Medicine details deleted successfully');
        setState(() {
          // Remove the deleted medicine from the list
          medicineList.removeWhere((medicine) => medicine['Medicine_name'] == medicineName);
        });
      } else {
        print('Failed to delete medicine details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting medicine details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            color: Colors.indigo[300],
          ),
          child: Center(
            child: Text(
              'Add medicine',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Medicine",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showMedicineDetailsDialog(context);
                    },
                    child: Image.asset(
                      'assets/pills.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                itemCount: medicineList.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 120,
                    child: Card(
                      child: ListTile(
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Medicine Name: ${medicineList[index]['Medicine_name']}"),
                            SizedBox(height: 10),
                            Text("Dose: ${medicineList[index]['Dose']}"),
                            SizedBox(height: 10),
                            Text("Type: ${medicineList[index]['Type']}"),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await deleteMedicine(medicineList[index]['Medicine_name']);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMedicineDetailsDialog(BuildContext context) async {
    String? medicineName;
    String? dose;
    String? type;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Medicine Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      TextField(
                        onChanged: (value) {
                          medicineName = value;
                        },
                        decoration: InputDecoration(
                          hintText: "Medicine Name",
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        onChanged: (value) {
                          dose = value;
                        },
                        decoration: InputDecoration(
                          hintText: "Dose",
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        onChanged: (value) {
                          type = value;
                        },
                        decoration: InputDecoration(
                          hintText: "Type",
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          await _saveMedicineDetails(medicineName, dose, type);
                          Navigator.pop(context);
                        },
                        child: Text("Save"),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _saveMedicineDetails(String? medicineName, String? dose, String? type) async {
    try {
      final response = await http.post(
        Uri.parse(addmed),
        body: jsonEncode({
          'id': widget.patientId,
          'Medicine_name': medicineName,
          'Dose': dose,
          'Type': type,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Medicine details saved successfully');
        await fetchMedicineData();
      } else {
        print('Failed to save medicine details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving medicine details: $e');
    }
  }
}
