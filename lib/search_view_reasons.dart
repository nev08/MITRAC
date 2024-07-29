import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'common.dart';
import 'view_reasons.dart';

class SearchViewReasons extends StatefulWidget {
  @override
  _SearchViewReasonsState createState() => _SearchViewReasonsState();
}

class _SearchViewReasonsState extends State<SearchViewReasons> {
  List<String> patientIds = [];

  @override
  void initState() {
    super.initState();
    fetchPatientIds();
  }

  Future<void> fetchPatientIds() async {
    try {
      final response = await http.get(
        Uri.parse(searchres), // Replace with your PHP script URL
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
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewReasonsScreen(patientId: patientIds[index]),
                        ),
                      );
                    },
                    child: Card(
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
