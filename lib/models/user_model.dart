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
  final int? roleId;
  final String? roleName;
  final String? syndicateNumber;
  final String? workArea;
  final int? experienceYears;
  final String? bio;
  final String? address;
  final String? profilePicture; // Used for avatar URL
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
    // Helper to safely parse int from dynamic if needed
    int parseId(dynamic val) {
      if (val is int) return val;
      if (val is String) return int.tryParse(val) ?? 0;
      return 0;
    }

    return UserModel(
      id: parseId(json['id']),
      name: json['name']?.toString() ?? "",
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      email: json['email']?.toString() ?? "",
      phone: json['phone']?.toString(),
      type: json['type']?.toString() ?? "",
      status: json['status']?.toString() ?? "",
      provinceId: json['province_id'] != null ? parseId(json['province_id']) : null,
      provinceName: json['province'] is Map 
          ? json['province']['name']?.toString() 
          : json['province']?.toString(), // Handle flat string or map
      roleId: json['role_id'] != null ? parseId(json['role_id']) : (json['profile']?['role_id'] != null ? parseId(json['profile']?['role_id']) : null),
      roleName: json['role'] is Map 
          ? json['role']['name']?.toString() 
          : (json['profile']?['role']?.toString() ?? json['role']?.toString()),
      syndicateNumber: json['syndicate_number']?.toString() ?? json['profile']?['syndicate_number']?.toString(),
      workArea: json['work_area']?.toString() ?? json['profile']?['work_area']?.toString(),
      experienceYears: json['experience_years'] != null 
          ? parseId(json['experience_years']) 
          : (json['profile']?['experience'] != null ? parseId(json['profile']?['experience']) : null),
      bio: json['bio']?.toString() ?? json['profile']?['bio']?.toString(),
      address: json['address']?.toString(),
      profilePicture: json['avatar']?.toString() ?? json['profile_picture']?.toString(), // Map avatar to profilePicture
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
      'status': status,
      'province_id': provinceId,
      'role_id': roleId,
      'syndicate_number': syndicateNumber,
      'work_area': workArea,
      'experience_years': experienceYears,
      'bio': bio,
      'address': address,
      'profile_picture': profilePicture,
      'token': token,
    };
  }
}
