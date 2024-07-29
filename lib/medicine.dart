import 'package:flutter/material.dart';

class MedicineDetailsDialog extends StatelessWidget {
  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();
  final List<String> _sessionOptions = ['Morning', 'Afternoon', 'Evening'];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Medicine Details",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _medicineNameController,
              decoration: InputDecoration(
                hintText: "Medicine Name",
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _doseController,
              decoration: InputDecoration(
                hintText: "Dose",
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              items: _sessionOptions.map((String session) {
                return DropdownMenuItem<String>(
                  value: session,
                  child: Text(session),
                );
              }).toList(),
              onChanged: (String? value) {},
              decoration: InputDecoration(
                hintText: "Session",
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            // Function to save
          },
          child: Text("Save"),
        ),
      ],
    );
  }
}
