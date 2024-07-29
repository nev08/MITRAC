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
      var url = Uri.parse(get_dscore);
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
                    "Date: ${score['date']}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Score: ${score['score']}/10",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
