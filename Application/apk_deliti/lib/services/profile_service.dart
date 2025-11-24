import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import 'api_service.dart';

class ProfileService {
  static Future<UserProfile?> getCurrentUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    
    if (userId == null) return null;
    
    final result = await ApiService.getUserProfile(userId);
    if (result['success'] == true) {
      return UserProfile.fromJson(result['profile']);
    }
    return null;
  }

  static Future<bool> updateProfile(Map<String, dynamic> profileData) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    
    if (userId == null) return false;
    
    final result = await ApiService.updateProfile(userId, profileData);
    return result['success'] == true;
  }

  static Future<bool> uploadProfilePicture(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    
    if (userId == null) return false;
    
    final result = await ApiService.uploadProfilePicture(userId, imagePath);
    return result['success'] == true;
  }
}