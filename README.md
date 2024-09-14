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
    await prefs.setString('access_token', token);
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
          var token = responseBody['data']['access_token'];

print(token);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>DashboardPage()),
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





// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fugapp/layouts/navigation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _errorMessage = '';

  final String loginUrl = "https://directus-fuga.smarcrib.site/auth/login";


 Future<void> storeAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http
          .post(
            Uri.parse(loginUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              "email": _emailController.text.trim(),
              "password": _passwordController.text.trim(),
            }),
          )
          .timeout(Duration(seconds: 10), onTimeout: () {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Request timed out. Please try again.';
          });
        }
        return http.Response('Error', 500); // Return a 500 status on timeout
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("User logged in: ${data['data']['access_token']}");

         await storeAuthToken(data['data']['access_token']);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login successful!')),
          );


   Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>DashboardPage()),
          );

        }
      } else {
        final errorData = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            _errorMessage = 'Failed to login: ${errorData['errors']?.first['message'] ?? 'Unknown error'}';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'An error occurred. Please try again.';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _login,
                      child: Text('Login'),
                    ),
              SizedBox(height: 16),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}