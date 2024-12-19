import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'common.dart';

class ScorecardsScreen extends StatefulWidget {
  final String patientId;

  const ScorecardsScreen({Key? key, required this.patientId}) : super(key: key);

  @override
  _ScorecardsScreenState createState() => _ScorecardsScreenState();
}

class _ScorecardsScreenState extends State<ScorecardsScreen> {
  List<Map<String, dynamic>> _scores = [];

  @override
  void initState() {
    super.initState();
    _fetchScores();
  }

  Future<void> _fetchScores() async {
    try {
      var url = Uri.parse(get_wscore); // Ensure this URL is correct
      var response = await http.post(
        url,
        body: jsonEncode({'id': widget.patientId}), // Match the parameter name in PHP
        headers: {'Content-Type': 'application/json'},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}'); // Print the raw response

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['success']) {
          setState(() {
            _scores = List<Map<String, dynamic>>.from(data['data']);
          });
        } else {
          print('Failed to fetch scores: ${data['message']}');
        }
      } else {
        print('Failed to fetch scores: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String _getAdherenceStatus(int score) {
    if (score > 2) {
      return 'Low Adherence';
    } else if (score == 1 || score == 2) {
      return 'Medium Adherence';
    } else if (score == 0) {
      return 'High Adherence';
    } else {
      return 'Unknown Status';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scorecards'),
        backgroundColor: Colors.indigo[300],
      ),
      body: ListView.builder(
        itemCount: _scores.length,
        itemBuilder: (context, index) {
          var score = _scores[index];
          return Card(
            margin: EdgeInsets.all(10),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.grey[400]!, width: 1),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(15),
              title: Text(
                'Date: ${score['date']}', // Assumes 'date' is a field in the table
               // style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Score: ${score['score']}/10\n',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16, // Adjust the size as needed
                        color: Colors.black,
                        height:2// Set the color to black or any other color
                      ),
                    ),
                    TextSpan(
                      text: 'Status: ${_getAdherenceStatus(score['score'])}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                          height:2// Set the color to black or any other color// Adjust the size as needed
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
