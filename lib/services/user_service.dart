import '../models/user_model.dart';

class UserService {
  static final List<UserModel> _mockUsers = [
    UserModel(
      id: 'admin-001',
      email: 'admin@k2.com',
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
    UserModel(
      id: 'emp-001',
      email: 'emp@k2.com',
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
    UserModel(
      id: 'emp-002',
      email: 'ravi@k2.com',
      phone: '9988776655',
      name: 'Ravi Patel',
      role: UserRole.employee,
      status: UserStatus.active,
      region: 'West',
      languages: ['English', 'Gujarati', 'Hindi'],
      specialization: 'Client Relations',
      assignedClientIds: ['client-003'],
      createdAt: DateTime(2023, 4, 5),
      activatedAt: DateTime(2023, 4, 6),
    ),
    UserModel(
      id: 'emp-003',
      email: 'meena@k2.com',
      phone: '9765432100',
      name: 'Meena Iyer',
      role: UserRole.employee,
      status: UserStatus.active,
      region: 'South',
      languages: ['English', 'Tamil', 'Telugu'],
      specialization: 'Content Strategy',
      assignedClientIds: ['client-004', 'client-005'],
      createdAt: DateTime(2023, 5, 20),
      activatedAt: DateTime(2023, 5, 21),
    ),
    UserModel(
      id: 'emp-004',
      email: 'sanjay@k2.com',
      phone: '9654321098',
      name: 'Sanjay Mehta',
      role: UserRole.employee,
      status: UserStatus.active,
      region: 'East',
      languages: ['English', 'Bengali'],
      specialization: 'Market Research',
      assignedClientIds: [],
      createdAt: DateTime(2023, 6, 15),
      activatedAt: DateTime(2023, 6, 16),
    ),
    UserModel(
      id: 'pending-001',
      email: 'newuser@k2.com',
      phone: '9543210987',
      name: 'Ananya Singh',
      role: UserRole.employee,
      status: UserStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  Future<UserModel?> getUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _mockUsers.firstWhere((u) => u.id == userId);
    } catch (_) {
      return null;
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_mockUsers);
  }

  Future<List<UserModel>> getPendingUsers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockUsers.where((u) => u.status == UserStatus.pending).toList();
  }

  Future<UserModel> updateUser(UserModel user) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final idx = _mockUsers.indexWhere((u) => u.id == user.id);
    if (idx != -1) {
      _mockUsers[idx] = user;
    }
    return user;
  }

  Future<UserModel> activateUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final idx = _mockUsers.indexWhere((u) => u.id == userId);
    if (idx != -1) {
      _mockUsers[idx] = _mockUsers[idx].copyWith(
        status: UserStatus.active,
        activatedAt: DateTime.now(),
      );
      return _mockUsers[idx];
    }
    throw Exception('User not found');
  }

  Future<UserModel> deactivateUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final idx = _mockUsers.indexWhere((u) => u.id == userId);
    if (idx != -1) {
      _mockUsers[idx] = _mockUsers[idx].copyWith(status: UserStatus.suspended);
      return _mockUsers[idx];
    }
    throw Exception('User not found');
  }
}

final userService = UserService();
