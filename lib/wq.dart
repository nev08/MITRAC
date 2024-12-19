import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'd_reasons.dart';
import 'common.dart';

class SQ1 extends StatefulWidget {
  final String? selectedRelationship;
  final String patientId;
  final String c_id;

  const SQ1({Key? key, this.selectedRelationship, required this.patientId, required this.c_id}) : super(key: key);

  @override
  _SQ1State createState() => _SQ1State();
}

class _SQ1State extends State<SQ1> {
  int _currentQuestion = 1;
  dynamic _responseValue;
  List<String?> _initialValues = List.filled(8, null);

  @override
  void initState() {
    super.initState();
    _fetchInitialValues();
  }

  Future<void> _fetchInitialValues() async {
    try {
      var url = Uri.parse(dq);
      var response = await http.post(
          url, body: {'patient_id': widget.patientId});
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['success']) {
          setState(() {
            _initialValues = List<String?>.from(data['values']);
          });
        } else {
          print('Failed to fetch initial values: ${data['message']}');
        }
      } else {
        print('Failed to fetch initial values: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[300],
        title: Text('Weekly Question'),
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
                visible: _currentQuestion < 8, // Show button until 8th question
                child: ElevatedButton(
                  onPressed: _responseValue != null
                      ? () {
                    setState(() {
                      if (_currentQuestion < 8) {
                        _sendResponse(
                            widget.patientId, _currentQuestion, _responseValue);
                        _responseValue =
                        null; // Reset _responseValue after sending the response
                        _currentQuestion++;
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
                visible: _currentQuestion == 8,
                child: ElevatedButton(
                  onPressed: () {
                    // Ensure responseValue is not null
                    if (_responseValue != null) {
                      // Send the response to the database
                      _sendResponse(
                          widget.patientId, _currentQuestion, _responseValue)
                          .then((_) {
                        // Navigate to the next page after response is stored
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              d_ReasonsScreen(
                                c_id: widget.c_id,
                                patientId: widget.patientId,
                                selectedRelationship: widget
                                    .selectedRelationship,)),
                        );
                      });
                    } else {
                      // If responseValue is null, show an error message or handle it appropriately
                      print('Please select an option for question 8.');
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
    if (_currentQuestion == 8) {
      return _buildRatingOptions();
    } else {
      return [
        ListTile(
          title: Text('Yes'),
          leading: Radio(
            value: '1',
            groupValue: _responseValue,
            onChanged: (value) {
              setState(() {
                _responseValue = value;
              });
            },
          ),
        ),
        ListTile(
          title: Text('No'),
          leading: Radio(
            value: '0',
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
  }

  List<Widget> _buildRatingOptions() {
    return [
      ListTile(
        title: Text('Never/Rarely'),
        leading: Radio(
          value: '0',
          groupValue: _responseValue,
          onChanged: (value) {
            setState(() {
              _responseValue = value;
            });
          },
        ),
      ),
      ListTile(
        title: Text('Once in a while'),
        leading: Radio(
          value: '1',
          groupValue: _responseValue,
          onChanged: (value) {
            setState(() {
              _responseValue = value;
            });
          },
        ),
      ),
      ListTile(
        title: Text('Sometimes'),
        leading: Radio(
          value: '1',
          groupValue: _responseValue,
          onChanged: (value) {
            setState(() {
              _responseValue = value;
            });
          },
        ),
      ),
      ListTile(
        title: Text('Usually'),
        leading: Radio(
          value: '1',
          groupValue: _responseValue,
          onChanged: (value) {
            setState(() {
              _responseValue = value;
            });
          },
        ),
      ),
      ListTile(
        title: Text('All the time'),
        leading: Radio(
          value: '1',
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
        return 'Do you sometimes forget to take your medication?';
      case 2:
        return 'People sometimes miss taking their medication for reasons other than forgetting. Over the past 2 weeks there any days when you did not take your medication?';
      case 3:
        return 'Have you ever cut back or stopped taking your medication without telling your doctor because you felt worse when you took it?';
      case 4:
        return 'When you travel or leave home, do you sometimes forget to bring your medication?';
      case 5:
        return 'Did you take all your medication yesterday?';
      case 6:
        return 'When you feel like your symptoms are under control, do you sometimes stop taking your medication?';
      case 7:
        return 'Taking medication every day is a real inconvenience for some people. Do you ever feel hassled about sticking to your treatment plan?';
      case 8:
        return 'How often do you miss taking your medication?';
      default:
        return '';
    }
  }

  Future<void> _sendResponse(String? patientId, int questionNumber,
      dynamic responseValue) async {
    try {
      // Check if responseValue is not null before sending
      if (responseValue != null) {
        var url = Uri.parse(updatedq);
        var postResponse = await http.post(
          url,
          body: {
            'patient_id': patientId,
            'q${questionNumber}': responseValue.toString(),
          },
        );

        if (postResponse.statusCode == 200) {
          print('Response stored successfully');

          // If it is the last question, calculate and store the score
          if (questionNumber == 8) {
            await _calculateAndStoreScore(patientId);
          }
        } else {
          print('Failed to store response');
        }
      } else {
        print('Response value is null');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _calculateAndStoreScore(String? patientId) async {
    try {
      var url = Uri.parse(w_score);
      var response = await http.post(
        url,
        body: {'patient_id': patientId},
      );

      if (response.statusCode == 200) {
        print('Score calculated and stored successfully');
      } else {
        print('Failed to calculate and store score');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
