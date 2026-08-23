class OfferModel {
  final int id;
  final int projectId;
  final int? providerId;
  final String status;
  final String? statusLabel;
  final double cost;
  final int duration;
  final String durationUnit;
  final String? currency;
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
  final String? projectVisibility;
  final String? clientName;
  final List<Map<String, dynamic>>? attachments;
  final List<Map<String, dynamic>>? stages;

  OfferModel({
    required this.id,
    required this.projectId,
    this.providerId,
    required this.status,
    this.statusLabel,
    required this.cost,
    required this.duration,
    required this.durationUnit,
    this.currency,
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
    this.projectVisibility,
    this.clientName,
    this.attachments,
    this.stages,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    final provider = json['provider'] as Map<String, dynamic>?;
    final providerUser = provider?['user'] as Map<String, dynamic>?;
    final providerRole = provider?['role'] as Map<String, dynamic>?;
    final project = json['project'] as Map<String, dynamic>?;

    double parseDouble(dynamic val) {
      if (val is double) return val;
      if (val is int) return val.toDouble();
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    int parseInt(dynamic val) {
      if (val is int) return val;
      if (val is double) return val.round();
      return int.tryParse(val?.toString() ?? '') ?? 0;
    }

    final costValue = parseDouble(json['amount'] ?? json['price'] ?? json['cost'] ?? 0);
    final currency = json['currency']?.toString() ?? 'SYP';

    String? name = provider?['name']?.toString() ??
        providerUser?['full_name']?.toString() ??
        providerUser?['name']?.toString() ??
        (providerUser != null
            ? "${providerUser['first_name'] ?? ''} ${providerUser['last_name'] ?? ''}".trim()
            : null);

    String? avatar = provider?['avatar_url']?.toString() ??
        provider?['avatar']?.toString() ??
        providerUser?['avatar']?.toString();
    if (avatar != null && avatar.isNotEmpty && !avatar.startsWith('http')) {
      avatar = "http://127.0.0.1:8000/storage/$avatar";
    }

    String? roleName = provider?['role_name']?.toString() ??
        providerRole?['label']?.toString() ??
        providerRole?['name']?.toString() ??
        provider?['role']?.toString() ??
        "مزود خدمة";

    return OfferModel(
      id: parseInt(json['id']),
      projectId: parseInt(project?['id'] ?? json['project_id']),
      providerId: (json['provider_id'] != null || provider?['id'] != null)
          ? parseInt(json['provider_id'] ?? provider?['id'])
          : null,
      status: json['status']?.toString() ?? "pending",
      statusLabel: json['status_label']?.toString(),
      cost: costValue,
      duration: parseInt(json['delivery_days'] ?? json['duration']),
      durationUnit: json['duration_unit']?.toString() ?? json['durationUnit']?.toString() ?? "يوم",
      currency: currency,
      projectName: project?['title']?.toString() ?? json['projectName']?.toString(),
      date: json['created_at']?.toString().split('T').first ?? json['date']?.toString(),
      amount: "$costValue $currency",
      providerName: name,
      providerAvatar: avatar,
      role: roleName,
      rating: parseDouble(provider?['average_rating'] ?? json['rating'] ?? 0.0),
      reviewsCount: parseInt(provider?['reviews_count'] ?? json['reviewsCount'] ?? 0),
      badge: json['badge']?.toString(),
      specialty: roleName,
      workSummary: json['notes']?.toString() ??
          json['provider_comment']?.toString() ??
          json['details']?.toString() ??
          json['workSummary']?.toString(),
      projectVisibility: project?['visibility']?.toString() ??
          project?['tender_type']?.toString(),
      clientName: project?['client'] is Map
          ? (project!['client']['name']?.toString() ??
              "${project['client']['first_name'] ?? ''} ${project['client']['last_name'] ?? ''}".trim())
          : null,
      attachments: json['documents'] != null
          ? List<Map<String, dynamic>>.from(json['documents'])
          : (json['attachments'] != null
              ? List<Map<String, dynamic>>.from(json['attachments'])
              : null),
      stages: json['stages'] != null
          ? List<Map<String, dynamic>>.from(json['stages'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'providerId': providerId,
      'status': status,
      'cost': cost,
      'duration': duration,
      'durationUnit': durationUnit,
      'currency': currency,
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
      'stages': stages,
    };
  }
}
