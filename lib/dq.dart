import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Result.dart';
import 'common.dart';

class Q1 extends StatefulWidget {
  final String? selectedRelationship;
  final String patientId;
  final String c_id;

  const Q1({Key? key, this.selectedRelationship, required this.patientId, required this.c_id}) : super(key: key);

  @override
  _Q1State createState() => _Q1State();
}

class _Q1State extends State<Q1> {
  int _currentQuestion = 1;
  bool? _responseValue; // Change to bool?
  int _totalScore = 0; // Track the total score

  @override
  void initState() {
    super.initState();
    _insertInitialValues();
  }

  Future<void> _insertInitialValues() async {
    String url = (wq);

    Map<String, dynamic> data = {
      'patient_id': widget.patientId,
    };

    try {
      final response = await http.post(Uri.parse(url), body: data);
      if (response.statusCode == 200) {
        print('Initial values inserted successfully.');
      } else {
        print('Failed to insert initial values: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception while inserting initial values: $e');
    }
  }

  Future<void> _sendResponse() async {
    String url = (updatewq);

    Map<String, dynamic> data = {
      'patient_id': widget.patientId,
      'q$_currentQuestion': _responseValue == true ? 'true' : 'false',
      'score': _totalScore.toString(),
    };

    print('Data sent to server: $data'); // Debugging print

    try {
      final response = await http.post(Uri.parse(url), body: data);
      if (response.statusCode == 200) {
        print('Response sent successfully: ${response.body}');
      } else {
        print('Failed to send response: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception while sending response: $e');
    }
  }

  int _calculateScore(int questionNumber, bool? answer) {
    if (answer == null) return 0;

    switch (questionNumber) {
      case 1:
      case 3:
      case 4:
      case 7:
      case 9:
      case 10:
        return answer ? 1 : -1; // Plus 1 for true, 0 for false

      case 2:
      case 5:
      case 6:
      case 8:
        return answer ? -1 : 1; // Minus 1 for true, 0 for false

      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[300],
        title: Text('Daily Question'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 70),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text(
                'Question $_currentQuestion:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                elevation: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        _getQuestionText(_currentQuestion),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Column(
                      children: _buildRadioOptions(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Visibility(
                visible: _currentQuestion < 10, // Show button until 9th question
                child: ElevatedButton(
                  onPressed: _responseValue != null
                      ? () async {
                    int score = _calculateScore(_currentQuestion, _responseValue);
                    _totalScore += score;

                    print('Response Value: $_responseValue'); // Debugging print
                    print('Score for Question $_currentQuestion: $score'); // Debugging print
                    print('Total Score: $_totalScore'); // Debugging print

                    await _sendResponse();

                    setState(() {
                      if (_currentQuestion < 10) {
                        _currentQuestion++;
                        _responseValue = null; // Reset _responseValue after sending the response
                      }
                    });
                  }
                      : null,
                  child: Text(
                    'Next Question',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            Center(
              child: Visibility(
                visible: _currentQuestion == 10,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_responseValue != null) {
                      int score = _calculateScore(_currentQuestion, _responseValue);
                      _totalScore += score;

                      print('Final Response Value: $_responseValue'); // Debugging print
                      print('Final Score for Question $_currentQuestion: $score'); // Debugging print
                      print('Final Total Score: $_totalScore'); // Debugging print

                      await _sendResponse();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultScreen(
                            c_id: widget.c_id,
                            patientId: widget.patientId,
                            selectedRelationship: widget.selectedRelationship,
                            totalScore: _totalScore, // Pass the total score
                          ),
                        ),
                      );

                    }
                  },
                  child: Text(
                    'Finish',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRadioOptions() {
    return [
      ListTile(
        title: Text('True'),
        leading: Radio<bool>(
          value: true,
          groupValue: _responseValue,
          onChanged: (value) {
            setState(() {
              _responseValue = value;
            });
          },
        ),
      ),
      ListTile(
        title: Text('False'),
        leading: Radio<bool>(
          value: false,
          groupValue: _responseValue,
          onChanged: (value) {
            setState(() {
              _responseValue = value;
            });
          },
        ),
      ),
    ];
  }

  String _getQuestionText(int questionNumber) {
    switch (questionNumber) {
      case 1:
        return 'For me, the good things about medication outweigh the bad?';
      case 2:
        return "I feel strange, 'doped up', on medication?";
      case 3:
        return 'I take medications of my own free choice?';
      case 4:
        return 'Medication makes me feel more relaxed?';
      case 5:
        return 'Medication makes me feel tired and sluggish?';
      case 6:
        return 'I take medication only when I feel ill?';
      case 7:
        return 'I feel more normal on medication?';
      case 8:
        return 'It is unnatural for my mind and body to be controlled by medications?';
      case 9:
        return 'My thoughts are clear on medication?';
      case 10:
        return 'Taking medication will prevent me from having a breakdown?';
      default:
        return '';
    }
  }
}
