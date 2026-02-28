import '../models/user_model.dart';
import '../core/constants/app_constants.dart';

class AuthService {
  static UserModel? _currentUser;

  static final _mockUsers = <String, Map<String, dynamic>>{
    AppConstants.demoAdminEmail: {
      'password': AppConstants.demoAdminPassword,
      'user': UserModel(
        id: 'admin-001',
        email: AppConstants.demoAdminEmail,
        phone: '9876543210',
        name: 'Arjun Kumar',
        role: UserRole.admin,
        status: UserStatus.active,
        region: 'South',
        languages: ['English', 'Kannada', 'Hindi'],
        specialization: 'Business Strategy',
        assignedClientIds: [],
        createdAt: DateTime(2023, 1, 1),
        activatedAt: DateTime(2023, 1, 2),
      ),
    },
    AppConstants.demoEmployeeEmail: {
      'password': AppConstants.demoEmployeePassword,
      'user': UserModel(
        id: 'emp-001',
        email: AppConstants.demoEmployeeEmail,
        phone: '9123456780',
        name: 'Priya Sharma',
        role: UserRole.employee,
        status: UserStatus.active,
        region: 'North',
        languages: ['English', 'Hindi'],
        specialization: 'Digital Marketing',
        assignedClientIds: ['client-001', 'client-002'],
        createdAt: DateTime(2023, 3, 10),
        activatedAt: DateTime(2023, 3, 11),
      ),
    },
  };

  Future<UserModel> signInWithEmail(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final record = _mockUsers[email.toLowerCase().trim()];
    if (record == null || record['password'] != password) {
      throw Exception('Invalid email or password');
    }
    _currentUser = record['user'] as UserModel;
    return _currentUser!;
  }

  Future<UserModel> signInWithPhone(String phone, String otp) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Mock: any 6-digit OTP works for demo phone 9876543210
    if (otp.length != 6) {
      throw Exception('Invalid OTP');
    }
    final adminUser = _mockUsers[AppConstants.demoAdminEmail]!['user'] as UserModel;
    _currentUser = adminUser;
    return _currentUser!;
  }

  Future<String> sendOtp(String phone) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return 'mock-verification-id-${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (_mockUsers.containsKey(email.toLowerCase())) {
      throw Exception('An account with this email already exists');
    }
    final newUser = UserModel(
      id: 'user-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      phone: phone,
      name: name,
      role: UserRole.employee,
      status: UserStatus.pending,
      createdAt: DateTime.now(),
    );
    _currentUser = newUser;
    return newUser;
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }

  UserModel? getCurrentUser() => _currentUser;

  bool get isLoggedIn => _currentUser != null;
}

final authService = AuthService();
