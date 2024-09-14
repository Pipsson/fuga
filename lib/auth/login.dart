// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, must_be_immutable, prefer_const_constructors_in_immutables

import 'dart:convert';
import 'package:fugapp/api/auth_api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fugapp/auth/register.dart';
import 'package:fugapp/layouts/app_validator.dart';
import 'package:fugapp/layouts/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var isLoader = false;
  // var authService = AuthService();

  Future<void> storeAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('refresh_token', token);
  }

  // Submission method for the form
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });

      var data = {
        'email': _emailController.text,
        'password': _passwordController.text,
      };

      var url = Uri.parse('https://directus-fuga.smarcrib.site/auth/login');

      try {
        // Send the POST request to Directus login API
        var response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(data),
        );

        // Check if the response is successful
        if (response.statusCode == 200) {
          var responseBody = json.decode(response.body);

          // Assuming token is returned upon successful login
          var token = responseBody['data']['refresh_token'];

          print(token);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage()),
          );

          await storeAuthToken(token);
          // Store token or perform further actions (e.g., navigate to the next page)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login successful!')),
          );
        } else {
          // Handle non-200 responses (like invalid credentials)
          var errorBody = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Failed to log in: ${errorBody['error']['message']}')),
          );
        }
      } catch (error) {
        // Handle any exceptions during login
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to log in: $error')),
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
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 180), // Add spacing to adjust top padding
              Text(
                'Karibu',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  labelText: 'Barua pepe',
                  border: OutlineInputBorder(),
                ),
                validator: appValidator.validateEmail,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  labelText: 'Neno la siri',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.visibility),
                ),
                validator: appValidator.validatePassword,
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoader ? null : _submitForm,
                  child: isLoader
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Ingia', style: TextStyle(fontSize: 18)),
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Navigate to forgot password page (implement this in your app)
                },
                child: Text(
                  'Umesahau neno la siri?',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                child: Text(
                  'Huna account ? Fungua account',
                  style: TextStyle(color: Colors.teal),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
