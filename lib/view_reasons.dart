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
  List<Map<String, String>> _reasons = [];

  @override
  void initState() {
    super.initState();
    _fetchReasons();
  }

  Future<void> _fetchReasons() async {
    try {
      var url = Uri.parse('http://14.139.187.229:8081/mitrac/viewreasons.php?patient_id=${widget.patientId}');

      // Send the GET request
      var response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse JSON response
        var jsonResponse = json.decode(response.body);
        print('Response: $jsonResponse'); // Print the JSON response for debugging

        if (jsonResponse is List) {
          setState(() {
            _reasons = jsonResponse.map<Map<String, String>>((item) {
              return {
                'reason': item['reason'],
                'date': item['date']
              };
            }).toList();
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
    final currentDate = DateTime.now().toIso8601String().substring(0, 10);

    return Scaffold(
      appBar: AppBar(
        title: Text('View Reasons'),
        backgroundColor: Colors.indigo[300],
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
                bool isToday = _reasons[index]['date']!.substring(0, 10) == currentDate;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Material(
                    elevation: isToday ? 8.0 : 2.0, // Higher elevation for current day's card
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      padding: isToday ? EdgeInsets.all(20.0) : EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: isToday ? Colors.yellow[50] : Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _reasons[index]['reason']!,
                            style: TextStyle(
                              fontSize: isToday ? 20.0 : 16.0,
                              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                              color: isToday ? Colors.black : Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            _reasons[index]['date']!,
                            style: TextStyle(
                              fontSize: isToday ? 16.0 : 14.0,
                              color: isToday ? Colors.black54 : Colors.indigo[300],
                            ),
                          ),
                        ],
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
