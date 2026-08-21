class OfferModel {
  final int id;
  final int projectId;
  final String status;
  final String? statusLabel;
  final double cost;
  final int duration;
  final String durationUnit;
  final String? projectName;
  final String? date;
  final String? amount;
  final String? providerName;
  final String? providerAvatar;
  final String? role;
  final double? rating;
  final int? reviewsCount;
  final String? badge;
  final String? specialty;
  final String? workSummary;
  final List<Map<String, dynamic>>? attachments;

  OfferModel({
    required this.id,
    required this.projectId,
    required this.status,
    this.statusLabel,
    required this.cost,
    required this.duration,
    required this.durationUnit,
    this.projectName,
    this.date,
    this.amount,
    this.providerName,
    this.providerAvatar,
    this.role,
    this.rating,
    this.reviewsCount,
    this.badge,
    this.specialty,
    this.workSummary,
    this.attachments,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    // 1. Extract Provider info
    final provider = json['provider'] as Map<String, dynamic>?;
    final providerUser = provider?['user'] as Map<String, dynamic>?;
    final providerRole = provider?['role'] as Map<String, dynamic>?;

    String? name = provider?['name'] ?? 
                  providerUser?['full_name'] ?? 
                  (providerUser != null ? "${providerUser['first_name']} ${providerUser['last_name']}" : null);
    
    String? avatar = provider?['avatar'] ?? providerUser?['avatar'];
    if (avatar != null && !avatar.startsWith('http')) {
       // Assuming it's a relative path from storage
       avatar = "http://127.0.0.1:8000/storage/$avatar";
    }

    String? roleName = provider?['role_name'] ?? providerRole?['name'] ?? "مزود خدمة";
    double avgRating = (provider?['average_rating'] ?? json['rating'] ?? 0.0).toDouble();

    // 2. Extract Project info
    final project = json['project'] as Map<String, dynamic>?;

    return OfferModel(
      id: json['id'] ?? 0,
      projectId: project?['id'] ?? json['project_id'] ?? 0,
      status: json['status'] ?? "pending",
      statusLabel: json['status_label'],
      cost: (json['cost'] ?? 0).toDouble(),
      duration: json['duration'] ?? 0,
      durationUnit: json['duration_unit'] ?? json['durationUnit'] ?? "يوم",
      
      projectName: project?['title'] ?? json['projectName'],
      date: json['created_at']?.split('T')[0] ?? json['date'],
      amount: json['cost'] != null ? "${json['cost']} ل.س" : json['amount'],
      
      providerName: name,
      providerAvatar: avatar,
      role: roleName,
      rating: avgRating,
      reviewsCount: provider?['reviews_count'] ?? json['reviewsCount'] ?? 0,
      
      badge: json['badge'],
      specialty: roleName,
      workSummary: json['provider_comment'] ?? json['details'] ?? json['workSummary'],
      attachments: json['documents'] != null 
          ? List<Map<String, dynamic>>.from(json['documents']) 
          : (json['attachments'] != null ? List<Map<String, dynamic>>.from(json['attachments']) : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'status': status,
      'cost': cost,
      'duration': duration,
      'durationUnit': durationUnit,
      'projectName': projectName,
      'date': date,
      'amount': amount,
      'providerName': providerName,
      'role': role,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'badge': badge,
      'specialty': specialty,
      'workSummary': workSummary,
      'attachments': attachments,
    };
  }
}
