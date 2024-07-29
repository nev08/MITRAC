import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'common.dart';

class BookedSlotsPage extends StatefulWidget {
  final String? patientId;

  const BookedSlotsPage({Key? key, this.patientId}) : super(key: key);

  @override
  _BookedSlotsPageState createState() => _BookedSlotsPageState();
}

class _BookedSlotsPageState extends State<BookedSlotsPage> {
  List<Map<String, dynamic>> appointments = [];

  Future<void> fetchAppointments(String pid) async {
    final response = await http.post(
      Uri.parse(bookslot),
      body: json.encode({"pid": pid}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      setState(() {
        appointments = List<Map<String, dynamic>>.from(json.decode(response.body)['data']);
      });
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  @override
  void initState() {
    if (widget.patientId != null) {
      fetchAppointments(widget.patientId!); // Use ! to assert that widget.patientId is non-null
    } else {
      // Handle the case where patientId is null, maybe by using a default ID or displaying an error message
      print("Patient ID is null");
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 70.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
              color: Colors.indigo[300], // You can change the color here
            ),
            child: Center(
              child: Text(
                'Booked Status',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Expanded(
            child: ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'PID               : ',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                appointments[index]['patient_id'],
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              Text(
                                'Name            : ',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                appointments[index]['name'],
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              Text(
                                'Date              : ',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                appointments[index]['date'],
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              Text(
                                'Status           : ',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                appointments[index]['status'],
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
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
