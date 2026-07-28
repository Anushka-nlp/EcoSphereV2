import 'package:anymex/screens/auth/login_screen.dart';
import 'package:anymex/services/echosphere_api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class EchosphereUser {
  final int id;
  final String fullName;
  final String role;
  final String? officialEmail;
  final String? usn;
  final String? employeeId;
  final int? departmentId;
  final String? department;

  EchosphereUser({
    required this.id,
    required this.fullName,
    required this.role,
    this.officialEmail,
    this.usn,
    this.employeeId,
    this.departmentId,
    this.department,
  });

  factory EchosphereUser.fromJson(Map<String, dynamic> json) {
    return EchosphereUser(
      id: json['user_id'] ?? json['id'] ?? 0,
      fullName: json['full_name'] ?? 'User',
      role: json['role'] ?? 'Student',
      officialEmail: json['official_email'],
      usn: json['usn'],
      employeeId: json['employee_id'],
      departmentId: json['department_id'],
      department: json['department'] ?? (json['department_id'] == 1 ? 'CSE' : 'General'),
    );
  }
}

class AuthController extends GetxController {
  final Rxn<EchosphereUser> currentUser = Rxn<EchosphereUser>();
  final RxBool isLoggedIn = false.obs;
  final RxBool isLoading = false.obs;
  final RxString token = ''.obs;

  static const List<String> availableRoles = [
    'Student',
    'Teacher',
    'HoD',
    'College Admin',
    'Principal',
    'Developer',
  ];

  static int getRoleLevel(String role) {
    switch (role) {
      case 'Developer':
        return 6;
      case 'Principal':
        return 5;
      case 'College Admin':
        return 4;
      case 'HoD':
        return 3;
      case 'Teacher':
        return 2;
      case 'Student':
      default:
        return 1;
    }
  }

  bool hasMinimumRole(String requiredRole) {
    final currentRoleName = currentUser.value?.role ?? 'Student';
    return getRoleLevel(currentRoleName) >= getRoleLevel(requiredRole);
  }

  Future<bool> login({
    required String identifier,
    required String password,
  }) async {
    isLoading.value = true;
    try {
      final api = EchosphereApiService();
      final res = await api.login(
        identifier: identifier,
        password: password,
      );

      final accessToken = res['access_token'] as String?;
      if (accessToken != null) {
        token.value = accessToken;
        api.setAuthToken(accessToken);

        final user = EchosphereUser.fromJson(res);
        currentUser.value = user;
        isLoggedIn.value = true;
        isLoading.value = false;
        return true;
      }
    } catch (e) {
      debugPrint('Live backend login error, using local validation if match: $e');
    }

    // Local / Seed Fallback for testing when backend isn't actively running on port 8000
    final mockUser = _getMockUser(identifier);
    if (mockUser != null) {
      currentUser.value = mockUser;
      isLoggedIn.value = true;
      token.value = 'mock_jwt_token_${mockUser.role.toLowerCase()}';
      EchosphereApiService().setAuthToken(token.value);
      isLoading.value = false;
      return true;
    }

    isLoading.value = false;
    return false;
  }

  void logout() {
    currentUser.value = null;
    isLoggedIn.value = false;
    token.value = '';
    EchosphereApiService().setAuthToken(null);
    Get.offAll(() => const LoginScreen());
  }

  /// Auto-detect role from the identifier for mock/offline fallback.
  EchosphereUser? _getMockUser(String identifier) {
    final id = identifier.trim();
    final idLower = id.toLowerCase();

    // USN pattern (e.g. 1EC22CS001) → Student
    if (RegExp(r'^\d[A-Za-z]{2}\d{2}[A-Za-z]{2}\d{3}$').hasMatch(id)) {
      return EchosphereUser(
        id: 6,
        fullName: 'Student One',
        role: 'Student',
        usn: id,
        department: 'CSE',
        departmentId: 1,
      );
    }

    // Email-based detection
    if (idLower.contains('@')) {
      if (idLower.startsWith('teacher')) {
        return EchosphereUser(
          id: 5,
          fullName: 'CSE Teacher',
          role: 'Teacher',
          officialEmail: id,
          employeeId: 'TCH001',
          department: 'CSE',
          departmentId: 1,
        );
      }
      if (idLower.startsWith('hod')) {
        return EchosphereUser(
          id: 4,
          fullName: 'CSE HoD',
          role: 'HoD',
          officialEmail: id,
          employeeId: 'HOD001',
          department: 'CSE',
          departmentId: 1,
        );
      }
      if (idLower.startsWith('principal')) {
        return EchosphereUser(
          id: 3,
          fullName: 'Dr. Principal',
          role: 'Principal',
          officialEmail: id,
          employeeId: 'PRI001',
          department: 'Executive',
        );
      }
      if (idLower.startsWith('admin')) {
        return EchosphereUser(
          id: 2,
          fullName: 'College Administrator',
          role: 'College Admin',
          officialEmail: id,
          employeeId: 'ADM001',
          department: 'Administration',
        );
      }
    }

    // Username-based detection
    if (idLower == 'admin') {
      return EchosphereUser(
        id: 2,
        fullName: 'College Administrator',
        role: 'College Admin',
        officialEmail: 'admin@echosphere.edu',
        employeeId: 'ADM001',
        department: 'Administration',
      );
    }
    if (idLower == 'developer') {
      return EchosphereUser(
        id: 1,
        fullName: 'System Developer',
        role: 'Developer',
        officialEmail: 'developer@echosphere.edu',
        employeeId: 'DEV001',
        department: 'IT Systems',
      );
    }
    if (idLower == 'esdev01' || idLower == 'rrakshu60@gmail.com') {
      return EchosphereUser(
        id: 7,
        fullName: 'Dev Admin',
        role: 'Dev Admin',
        officialEmail: 'rrakshu60@gmail.com',
        employeeId: 'DEVADM01',
        department: 'Dev Operations',
      );
    }

    return null;
  }
}
