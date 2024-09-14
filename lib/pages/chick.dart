import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fugapp/layouts/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KukuRegistrationForm extends StatefulWidget {
  @override
  _KukuRegistrationFormState createState() => _KukuRegistrationFormState();
}

class _KukuRegistrationFormState extends State<KukuRegistrationForm> {
  final TextEditingController _idadiController = TextEditingController();
  final TextEditingController _umriController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  String? selectedAina;

  final List<String> ainaKuku = [
    'Kuku wa Kienyeji',
    'Kuku wa Kisasa'
  ]; // Example chicken types

  final _formKey = GlobalKey<FormState>();

  // Auth service to obtain the create user method

  var isLoader = false;

  Future<void> _submitForm() async {
     final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('refresh_token');

    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });

      var data = {
        'idadi': _idadiController.text, // Directus expects snake_case keys
        'umri': _umriController.toString(),
        'aina': _typeController.text,
        // Assuming 'phone' field exists in your API
      };

      var url = Uri.parse('https://directus-fuga.smarcrib.site/users');

      try {
        // Send POST request to register the user
        var response = await http.post(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json.encode(data),
        );

        // Check if the response is successful
        if (response.statusCode == 200 || response.statusCode == 201) {
          // On success, navigate to the NavigationPage or another page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage()),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful!')),
          );
        } else {
          // Handle non-200 responses (like validation errors or bad requests)
          var errorBody = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Failed to register: ${errorBody['errors'][0]['message']}')),
          );
        }
      } catch (error) {
        // Handle any exceptions during the registration process
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to register: $error')),
        );
      } finally {
        setState(() {
          isLoader = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weka taarifa za awali'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdown for selecting "Aina ya Kuku"
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Aina ya kuku',
                  border: OutlineInputBorder(),
                ),
                value: selectedAina,
                onChanged: (value) {
                  setState(() {
                    selectedAina = value;
                  });
                },
                items: ainaKuku.map((String aina) {
                  return DropdownMenuItem<String>(
                    value: aina,
                    child: Text(aina),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tafadhali chagua aina ya kuku';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Input for "Idadi"
              TextFormField(
                controller: _idadiController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Idadi',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tafadhali weka idadi ya kuku';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Input for "Umri"
              TextFormField(
                controller: _umriController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Umri (Tarehe ya siku 1)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tafadhali weka umri wa kuku';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),

              // Register Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle form submission
                      print('Aina ya kuku: $selectedAina');
                      print('Idadi: ${_idadiController.text}');
                      print('Umri: ${_umriController.text}');
                    }
                  },
                  child: Text('Jisajili'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, // Button color
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
