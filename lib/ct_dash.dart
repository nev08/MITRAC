import 'package:flutter/material.dart';
import 'ct_login.dart';
import 'ct_profile.dart';
import 'dq.dart';
import 'calender.dart';
import 'view_appointment.dart';
import 'medicine_monitoring.dart';
import 'wq.dart';
import 'excercise_video.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'common.dart';

class ct_dash extends StatefulWidget {
  final String? selectedRelationship;
  final String patientId;
  final String c_id;

  ct_dash({Key? key, this.selectedRelationship, required this.patientId, required this.c_id}) : super(key: key);

  @override
  _ct_dashState createState() => _ct_dashState();
}

class _ct_dashState extends State<ct_dash> {
  late Future<double> _streakFuture;

  @override
  void initState() {
    super.initState();
    _streakFuture = fetchStreakPercentage(int.parse(widget.patientId));
  }

  Future<void> _refreshStreak() async {
    setState(() {
      _streakFuture = fetchStreakPercentage(int.parse(widget.patientId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to the login page when the back button is pressed
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => CareTakeLoginPage()),
          ModalRoute.withName('/'), // This ensures that PLoginPage becomes the new root
        );
        return false; // Prevents default back button behavior
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      'Hello Care Taker',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 100),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CaretakerProfile(c_id: widget.c_id, patient_id: widget.patientId),
                          ),
                        );
                      },
                      child: Image.asset(
                        'assets/ct.png',
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 50),
                // Display the selected relationship here
                Text(
                  'Relationship: ${widget.selectedRelationship ?? "None"}',
                  style: TextStyle(
                    fontSize: 18,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
                // Display the entered patient ID here
                Text(
                  'Patient ID: ${widget.patientId}',
                  style: TextStyle(
                    fontSize: 18,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 10,
                  child: Container(
                    width: 350,
                    height: 450,
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black.withOpacity(0.8),
                        width: 3.0, // Set the border width here
                      ),
                      borderRadius: BorderRadius.circular(10.0), // Optional: Add border radius if needed
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Q1(c_id: widget.c_id,patientId: widget.patientId,selectedRelationship: widget.selectedRelationship,)),
                                    );
                                  },
                                  child: Image.asset(
                                    'assets/qnda.png',
                                    width: 80,
                                    height: 100,
                                  ),
                                ),
                                Text('Daily Questions'),
                              ],
                            ),
                            SizedBox(height: 10),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => CalendarScreen()),
                                    );
                                  },
                                  child: Image.asset(
                                    'assets/book.png',
                                    width: 80,
                                    height: 100,
                                  ),
                                ),
                                Text('Book Appointment'),
                              ],
                            ),
                            SizedBox(height: 15),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => DisplayVideos()),
                                    );
                                  },
                                  child: Image.asset(
                                    'assets/vid.png',
                                    width: 90,
                                    height: 100,
                                  ),
                                ),
                                Text('Exercise Videos'),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => SQ1(c_id: widget.c_id,patientId: widget.patientId,selectedRelationship: widget.selectedRelationship,)),
                                    );
                                  },
                                  child: Image.asset(
                                    'assets/qnda.png',
                                    width: 80,
                                    height: 100,
                                  ),
                                ),
                                Text('Weekly Questions'),
                              ],
                            ),
                            SizedBox(height: 10),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => BookedSlotsPage(patientId: widget.patientId)),
                                    );
                                  },
                                  child: Image.asset(
                                    'assets/book.png',
                                    width: 80,
                                    height: 100,
                                  ),
                                ),
                                Text('View Appointment'),
                              ],
                            ),
                            SizedBox(height: 15),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    bool? result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MedicineMonitoring(patientId: widget.patientId,c_id: widget.c_id,selectedRelationship: widget.selectedRelationship),
                                      ),
                                    );
                                    if (result == true) {
                                      _refreshStreak();
                                    }
                                  },
                                  child: Image.asset(
                                    'assets/research.png',
                                    width: 90,
                                    height: 100,
                                  ),
                                ),
                                Text('Medicine Monitoring'),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Card to display patient ID and streak diagram
                Container(
                  width: 340, // Adjust width as needed
                  height: 160, // Ensure this height accommodates all content
                  padding: EdgeInsets.all(16.0), // Adjust padding as needed
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.5),
                      width: 3.0, // Set the border width here
                    ),
                    borderRadius: BorderRadius.circular(10.0), // Optional: Add border radius if needed
                    color: Colors.deepPurple[50],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Patient ID: ${widget.patientId}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Streak Level:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            FutureBuilder(
                              future: _streakFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(child: Text('Error loading streak percentage'));
                                } else {
                                  double streakPercentage = snapshot.data as double;
                                  return Text(
                                    '${(streakPercentage * 100).toStringAsFixed(1)}%',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20), // Adjust spacing between columns
                      Container(
                        width: 160,
                        height: 150,
                        child: FutureBuilder(
                          future: _streakFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error loading streak percentage'));
                            } else {
                              double streakPercentage = snapshot.data as double;
                              return CustomPaint(
                                painter: RingPainter(
                                  progress: streakPercentage,
                                  ringColor: Colors.grey.withOpacity(0.3),
                                  progressColor: Colors.blue,
                                ),
                                child: Center(
                                  child: Text(
                                    '${(streakPercentage * 100).toStringAsFixed(1)}%',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<double> fetchStreakPercentage(int id) async {
    final response = await http.get(Uri.parse(ip+"/"+'STREAKZ.php?id=$id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      double streakPercentage = data['streakPercentage'] / 100;

      if (streakPercentage == 0) {
        sendNotificationToDoctor(id);
      }

      return streakPercentage;
    } else {
      throw Exception('Failed to load streak percentage');
    }
  }


  void sendNotificationToDoctor(int patientId) async {
    final response = await http.post(
      Uri.parse(insert_noti),
      body: jsonEncode({
        'patientId': patientId,
        'message': 'Patient ID $patientId has missed three days of medication'
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send notification');
    }
  }

}


class RingPainter extends CustomPainter {
  final double progress;
  final Color ringColor;
  final Color progressColor;

  RingPainter({required this.progress, required this.ringColor, required this.progressColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 10) / 3;
    final strokeWidth = 12.0;

    final ringPaint = Paint()
      ..color = ringColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;


    canvas.drawCircle(center, radius, ringPaint);

    final progressAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      progressAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
