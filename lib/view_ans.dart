import 'package:flutter/material.dart';
import 'package:schizo/search_dans.dart';
import 'package:schizo/search_wans.dart';
import 'package:schizo/view_ans.dart';

class ViewAnswersScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
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
              'View Answers',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            width: 100,
            height: 100,
            left: (430 - 110) / 2, // Adjusted based on the provided CSS
            top: 147,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchDailyQuestionsScreen()),
                    );
                // Handle tap on daily answers image
                print('Daily Answers tapped');
              },
              child: Image.asset('assets/result.png'), // Replace 'assets/image.png' with your image asset
            ),
          ),
          Positioned(
            width: 114,
            height: 21,
            right: 138,
            top: 262,
            child: Text(
              'Daily Answers',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.normal,
                fontSize: 17,
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            width: 100,
            height: 100,
            left: (430 - 110) / 2, // Adjusted based on the provided CSS
            top: 339,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchWeeklyQuestionsScreen()),
                );
                print('Weekly Answers tapped');
              },
              child: Image.asset('assets/result.png'), // Replace 'assets/image.png' with your image asset
            ),
          ),
          Positioned(
            width: 134,
            height: 21,
            right: 128,
            top: 454,
              child: Text(
                'Weekly Answers',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.normal,
                  fontSize: 17,
                  color: Colors.black,
                ),
              ),

          ),
        ],
      ),
    );
  }
}
