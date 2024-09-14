import 'package:flutter/material.dart';
import 'package:fugapp/auth/login.dart';
import 'package:fugapp/layouts/navigation.dart'; // Assuming this is for the dashboard/navigation page
import 'package:fugapp/pages/chick.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff125f98)),
        useMaterial3: true,
      ),
      home: LoadPage(),
    );
  }
}

class LoadPage extends StatefulWidget {
  const LoadPage({super.key});

  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNextPage();
  }

  Future<String?> retrieveAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('refresh_token');
    } catch (e) {
      // Handle error (you could log or display an error message)
      print('Error retrieving token: $e');
      return null;
    }
  }

  Future<void> _navigateToNextPage() async {
    await Future.delayed(const Duration(seconds: 3));

    final token = await retrieveAuthToken();

    if (token != null) {
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 300),
          child:  KukuRegistrationForm(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 300),
          child: LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/ometer_logo.png',
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
       
        ],
      ),
    );
  }
}
