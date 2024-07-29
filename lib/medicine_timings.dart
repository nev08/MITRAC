import 'package:flutter/material.dart';

class MedicineTimings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            color: Colors.white, // Change color as needed
          ),
          // Top Border
          Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.indigo[300], // Change color as needed
            ),
          ),
          // Cards
          Positioned(
            bottom: 401,
            right: 59,
            child: CardWidget(
              title: "Before Taking Food",
              image: "assets/pills.png",
            ),
          ),
          Positioned(
            bottom: 120,
            right: 59,
            child: CardWidget(
              title: "After Taking Food",
              image: "assets/pills.png",
            ),
          ),
        ],
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String title;
  final String image;

  const CardWidget({
    Key? key,
    required this.title,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        width: 300,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            SizedBox(height: 10),
            Image.asset(
              image,
              width: 100,
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
