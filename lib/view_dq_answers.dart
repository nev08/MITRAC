import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'common.dart';
import 'view_dscore.dart';

class weekly extends StatefulWidget {
  final String patientId;

  const weekly({Key? key, required this.patientId}) : super(key: key);

  @override
  _WeeklyState createState() => _WeeklyState();
}

class _WeeklyState extends State<weekly> {
  List<String?> _answers = [];

  @override
  void initState() {
    super.initState();
    _fetchAnswers();
  }

  Future<void> _fetchAnswers() async {
    try {
      var url = Uri.parse(viewwa);
      var body = jsonEncode({'patient_id': widget.patientId});

      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['success']) {
          var responseData = data['data'][0]; // Assuming only one set of answers is returned
          // Extract answers from the response data
          var answers = [
            responseData['q1'],
            responseData['q2'],
            responseData['q3'],
            responseData['q4'],
            responseData['q5'],
            responseData['q6'],
            responseData['q7'],
            responseData['q8'],
            responseData['q9'],
            responseData['q10'],
          ];
          setState(() {
            _answers = answers.map<String?>((answer) => answer.toString()).toList();
          });
          print('Answers: $_answers');
        } else {
          print('Failed to fetch answers: ${data['message']}');
        }
      } else {
        print('Failed to fetch answers: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Medicine Questionnaire',
          style: TextStyle(
            color: Colors.white, // Text color
            fontWeight: FontWeight.bold, // Text weight
            fontSize: 20, // Text size
          ),
        ),
        backgroundColor: Colors.indigo[300], // Background color
        elevation: 10, // Elevation (shadow)
        centerTitle: true, // Center the title
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20), // Round the bottom corners
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 8,
              margin: EdgeInsets.all(20),
              color: Colors.white70,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Patient_id: ${widget.patientId}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30),
                    QuestionWidget(
                      question: "For me, the good things about medication outweigh the bad ?",
                      answer: _answers.isNotEmpty ? _answers[0] : "",
                    ),
                    QuestionWidget(
                      question: "I feel strange , 'doped up' , on medication ?",
                      answer: _answers.isNotEmpty ? _answers[1] : "",
                    ),
                    QuestionWidget(
                      question:
                      "I take medications of my own free choice ?",
                      answer: _answers.isNotEmpty ? _answers[2] : "",
                    ),
                    QuestionWidget(
                      question:
                      "Medication makes me feel more relaxed ?",
                      answer: _answers.isNotEmpty ? _answers[3] : "",
                    ),
                    QuestionWidget(
                      question: "Medication makes me feel tired and sluggish ?",
                      answer: _answers.isNotEmpty ? _answers[4] : "",
                    ),
                    QuestionWidget(
                      question:
                      "I take medication only when I feel ill ?",
                      answer: _answers.isNotEmpty ? _answers[5] : "",
                    ),
                    QuestionWidget(
                      question:
                      'I feel more normal on medication ?',
                      answer: _answers.isNotEmpty ? _answers[6] : "",
                    ),
                    QuestionWidget(
                      question:
                      "It is unnatural for my mind and body to be controlled by medications ?",
                      answer: _answers.isNotEmpty ? _answers[7] : "",
                    ),
                    QuestionWidget(
                      question:
                      "My thoughts are clear on medication ?",
                      answer: _answers.isNotEmpty ? _answers[8] : "",
                    ),
                    QuestionWidget(
                      question:
                      "Taking medication will prevent me from having a breakdown ?",
                      answer: _answers.isNotEmpty ? _answers[9] : "",
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the scorecard page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScorecardPage(patientId: widget.patientId),
                  ),
                );
              },
              child: Text('View Scorecard'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo[300], // Background color
                foregroundColor: Colors.white,       // Text color
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12), // Button padding
                textStyle: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionWidget extends StatelessWidget {
  final String question;
  final String? answer;

  const QuestionWidget({
    Key? key,
    required this.question,
    required this.answer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                question,
                style: TextStyle(
                  color: Colors.blue[900],
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 20), // Adjust the spacing between question and answer
            Text(
              answer ?? '',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
        SizedBox(height: 20), // Space below each question and answer
      ],
    );
  }
}
