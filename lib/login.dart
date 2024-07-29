import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'doc_login.dart';
import 'ct_login.dart';
import 'admin_login.dart';

class LoginsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 50.0, left: 50.0),
              child: Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 50.0),
            Center(
              child: Container(
                width: 300.0,
                height: 400.0,
                margin: EdgeInsets.only(top: 40.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white, // or any other color you want
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DoctorLogin()), // Change DoctorLoginPage to your actual doctor login page
                        );
                      },
                      child: Card(
                        elevation: 10.0,
                        shape: CircleBorder(),
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundColor: Color(0xFF87CEEB),
                          backgroundImage: AssetImage('assets/doct.png'),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Doctor Login',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23.0,
                      ),
                    ),
                    SizedBox(height: 50.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CareTakeLoginPage()), // Change CareTakerLoginPage to your actual caretaker login page
                        );
                      },
                      child: Card(
                        elevation: 10.0,
                        shape: CircleBorder(),
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundColor: Color(0xFF87CEEB),
                          backgroundImage: AssetImage('assets/ct.png'),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Care Taker Login',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(height: 90.0, width: 100),
             Text(
              'Are you admin ?',
              style: TextStyle(
                //fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 20.0,
                color: Colors.black, // Set text color to blue
              ),
            ),// Adjust spacing as needed
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminLoginPage()), // Change CareTakerLoginPage to your actual caretaker login page
                );
              },
                child: Text(
                  'Admin',
                  style: TextStyle(
                    //fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 20.0,
                    color: Colors.blue, // Set text color to blue
                  ),
                ),
              ),
            ],
            )
    ]
        ),
      ),
    );
  }
}
