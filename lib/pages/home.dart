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
        
        children: [
          SizedBox(
            height: 40,
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFE0F7FA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                "Kiwango cha chakula siku ya leo ni :\n12 kg",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
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
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, '/sajiliKuku');
      },
      style: ElevatedButton.styleFrom(
        
        backgroundColor: Colors.teal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text('+ Sajili kuku', style: TextStyle(color:Colors.white, fontSize: 16)),
    );
  }
}
