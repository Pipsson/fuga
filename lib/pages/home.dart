import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? token;

  @override
  void initState() {
    super.initState();
    retrieveAuthToken();
  }

  Future<String?> retrieveAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return token = prefs.getString('access_token');
    } catch (e) {
      // Handle error (you could log or display an error message)
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          // Top section with two containers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTopContainer("Kiwango cha chakula siku ya leo ni :", "12 kg"),
              _buildTopContainer("Chakula Kutumika siku:", "17"),
            ],
          ),
          SizedBox(height: 16),
          // Grid items
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.4,
              children: [
                _buildGridItem(context, "Matumizi", Color(0xFFFFF3E0), '/matumizi'),
                _buildGridItem(context, "Chanjo na\nDawa", Color(0xFFE8F5E9), '/chanjoNaDawa'),
                _buildGridItem(context, "Makadirio", Color(0xFFF3E5F5), '/makadirio'),
                _buildGridItem(context, "Vifo", Color(0xFFFFFDE7), '/vifo'),
                _buildAgizaItem(context),
                _buildSajiliButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopContainer(String title, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFFE0F7FA),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, String title, Color color, String routeName) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildAgizaItem(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/agiza');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.store, color: Colors.blue, size: 32),
            SizedBox(height: 8),
            Text('Agiza', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildSajiliButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/sajiliKuku');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            '+ Sajili kuku',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
