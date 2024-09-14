// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, must_be_immutable, prefer_const_constructors_in_immutables, use_build_context_synchronously

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:fugapp/layouts/app_validator.dart';
import 'package:fugapp/layouts/navigation.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  // Text controllers for each input field
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _regionController = TextEditingController();
  final _emailController = TextEditingController(); // Email controller
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Auth service to obtain the create user method

  var isLoader = false;


Future<void> _submitForm() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      isLoader = true;
    });

    // Collect the user data from the form fields
    var data = {
      'first_name': _firstNameController.text,  // Directus expects snake_case keys
      'last_name': _lastNameController.text,
      // 'region': _regionController.text,
      'email': _emailController.text,           // Email is required for user registration
      'password': _passwordController.text,     // Password is required
      'phone': _phoneNumberController.text,     // Assuming 'phone' field exists in your API
    };

    var url = Uri.parse('https://directus-fuga.smarcrib.site/users');

    try {
      // Send POST request to register the user
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
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
              content: Text('Failed to register: ${errorBody['errors'][0]['message']}')),
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


  var appValidator = AppValidator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ingiza taarifa zako'),
      ),
      body: SingleChildScrollView(  // Wrap with SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 16),
              // First Name Field
              TextFormField(
                controller: _firstNameController,
                decoration: _buildInputDecoration('Jina la kwanza'),
                validator: appValidator.validateUsername,
              ),
              SizedBox(height: 16),
              // Last Name Field
              TextFormField(
                controller: _lastNameController,
                decoration: _buildInputDecoration('Jina la ukoo'),
                validator: appValidator.validateUsername,
              ),
              SizedBox(height: 16),
              // Region Field
              TextFormField(
                controller: _regionController,
                decoration: _buildInputDecoration('Mkoa'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tafadhali ingiza mkoa';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: _buildInputDecoration('Barua pepe'),
                keyboardType: TextInputType.emailAddress,
                validator: appValidator.validateEmail,
              ),
              SizedBox(height: 16),
              // Phone Number Field
              TextFormField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: _buildInputDecoration('Namba ya simu'),
                validator: appValidator.validatePhoneNumber,
              ),
              SizedBox(height: 16),
              // Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: _buildInputDecoration('Neno la siri'),
                validator: appValidator.validatePassword,
              ),
              SizedBox(height: 16),
              // Confirm Password Field
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: _buildInputDecoration('Rudia neno la siri'),
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Maneno ya siri hayafanani';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              // Submit Button
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00796B), // Button background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: isLoader ? null : _submitForm,
                  child: isLoader
                      ? Center(child: CircularProgressIndicator())
                      : Text(
                          'Jiunge',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      fillColor: Colors.white,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.teal),
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
    );
  }
}
