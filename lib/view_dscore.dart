import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'common.dart';

class ScorecardPage extends StatefulWidget {
  final String patientId;

  const ScorecardPage({Key? key, required this.patientId}) : super(key: key);

  @override
  _ScorecardPageState createState() => _ScorecardPageState();
}

class _ScorecardPageState extends State<ScorecardPage> {
  List<Map<String, dynamic>> _scores = [];

  @override
  void initState() {
    super.initState();
    _fetchScores();
  }

  Future<void> _fetchScores() async {
    try {
      var url = Uri.parse(get_dscore); // Use the correct URL for scores
      var body = jsonEncode({'id': widget.patientId});

      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['success']) {
          setState(() {
            _scores = List<Map<String, dynamic>>.from(data['data']).map((score) {
              score['attitude'] = score['score'] >= 0 ? 'positive' : 'negative';
              return score;
            }).toList();

            // Sort the scores by date in descending order
            _scores.sort((a, b) {
              DateTime dateA = DateTime.parse(a['date']);
              DateTime dateB = DateTime.parse(b['date']);
              return dateB.compareTo(dateA);
            });
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
        title: Text('Scorecard'),
        backgroundColor: Colors.indigo[300],
      ),
      body: _scores.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
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
                'Score on ${score['date']}', // Display date
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Score: ${score['score']}/10\n',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                        height: 2, // Adjust the height value for line spacing
                      ),
                    ),
                    TextSpan(
                      text: 'Attitude: ${score['attitude'] == 'positive' ? 'Positive attitude towards medication' : 'Negative attitude towards medication'}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: score['attitude'] == 'positive' ? Colors.green : Colors.red,
                        height: 2, // Same height to ensure consistent spacing
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
