class UserModel {
  final int id;
  final String name;
  final String? firstName;
  final String? lastName;
  final String email;
  final String? phone;
  final String type;
  final String status;
  final int? provinceId;
  final String? provinceName;
  final String? city;
  final String? specialty;
  final String? providerType;
  final String? craftsmanSubtype;
  final bool isVerified;
  final int? roleId;
  final String? roleName;
  final String? syndicateNumber;
  final String? workArea;
  final int? experienceYears;
  final String? bio;
  final String? address;
  final String? profilePicture;
  final String? token;

  UserModel({
    required this.id,
    required this.name,
    this.firstName,
    this.lastName,
    required this.email,
    this.phone,
    required this.type,
    required this.status,
    this.provinceId,
    this.provinceName,
    this.city,
    this.specialty,
    this.providerType,
    this.craftsmanSubtype,
    this.isVerified = false,
    this.roleId,
    this.roleName,
    this.syndicateNumber,
    this.workArea,
    this.experienceYears,
    this.bio,
    this.address,
    this.profilePicture,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    int parseId(dynamic val) {
      if (val is int) return val;
      if (val is String) return int.tryParse(val) ?? 0;
      return 0;
    }

    bool parseBool(dynamic val) {
      if (val is bool) return val;
      if (val is num) return val != 0;
      if (val is String) {
        final lower = val.toLowerCase();
        return lower == 'true' || lower == '1' || lower == 'yes';
      }
      return false;
    }

    final type = (json['type'] ?? json['role'] ?? '').toString();
    final profile = json['profile'] is Map
        ? Map<String, dynamic>.from(json['profile'] as Map)
        : null;

    return UserModel(
      id: parseId(json['id']),
      name: json['name']?.toString() ?? "",
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      email: json['email']?.toString() ?? "",
      phone: json['phone']?.toString(),
      type: type,
      status: json['status']?.toString() ?? "",
      provinceId: json['province_id'] != null
          ? parseId(json['province_id'])
          : (profile?['province_id'] != null
              ? parseId(profile?['province_id'])
              : null),
      provinceName: json['province'] is Map
          ? json['province']['name']?.toString()
          : json['province']?.toString(),
      city: json['city']?.toString(),
      specialty: json['specialty']?.toString() ??
          profile?['specialty']?.toString() ??
          json['provider_type']?.toString(),
      providerType: json['provider_type']?.toString() ??
          profile?['provider_type']?.toString(),
      craftsmanSubtype: json['craftsman_subtype']?.toString() ??
          profile?['craftsman_subtype']?.toString(),
      isVerified: parseBool(
          json['is_verified'] ?? profile?['is_verified'] ?? false),
      roleId: json['role_id'] != null
          ? parseId(json['role_id'])
          : (profile?['role_id'] != null
              ? parseId(profile?['role_id'])
              : null),
      roleName: json['role'] is Map
          ? (json['role']['label'] ?? json['role']['name'])?.toString()
          : (json['role'] is String
              ? json['role'].toString()
              : profile?['role']?.toString()),
      syndicateNumber: json['syndicate_number']?.toString() ??
          profile?['syndicate_number']?.toString(),
      workArea:
          json['work_area']?.toString() ?? profile?['work_area']?.toString(),
      experienceYears: json['experience_years'] != null
          ? parseId(json['experience_years'])
          : (profile?['experience'] != null
              ? parseId(profile?['experience'])
              : null),
      bio: json['bio']?.toString() ?? profile?['bio']?.toString(),
      address: json['address']?.toString(),
      profilePicture: json['avatar_url']?.toString() ??
          json['avatar']?.toString() ??
          json['profile_picture']?.toString(),
      token: json['token']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'type': type,
      'role': type,
      'status': status,
      'province_id': provinceId,
      'city': city,
      'specialty': specialty,
      'provider_type': providerType,
      'craftsman_subtype': craftsmanSubtype,
      'is_verified': isVerified,
      'role_id': roleId,
      'syndicate_number': syndicateNumber,
      'work_area': workArea,
      'experience_years': experienceYears,
      'bio': bio,
      'address': address,
      'avatar_url': profilePicture,
      'profile_picture': profilePicture,
      'token': token,
    };
  }
}
