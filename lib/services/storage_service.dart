import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user.dart';

class StorageService {
  static const String _key = 'users';

  Future<void> saveUsers(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = users.map((user) => user.toJson()).toList();
    await prefs.setString(_key, jsonEncode(userJson));
  }

  Future<List<User>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_key);
    if (userJson == null) return [];
    final userList = jsonDecode(userJson) as List;
    return userList.map((json) => User.fromJson(json)).toList();
  }
}