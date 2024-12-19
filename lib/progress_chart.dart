import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'common.dart';

class ProgressChart extends StatefulWidget {
  final String patientId;
  const ProgressChart({required this.patientId});

  @override
  _ProgressChartState createState() => _ProgressChartState();
}

class _ProgressChartState extends State<ProgressChart> {
  double streakPercentage = 0.0;

  Future<void> fetchStreakPercentage() async {
    print("im called");
    try {
      final response = await http.get(Uri.parse( ip+"/"+'STREAKZ.php?id=${widget.patientId}'));
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          streakPercentage = data['streakPercentage'] / 100;
        });
      } else {
        // Handle error: response not 200
        print('Error: Failed to load streak percentage');
      }
    } catch (error) {
      // Handle exception
      print('Exception occurred: $error');
    }
  }


  @override
  void initState() {
    super.initState();
    // Replace `1` with your actual patient ID
    fetchStreakPercentage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 100),
              Card(
                elevation: 50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  width: 300,
                  height: 400,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            'Streak Percentage:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Container(
                          width: 200,
                          height: 200,
                          child: CustomPaint(
                            painter: RingPainter(
                              progress: streakPercentage,
                              ringColor: Colors.grey,
                              progressColor: Colors.blue,
                            ),
                            child: Center(
                              child: Text(
                                '${(streakPercentage * 100).toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 30,
                            height: 20,
                            color: Colors.greenAccent,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Streak Level',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
}

class RingPainter extends CustomPainter {
  final double progress;
  final Color ringColor;
  final Color progressColor;

  RingPainter({required this.progress, required this.ringColor, required this.progressColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 20) / 2;
    final strokeWidth = 10.0;

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

    final startAngle = -90 * (3.1415926535897932 / 180);
    final sweepAngle = progress * 2 * 3.1415926535897932;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
