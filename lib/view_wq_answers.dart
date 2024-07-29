import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'common.dart';
import 'view_wscore.dart';

class MedicineQuestionnaire extends StatefulWidget {
  final String patientId;

  const MedicineQuestionnaire({Key? key, required this.patientId}) : super(key: key);

  @override
  _MedicineQuestionnaireState createState() => _MedicineQuestionnaireState();
}

class _MedicineQuestionnaireState extends State<MedicineQuestionnaire> {
  List<String?> _answers = [];

  @override
  void initState() {
    super.initState();
    _fetchAnswers();
  }

  Future<void> _fetchAnswers() async {
    try {
      var url = Uri.parse(viewda);
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
        child: Card(
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
                  question: "Do you sometimes forget to take your medication?",
                  answer: _answers.isNotEmpty ? _formatAnswer(_answers[0]) : "",
                ),
                QuestionWidget(
                  question: "People sometimes miss taking their medication for reasons other than forgetting. Over the past 2 weeks, have there been any days when you did not take your medication?",
                  answer: _answers.isNotEmpty ? _formatAnswer(_answers[1]) : "",
                ),
                QuestionWidget(
                  question: "Have you ever cut back or stopped taking your medication without telling your doctor because you felt worse when you took it?",
                  answer: _answers.isNotEmpty ? _formatAnswer(_answers[2]) : "",
                ),
                QuestionWidget(
                  question: "When you travel or leave home, do you sometimes forget to bring your medication?",
                  answer: _answers.isNotEmpty ? _formatAnswer(_answers[3]) : "",
                ),
                QuestionWidget(
                  question: "Did you take all your medication yesterday?",
                  answer: _answers.isNotEmpty ? _formatAnswer(_answers[4]) : "",
                ),
                QuestionWidget(
                  question: "When you feel like your symptoms are under control, do you sometimes stop taking your medication?",
                  answer: _answers.isNotEmpty ? _formatAnswer(_answers[5]) : "",
                ),
                QuestionWidget(
                  question: "Taking medication every day is a real inconvenience for some people. Do you ever feel hassled about sticking to your treatment plan?",
                  answer: _answers.isNotEmpty ? _formatAnswer(_answers[6]) : "",
                ),
                QuestionWidget(
                  question: "How often do you have difficulty remembering to take all your medication?\n A. Never/Rarely\n B. Once in a while\n C. Sometimes\n D. Usually\n E. All the time",
                  answer: _answers.isNotEmpty ? _formatLastAnswer(_answers[7]) : "",
                ),
                SizedBox(height: 20), // Space between questions and button
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScorecardsScreen(patientId: widget.patientId),
                        ),
                      );
                    },
                    child: Text(
                      'View Scorecards',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white, // Set text color to white
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.indigo[300], // Button background color
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10), // Button padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Button border radius
                        side: BorderSide(color: Colors.blue, width: 10), // Border color and width
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatAnswer(String? answer) {
    if (answer == null) return "";
    switch (answer) {
      case "1":
        return "Yes";
      case "0":
        return "No";
      default:
        return answer;
    }
  }

  String _formatLastAnswer(String? answer) {
    if (answer == null) return "";
    switch (answer) {
      case "0":
        return "Never/Rarely";
      case "1":
        return "Once in a while or more";
      default:
        return answer;
    }
  }
}

class QuestionWidget extends StatelessWidget {
  final String question;
  final String answer;

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
        Text(
          question,
          style: TextStyle(
            color: Colors.blue[900],
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8), // Space between question and answer
        Text(
          answer,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        SizedBox(height: 20), // Space below each question and answer
      ],
    );
  }
}
