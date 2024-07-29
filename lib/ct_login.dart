import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'relation.dart';
import 'common.dart';

class CareTakeLoginPage extends StatefulWidget {
  @override
  State<CareTakeLoginPage> createState() => _CareTakeLoginPageState();
}

class _CareTakeLoginPageState extends State<CareTakeLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> checksignup() async {
    String c_id = _emailController.text;
    String password = _passwordController.text;

    if (c_id.isEmpty || password.isEmpty) {
      // Show an error message if either email or password is empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Failed'),
            content: Text('Please enter both email and password'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return; // Exit the function if validation fails
    }

    // Prepare the JSON data
    Map<String, dynamic> data = {
      "c_id": c_id,
      "password": password,
    };

    var url = Uri.parse(ct_login);
    var response = await http.post(
      url,
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    // Handle the response
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      print(responseData); // Print the response data from the backend

      // If login successful, navigate to next screen
      if (responseData['status'] == 'success') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('c_id', _emailController.text);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CareTakerPatientRelationship(
              c_id: c_id, // Pass CaretakerDetails from the response data
            ),
          ),
        );
      } else {
        // Show an error message if login fails
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text('Invalid email or password'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Handle other status codes here, if needed
      print('Request failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg2.png'), // Your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Login form
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 60), // Adjust height as needed
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "WELCOME",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 60),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    elevation: 50,
                    child: Container(
                      width: 330,
                      height: 460,
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/LOG.png',
                            width: 150,
                            height: 150,
                          ),
                          SizedBox(height: 30),
                          TextFormField(
                            controller: _emailController, // Assign controller
                            decoration: InputDecoration(
                              hintText: 'User ID',
                              prefixIcon: Icon(Icons.person),
                              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController, // Assign controller
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: checksignup,
                            child: Text('Login'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
