import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ViewReasonsScreen extends StatefulWidget {
  final String patientId;

  const ViewReasonsScreen({Key? key, required this.patientId}) : super(key: key);

  @override
  _ViewReasonsScreenState createState() => _ViewReasonsScreenState();
}

class _ViewReasonsScreenState extends State<ViewReasonsScreen> {
  List<String> _reasons = [];

  @override
  void initState() {
    super.initState();
    _fetchReasons();
  }

  Future<void> _fetchReasons() async {
    try {
      var url = Uri.parse('http://192.168.176.213 :80/app/viewreasons.php?patient_id=${widget.patientId}');

      // Send the GET request
      var response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse JSON response
        var jsonResponse = json.decode(response.body);
        print('Response: $jsonResponse'); // Print the JSON response for debugging

        if (jsonResponse is List) {
          setState(() {
            _reasons = jsonResponse.cast<String>();
          });
        } else {
          setState(() {
            _reasons = [];
          });
        }
      } else {
        // Handle non-200 response
        print('Failed to fetch reasons: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle network or parsing error
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Reasons'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Reasons',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: _reasons.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _reasons[index],
                        style: TextStyle(fontSize: 18.0),
                      ),
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
