import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final Box _settingsBox = Hive.box('settings_box');
  final Box<User> _usersBox = Hive.box<User>('users_box');

  bool get isLoggedIn {
    return _settingsBox.get('isLoggedIn', defaultValue: false);
  }

  String get currentUserEmail {
    return _settingsBox.get('currentUser', defaultValue: '');
  }

  // Lấy thông tin user hiện tại
  User? get currentUser {
    final email = currentUserEmail;
    if (email.isEmpty) return null;

    for (User user in _usersBox.values) {
      if (user.email == email) {
        return user;
      }
    }
    return null;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(email);
  }

  // Đăng ký tài khoản
  Future<String?> register({
    required String email,
    required String password,
    required String confirmPassword,
    String? displayName,
  }) async {
    final trimmedEmail = email.trim().toLowerCase();

    if (trimmedEmail.isEmpty) {
      return 'Vui lòng nhập email';
    }
    if (!_isValidEmail(trimmedEmail)) {
      return 'Email không hợp lệ';
    }
    if (password.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    if (password != confirmPassword) {
      return 'Mật khẩu xác nhận không chính xác';
    }

    // Kiểm tra email đã tồn tại chưa
    for (User user in _usersBox.values) {
      if (user.email == trimmedEmail) {
        return 'Email đã được đăng ký';
      }
    }

    // Tạo user mới
    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: trimmedEmail,
      password: password,
      displayName: displayName?.trim(),
      createdAt: DateTime.now(),
    );

    await _usersBox.add(newUser);
    await _usersBox.flush();

    notifyListeners();

    return null;
  }

  // Đăng nhập
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    final trimmedEmail = email.trim().toLowerCase();

    if (trimmedEmail.isEmpty) {
      return 'Vui lòng nhập email';
    }
    if (password.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }

    // Tìm user
    User? user;
    for(User u in _usersBox.values) {
      if (u.email == trimmedEmail) {
        user = u;
        break;
      }
    }

    if (user == null) {
      return 'Tài khoản không tồn tại';
    }
    if (user.password != password) {
      return 'Mật khẩu không đúng';
    }

    await _settingsBox.put('isLoggedIn', true);
    await _settingsBox.put('currentUser', trimmedEmail);
    await _settingsBox.flush();
    notifyListeners();

    return null;
  }

  // Đăng xuất
  Future<void> logout() async {
    await _settingsBox.put('isLoggedIn', false);
    await _settingsBox.put('currentUser', '');
    await _settingsBox.flush();
    notifyListeners();
  }

  // Cập nhật thông tin user
  Future<String?> updateProfile({String? displayName}) async {
    User? user = currentUser;
    if (user == null) return 'Không tìm thấy người dùng';

    if (displayName != null) {
      user.displayName = displayName.trim();
    }
    await user.save();
    await _usersBox.flush();
    notifyListeners();
    return null;
  }

  /// Đổi mật khẩu
  Future<String?> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    User? user = currentUser;
    if (user == null) return 'Không tìm thấy người dùng';

    if (currentPassword.isEmpty) {
      return 'Vui lòng nhập mật khẩu hiện tại';
    }
    if (user.password != currentPassword) {
      return 'Mật khẩu hiện tại không đúng';
    }
    if (newPassword.length < 6) {
      return 'Mật khẩu mới phải có ít nhất 6 ký tự';
    }
    if (newPassword != confirmNewPassword) {
      return 'Mật khẩu xác nhận không khớp';
    }
    if (newPassword == currentPassword) {
      return 'Mật khẩu mới phải khác mật khẩu hiện tại';
    }

    user.password = newPassword;
    await user.save();
    await _usersBox.flush();
    notifyListeners();
    return null;
  }

  
}
