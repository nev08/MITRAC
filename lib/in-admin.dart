import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'add_doc.dart';

class Adminpage extends StatelessWidget {
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
            SizedBox(height: 100.0),
            Center(
              child: Container(
                width: 350.0,
                height: 450.0,
                margin: EdgeInsets.only(top: 40.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.grey[300],
                  border: Border.all(
                    color: Colors.black!,
                    width: 2.0,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => CaretakerProfileDisplay()),
                        // );
                      },
                      child: Image.asset(
                        'assets/young.png',
                        width: 120,
                        height: 120,
                      ),
                    ),
                    SizedBox(height: 40), // Added SizedBox for spacing
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Adddoctor()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                      ),
                      child: Text('Add Doctor', style: TextStyle(fontSize: 20)),
                    ),
                    SizedBox(height: 30), // Added SizedBox for spacing
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
