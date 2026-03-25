import 'package:shared_preferences/shared_preferences.dart';
import '../../model/otp_response_model/otp_response_model.dart';


class SessionManager {

  /// ================= SAVE USER =================
  static Future<void> saveUser(UserData user) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("token", user.accessToken);
    await prefs.setString("name", user.name);
    await prefs.setString("email", user.email);
    await prefs.setString("phone", user.phone);
    await prefs.setString("type", user.type);
    await prefs.setString("unique_id", user.uniqueId);
    await prefs.setInt("id", user.id);
  }

  /// ================= GET TOKEN =================
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("id");
  }

  /// ================= GET NAME =================
  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("name");
  }

  /// ================= GET EMAIL =================
  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("email");
  }

  /// ================= GET PHONE =================
  static Future<String?> getPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("phone");
  }

  /// ================= CHECK LOGIN =================
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token") != null;
  }

  static Future<String?> getType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("type");
  }

  static Future<String?> getUniqueId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("unique_id");
  }
  /// ================= CLEAR SESSION (LOGOUT) =================
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}