import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/supervisor_model.dart';

class AuthLocalDataSource {
  final Box<SupervisorModel> supervisorBox;
  final Box settingsBox;
  final Uuid uuid;

  AuthLocalDataSource({
    required this.supervisorBox,
    required this.settingsBox,
    required this.uuid,
  });

  Future<SupervisorModel?> login(String email, String password) async {
    print('🔐 Attempting login for: $email');
    print('📦 Supervisor box keys: ${supervisorBox.keys.toList()}');
    print('📦 Supervisor box length: ${supervisorBox.length}');

    final supervisor = supervisorBox.get(email);

    if (supervisor == null) {
      print('❌ User not found in database');
      throw Exception('User not found');
    }

    print('✅ User found: ${supervisor.name}');

    if (supervisor.password != password) {
      print('❌ Invalid password');
      throw Exception('Invalid password');
    }

    print('✅ Password verified');

    // Save current user
    await settingsBox.put(AppConstants.currentUserIdKey, supervisor.id);

    return supervisor;
  }

  Future<SupervisorModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // Check if user already exists
    if (supervisorBox.containsKey(email)) {
      throw Exception('User already exists');
    }

    final supervisor = SupervisorModel(
      id: 'SUP-${uuid.v4().substring(0, 8).toUpperCase()}',
      name: name,
      email: email,
      password: password,
    );

    await supervisorBox.put(email, supervisor);
    await settingsBox.put(AppConstants.currentUserIdKey, supervisor.id);

    return supervisor;
  }

  Future<SupervisorModel?> getCurrentUser() async {
    final userId = settingsBox.get(AppConstants.currentUserIdKey);

    if (userId == null) return null;

    // Find supervisor by ID
    for (var supervisor in supervisorBox.values) {
      if (supervisor.id == userId) {
        return supervisor;
      }
    }

    return null;
  }

  Future<void> logout() async {
    await settingsBox.delete(AppConstants.currentUserIdKey);
  }
}

