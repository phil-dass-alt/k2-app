enum UserRole { admin, employee }
enum UserStatus { pending, active, suspended }

class UserModel {
  final String id;
  final String email;
  final String? phone;
  final String name;
  final UserRole role;
  final UserStatus status;
  final String? region;
  final List<String> languages;
  final String? specialization;
  final List<String> assignedClientIds;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime? activatedAt;

  const UserModel({
    required this.id,
    required this.email,
    this.phone,
    required this.name,
    required this.role,
    required this.status,
    this.region,
    this.languages = const [],
    this.specialization,
    this.assignedClientIds = const [],
    this.profileImageUrl,
    required this.createdAt,
    this.activatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      name: json['name'] as String,
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.employee,
      ),
      status: UserStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => UserStatus.pending,
      ),
      region: json['region'] as String?,
      languages: List<String>.from(json['languages'] ?? []),
      specialization: json['specialization'] as String?,
      assignedClientIds: List<String>.from(json['assignedClientIds'] ?? []),
      profileImageUrl: json['profileImageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      activatedAt: json['activatedAt'] != null
          ? DateTime.parse(json['activatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'name': name,
      'role': role.name,
      'status': status.name,
      'region': region,
      'languages': languages,
      'specialization': specialization,
      'assignedClientIds': assignedClientIds,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'activatedAt': activatedAt?.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? phone,
    String? name,
    UserRole? role,
    UserStatus? status,
    String? region,
    List<String>? languages,
    String? specialization,
    List<String>? assignedClientIds,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? activatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      role: role ?? this.role,
      status: status ?? this.status,
      region: region ?? this.region,
      languages: languages ?? this.languages,
      specialization: specialization ?? this.specialization,
      assignedClientIds: assignedClientIds ?? this.assignedClientIds,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      activatedAt: activatedAt ?? this.activatedAt,
    );
  }
}
