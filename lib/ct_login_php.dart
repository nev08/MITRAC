// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'ct_dash.dart';
//
// Future<void> login(BuildContext context, String email, String password) async {
//   final String url = 'https://yourwebsite.com/login.php'; // Replace with your PHP endpoint URL
//
//   final response = await http.post(
//     Uri.parse(url),
//     body: jsonEncode({
//       'mail': email,
//       'password': password,
//     }),
//     headers: {'Content-Type': 'application/json'},
//   );
//
//   final responseData = jsonDecode(response.body);
//
//   if (response.statusCode == 200) {
//     if (responseData['status'] == 'success') {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => ct_dash(c_id: c_id, CaretakerDetails: CaretakerDetails)),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(responseData['message'])),
//       );
//     }
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Failed to connect to server')),
//     );
//   }
// }
