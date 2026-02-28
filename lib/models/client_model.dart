enum ClientStatus { active, inactive, prospect }

class ClientModel {
  final String id;
  final String name;
  final String industry;
  final String contactName;
  final String contactEmail;
  final String contactPhone;
  final String region;
  final List<String> assignedEmployeeIds;
  final ClientStatus status;
  final DateTime createdAt;
  final String? notes;
  final String? logoUrl;

  const ClientModel({
    required this.id,
    required this.name,
    required this.industry,
    required this.contactName,
    required this.contactEmail,
    required this.contactPhone,
    required this.region,
    this.assignedEmployeeIds = const [],
    required this.status,
    required this.createdAt,
    this.notes,
    this.logoUrl,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'] as String,
      name: json['name'] as String,
      industry: json['industry'] as String,
      contactName: json['contactName'] as String,
      contactEmail: json['contactEmail'] as String,
      contactPhone: json['contactPhone'] as String,
      region: json['region'] as String,
      assignedEmployeeIds: List<String>.from(json['assignedEmployeeIds'] ?? []),
      status: ClientStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ClientStatus.active,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      notes: json['notes'] as String?,
      logoUrl: json['logoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'industry': industry,
      'contactName': contactName,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'region': region,
      'assignedEmployeeIds': assignedEmployeeIds,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'notes': notes,
      'logoUrl': logoUrl,
    };
  }

  ClientModel copyWith({
    String? id,
    String? name,
    String? industry,
    String? contactName,
    String? contactEmail,
    String? contactPhone,
    String? region,
    List<String>? assignedEmployeeIds,
    ClientStatus? status,
    DateTime? createdAt,
    String? notes,
    String? logoUrl,
  }) {
    return ClientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      industry: industry ?? this.industry,
      contactName: contactName ?? this.contactName,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      region: region ?? this.region,
      assignedEmployeeIds: assignedEmployeeIds ?? this.assignedEmployeeIds,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
      logoUrl: logoUrl ?? this.logoUrl,
    );
  }
}
