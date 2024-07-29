import 'package:flutter/material.dart';
import 'package:schizo/view_apointment.dart';

class SearchAppointmentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            color: Colors.indigo[300],
          ),
          child: Center(
            child: Text(
              'Search By Patient Id',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Patient id',
                hintStyle: TextStyle(color: Colors.grey),
                contentPadding: EdgeInsets.all(12),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Replace with actual number of patients
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navigate to the predefined page (replace DetailPage() with your actual page)
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ViewAppointments()),
                      );
                    },
                    child: Card(
                      child: ListTile(
                        title: Text('Patient ${index + 1}'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Predefined detail page widget

