import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'w_reasons.dart';
import 'common.dart';

class ResultScreen extends StatefulWidget {
  final String? selectedRelationship;
  final String patientId;
  final String c_id;
  final int totalScore;

  const ResultScreen({Key? key, this.selectedRelationship, required this.patientId, required this.c_id, required this.totalScore}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String _responseMessage = '';

  @override
  void initState() {
    super.initState();
    _sendScoreToBackend();
  }

  Future<void> _sendScoreToBackend() async {
    final url = Uri.parse(result); // Update with your actual URL
    final response = await http.post(
      url,
      body: {
        'patient_id': widget.patientId,
        'score': widget.totalScore.toString(),
      },
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      setState(() {
        _responseMessage = result['message'] ?? 'Score submitted successfully';
      });
    } else {
      setState(() {
        _responseMessage = 'Failed to submit score';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 80.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
                color: Colors.indigo[300],
              ),
              child: Center(
                child: Text(
                  'Result score',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 150.0),
            Card(
              elevation: 30.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(150.0),
              ),
              child: Container(
                height: 300.0,
                width: 300.0,
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total score:',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      '${widget.totalScore} / 10', // Display the total score out of 10
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      _responseMessage,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReasonsScreen(
                      selectedRelationship: widget.selectedRelationship,
                      c_id: widget.c_id,
                      patientId: widget.patientId,
                    ),
                  ),
                );
              },
              child: Text(
                'Next',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
