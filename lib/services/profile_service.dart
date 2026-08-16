import 'package:get/get.dart' hide Response;
import 'api_service.dart';
import '../core/api_constants.dart';
import '../models/user_model.dart';

class ProfileService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<UserModel?> fetchProfile() async {
    try {
      final response = await _apiService.get(ApiConstants.profile);
      print("Profile API Response: ${response.data}"); // Debug log
      
      if (response.data != null && response.data['success'] == true) {
        return UserModel.fromJson(response.data['data']);
      } else {
        print("Profile fetch failed: ${response.data?['message']}");
      }
    } catch (e) {
      print("Error fetching profile: $e");
    }
    return null;
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.put(ApiConstants.updateProfile, data: data);
      print("Update Profile Response: ${response.data}"); // Debug log
      return response.data != null && response.data['success'] == true;
    } catch (e) {
      print("Error updating profile: $e");
      return false;
    }
  }
}
