import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'common.dart';

class Notifications extends StatefulWidget {
  final Function onNotificationsRead; // Callback to notify parent widget

  Notifications({required this.onNotificationsRead});

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<dynamic> notifications = [];

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    final response = await http.get(Uri.parse(retrieve));

    if (response.statusCode == 200) {
      setState(() {
        notifications = jsonDecode(response.body)['messages'];
        print(notifications);
      });
      markAllNotificationsAsRead(); // Mark notifications as read after they are loaded
    } else {
      print('Failed to load notifications');
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    final response = await http.post(
      Uri.parse(markread), // Your API endpoint to mark all notifications as read
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      widget.onNotificationsRead(); // Notify parent widget to update unread count
    } else {
      print('Failed to mark notifications as read');
      print(response.body); // Debugging: Print the response body
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[300],
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30), // Adjust as needed
          ),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: notifications.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            var notification = notifications[index];
            //var patientId = notification['patient_id'] ?? 'Unknown';
            var message = notification['message'] ?? 'No message';
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              elevation: 4,
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.notifications),
                  backgroundColor: Colors.indigo[300],
                ),
                title: Text(
                  'MISSED STREAK',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(message),
                trailing: Text(notification['timestamp'] ?? ''),
              ),
            );
          },
        ),
      ),
    );
  }
}
