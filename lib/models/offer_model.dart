class OfferModel {
  final int id;
  final int projectId;
  final String status;
  final double cost;
  final int duration;
  final String durationUnit;
  final String? projectName;
  final String? date;
  final String? amount;
  final String? providerName;
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
    required this.cost,
    required this.duration,
    required this.durationUnit,
    this.projectName,
    this.date,
    this.amount,
    this.providerName,
    this.role,
    this.rating,
    this.reviewsCount,
    this.badge,
    this.specialty,
    this.workSummary,
    this.attachments,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'] ?? 0,
      projectId: json['projectId'] ?? json['project_id'] ?? 0,
      status: json['status'] ?? "",
      cost: (json['cost'] ?? json['price'] ?? (json['amount'] != null ? double.tryParse(json['amount'].toString().replaceAll(RegExp(r'[^0-9.]'), '')) : 0) ?? 0).toDouble(),
      duration: json['duration'] is int ? json['duration'] : (int.tryParse(json['duration']?.toString().split(' ')[0] ?? '0') ?? 0),
      durationUnit: json['durationUnit'] ?? "يوم",
      projectName: json['projectName'],
      date: json['date'],
      amount: json['amount'] ?? json['totalPrice'],
      providerName: json['providerName'],
      role: json['role'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewsCount: json['reviewsCount'],
      badge: json['badge'],
      specialty: json['specialty'],
      workSummary: json['workSummary'],
      attachments: json['attachments'] != null ? List<Map<String, dynamic>>.from(json['attachments']) : null,
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
