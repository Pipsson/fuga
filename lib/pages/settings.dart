// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fugapp/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var isLogoutLoading = false;


Future<void> logOut() async {
  setState(() {
    isLogoutLoading = true;
  });

  try {
    // Retrieve the stored token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('refresh_token');

    if (token == null) {
      print('No token found');
      return;
    }

    // Make the HTTP request to log out from Directus
    final response = await http.post(
      Uri.parse('https://directus-fuga.smarcrib.site/auth/logout'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // If logout is successful, clear the token and navigate to the login page
      await prefs.remove('access_token');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      // Handle unsuccessful logout (optional: show a message to the user)
      print('Logout failed: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error during logout: $e');
  } finally {
    setState(() {
      isLogoutLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Settings",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 94, 92, 226),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Umebakiza Siku 12 za kutumia app yetu",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      // Action when the "Lipia Hapa" link is tapped
                    },
                    child: Text(
                      "Lipia Hapa!",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Profile"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Action when Profile is tapped
              },
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text("Password"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Action when Password is tapped
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text("Notifications"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Action when Notifications is tapped
              },
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.help_outline),
              title: Text("Msaada"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Action when Msaada is tapped
              },
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Log out"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                logOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
