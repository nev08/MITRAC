import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:schizo/view_appointment.dart';
import 'common.dart';

class StatusPage extends StatefulWidget {
  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  List<dynamic>? appointments;
  List<dynamic>? approvedAppointments;
  bool _showApproved = false;
  Color pendingButtonColor = Colors.red;
  Color approvedButtonColor = Colors.green;

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    final response = await http.post(
      Uri.parse(pending),
      // Add any required headers here
    );

    if (response.statusCode == 200) {
      setState(() {
        appointments = json.decode(response.body);
      });
    } else {
      // Handle errors
      print('Failed to load appointments');
    }
  }

  Future<void> fetchApprovedAppointments() async {
    final response = await http.post(
      Uri.parse(approved),
      // Add any required headers here
    );

    if (response.statusCode == 200) {
      setState(() {
        approvedAppointments = json.decode(response.body);
      });
    } else {
      // Handle errors
      print('Failed to load approved appointments');
    }
  }

  void approveAppointment(int index) async {
    // Check if appointments list is not null and index is valid
    if (appointments != null && index >= 0 && index < appointments!.length) {
      // Update the status locally
      setState(() {
        appointments![appointments!.length - 1 - index]['status'] = 'APPROVED';
      });

      // Send HTTP request to update status in the database
      final response = await http.post(
        Uri.parse(accept),
        body: {
          'patient_id': appointments![appointments!.length - 1 - index]['patient_id']!.toString(),
          'status': 'APPROVED',
        },
      );

      // Handle response if needed
      if (response.statusCode != 200) {
        // Handle error
        print('Failed to update status in the database');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 70.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
              color: Colors.indigo[300],
            ),
            child: Center(
              child: Text(
                'Acceptance status',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showApproved = false;
                        pendingButtonColor = Colors.red;
                        approvedButtonColor = Colors.green;
                        fetchAppointments();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pendingButtonColor,
                    ),
                    child: Text('PENDING'),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showApproved = true;
                        pendingButtonColor = Colors.red;
                        approvedButtonColor = Colors.green;
                        fetchApprovedAppointments();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: approvedButtonColor,
                    ),
                    child: Text('APPROVED'),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: _showApproved
                ? (approvedAppointments != null
                ? ListView.builder(
              itemCount: approvedAppointments!.length,
              itemBuilder: (context, index) {
                final reversedIndex = approvedAppointments!.length - 1 - index;
                final appointment = approvedAppointments![reversedIndex];
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
                          Text(
                            'PID               : ${appointment['patient_id']}',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Name         :    ${appointment['name']}',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'Date              : ${appointment['date']}',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 40),
                              ElevatedButton(
                                onPressed: () {
                                  // Add functionality if needed
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey, // Fixed to grey for approved requests
                                ),
                                child: Text('APPROVED'),
                              ),
                            ],
                          ),
                          SizedBox(height: .0),
                          Text(
                            'Status           : APPROVED',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
                : Center(child: CircularProgressIndicator()))
                : (appointments != null
                ? ListView.builder(
              itemCount: appointments!.length,
              itemBuilder: (context, index) {
                final reversedIndex = appointments!.length - 1 - index;
                final appointment = appointments![reversedIndex];
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
                          Text(
                            'PID               : ${appointment['patient_id']}',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Name         :    ${appointment['name']}',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'Date              : ${appointment['date']}',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 60),
                              ElevatedButton(
                                onPressed: () {
                                  approveAppointment(index); // Call the function to update status
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: appointment['status'] == 'APPROVED'
                                      ? Colors.grey
                                      : Colors.green,
                                ),
                                child: Text(appointment['status'] == 'APPROVED' ? 'APPROVED' : 'APPROVE'),
                              ),
                            ],
                          ),
                          SizedBox(height: .0),
                          Text(
                            'Status           : ${appointment['status']}',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
                : Center(child: CircularProgressIndicator())),
          ),
        ],
      ),
    );
  }
}
