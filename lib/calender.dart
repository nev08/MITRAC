import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'common.dart ';

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                color: Colors.indigo[300], // Change the color as needed
              ),
              child: Center(
                child: Text(
                  'Book Your Appointment',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 97,
            left: 0,
            right: 0,
            child: CalendarView(),
          ),
          Positioned(
            top: 438,
            left: (MediaQuery.of(context).size.width - 286) / 2,
            child: Image.asset(
              'assets/img.png', // Replace 'img.png' with your image asset path
              width: 286,
              height: 232,
            ),
          ),
        ],
      ),
    );
  }
}

class CalendarView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CalendarDatePicker(
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      onDateChanged: (date) {
        // Handle date changes
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AvailableSlots1Page(selectedDate: date),
          ),
        );
      },
    );
  }
}

class AvailableSlots1Page extends StatefulWidget {
  final DateTime selectedDate; // Define selectedDate parameter

  AvailableSlots1Page({required this.selectedDate}); // Constructor

  @override
  _AvailableSlots1PageState createState() => _AvailableSlots1PageState();
}

class _AvailableSlots1PageState extends State<AvailableSlots1Page> {
  TextEditingController _pidController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Wrap Column with SingleChildScrollView
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  color: Colors.blue,
                ),
                child: Center(
                  child: Text(
                    "Request Page",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20), // Add some space
              Card(
                margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20), // Adjust vertical margin
                elevation: 30.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _pidController,
                        decoration: InputDecoration(
                          hintText: 'PID',
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Name',
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        children: [
                          Text(
                            "DATE      :",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              widget.selectedDate.toString(),
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () {
                          // Handle button press
                          submitAppointment(context);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: EdgeInsets.all(16.0),
                          backgroundColor: Colors.blue, // You can change the color here
                        ),
                        child: Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitAppointment(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse(book),
        body: {
          'pid': _pidController.text,
          'name': _nameController.text,
          'date': widget.selectedDate.toString(),
        },
      );

      if (response.statusCode == 200) {
        // Show success Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Appointment submitted successfully'),
            duration: Duration(seconds: 1),
          ),
        );
        // Navigate back to the previous page after showing the Snackbar
          Navigator.pop(context);

      } else {
        // Show failure Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit appointment'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      // Show error Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }


  @override
  void dispose() {
    _pidController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
