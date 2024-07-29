import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:schizo/view_dq_answers.dart';
import 'common.dart';


class SearchDailyQuestionsScreen extends StatefulWidget {
  @override
  _SearchDailyQuestionsScreenState createState() => _SearchDailyQuestionsScreenState();
}

class _SearchDailyQuestionsScreenState extends State<SearchDailyQuestionsScreen> {
  List<String> patientIds = [];
  String _selectedPatientId = '';

  @override
  void initState() {
    super.initState();
    fetchPatientIds();
  }

  Future<void> fetchPatientIds() async {
    try {
      final response = await http.post(
        Uri.parse(searchdans), // Replace with your PHP script URL
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          patientIds = List<String>.from(jsonData);
        });
      } else {
        print('Failed to fetch patient IDs: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching patient IDs: $e');
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
            color: Colors.indigo[300], // Assuming this color is used for the toolbar background
          ),
          child: Center(
            child: Text(
              'Search By Patient Id',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
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
            SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: patientIds.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPatientId = patientIds[index];
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => weekly(patientId: _selectedPatientId),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text('Patient id :  ${patientIds[index]}'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



