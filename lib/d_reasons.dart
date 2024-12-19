import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ct_dash.dart';
import 'common.dart';

class d_ReasonsScreen extends StatefulWidget {
  final String? selectedRelationship;
  final String patientId;
  final String c_id;

  const d_ReasonsScreen({Key? key, this.selectedRelationship,required this.patientId, required this.c_id}) : super(key: key);

  @override
  _d_ReasonsScreenState createState() => _d_ReasonsScreenState();
}

class _d_ReasonsScreenState extends State<d_ReasonsScreen> {
  late TextEditingController _reasonsController;

  @override
  void initState() {
    super.initState();
    _reasonsController = TextEditingController();
  }

  @override
  void dispose() {
    _reasonsController.dispose();
    super.dispose();
  }

  Future<void> _saveReasons(String patientId, String reasons) async {
    try {
      var url = Uri.parse(dres);
      var response = await http.post(url, body: {
        'patient_id': patientId,
        'reasons': reasons,
      });
      if (response.statusCode == 200) {
        var data = response.body;
        print('Response from server: $data');
        // Handle response from server if needed
      } else {
        print('Failed to save reasons: ${response.reasonPhrase}');
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
        title: Text('Reasons'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 50.0),
              Card(
                elevation: 30.0,
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 450.0,
                  padding: EdgeInsets.all(20.0),
                  child: TextField(
                    controller: _reasonsController,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Reasons Here',
                      hintStyle: TextStyle(fontSize: 20.0),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 20.0),
                    maxLines: null,
                  ),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                height: 50.0,
                child : ElevatedButton(
                  onPressed: () {
                    String reasons = _reasonsController.text.trim();
                    if (widget.patientId != null && reasons.isNotEmpty) {
                      _saveReasons(widget.patientId!, reasons);
                      // Clear the text field after saving
                      _reasonsController.clear();
                      // Navigate to another screen

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ct_dash(
                            selectedRelationship: widget.selectedRelationship,
                            c_id: widget.c_id,
                            patientId: widget.patientId,
                          ),
                        ),
                      );

                    } else {
                      // Handle empty reasons input or null patientId
                      print('Reasons or patientId cannot be null');
                    }
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
