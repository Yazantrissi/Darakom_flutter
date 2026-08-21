class ProjectModel {
  final int id;
  final String title;
  final String description;
  final String status; // new, pending, active, completed
  final String executionStatus; // not_started, in_progress, finished
  final int? offersCount;
  final String? startDate;
  final String? endDate;
  final double progressPercentage;
  final String? providerName;
  final int? performerUserId; // Added to identify the contractor/engineer
  final String? clientName;
  final String? area;
  final String? governorate;
  final String? address;
  final String? type; // Project Type Name
  final String? work_type; // construction or finishing
  final String? building_no;
  final String? specialization;
  final String? publishDate;
  final int? duration;
  final String? budget;
  final String? tender_type;

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.executionStatus = "not_started",
    this.offersCount,
    this.startDate,
    this.endDate,
    this.progressPercentage = 0.0,
    this.providerName,
    this.performerUserId,
    this.clientName,
    this.area,
    this.governorate,
    this.address,
    this.type,
    this.work_type,
    this.building_no,
    this.specialization,
    this.publishDate,
    this.duration,
    this.budget,
    this.tender_type,
  });

  // Backward compatibility getters
  String? get projectName => title;
  String? get location => address;
  String? get nextMilestone => "قيد التحديث";

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic val) {
      if (val is double) return val;
      if (val is int) return val.toDouble();
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    final province = json['province'] as Map<String, dynamic>?;
    final projectType = json['project_type'] as Map<String, dynamic>?;
    final performer = json['performer'] as Map<String, dynamic>?;
    final performerUser = performer?['user'] as Map<String, dynamic>?;
    final offers = json['offers'] as List?;

    return ProjectModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? json['projectName'] ?? "",
      description: json['description'] ?? "",
      status: json['status'] ?? "",
      executionStatus: json['execution_status'] ?? "not_started",
      offersCount: json['offers_count'] ?? offers?.length ?? 0,
      startDate: json['start_date'] ?? json['startDate'],
      endDate: json['end_date'] ?? json['endDate'],
      progressPercentage: parseDouble(json['progress_percentage'] ?? json['progress'] ?? 0.0),
      providerName: performerUser?['full_name'] ?? json['providerName'],
      performerUserId: performerUser?['id'] ?? json['performerUserId'],
      clientName: json['client']?['full_name'] ?? json['clientName'],
      area: json['area']?.toString(),
      governorate: province?['name'] ?? json['governorate'],
      address: json['location_details'] ?? json['address'],
      type: projectType?['name'] ?? json['type'],
      work_type: json['work_type'] ?? json['workType'],
      building_no: json['building_no']?.toString(),
      specialization: projectType?['name'] ?? json['specialization'],
      publishDate: json['created_at']?.split('T')[0] ?? json['publishDate'],
      duration: json['tender_duration'] ?? json['duration'],
      budget: json['budget']?.toString(),
      tender_type: json['tender_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'execution_status': executionStatus,
      'progress_percentage': progressPercentage,
      'work_type': work_type,
    };
  }
}
