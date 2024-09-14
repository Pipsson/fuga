
import 'package:shared_preferences/shared_preferences.dart';

class Api {

  Future<void> storeAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('refresher_token', token);
  }

  // Method to retrieve the API token from secure storage
  Future<String?> retrieveAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresher_token');
  }

}