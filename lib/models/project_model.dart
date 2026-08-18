class ProjectModel {
  final int id;
  final String title;
  final String description;
  final String status;
  final int? offersCount;
  final String? startDate;
  final String? endDate;
  final double progressPercentage;
  final String? providerName;
  final String? clientName;
  final String? area;
  final String? governorate;
  final String? address;
  final String? type; // General type
  final String? work_type; // construction or finishing
  final String? building_no;
  final String? specialization;
  final String? publishDate;
  final int? duration;
  final String? budget;
  final String? nextMilestone;
  final String? location;

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.offersCount,
    this.startDate,
    this.endDate,
    this.progressPercentage = 0.0,
    this.providerName,
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
    this.nextMilestone,
    this.location,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] ?? 0,
      title: json['projectName'] ?? json['title'] ?? "",
      description: json['description'] ?? "",
      status: json['status'] ?? "",
      offersCount: json['offersCount'],
      startDate: json['startDate'] ?? json['publishDate'],
      endDate: json['endDate'] ?? json['deliveryDate'] ?? json['completionDate'],
      progressPercentage: (json['progressPercentage'] ?? (json['progress'] != null ? (json['progress'] is double ? json['progress'] * 100 : json['progress']) : 0)).toDouble(),
      providerName: json['providerName'],
      clientName: json['clientName'],
      area: json['area']?.toString(),
      governorate: json['governorate'],
      address: json['address'],
      type: json['type'],
      work_type: json['work_type'] ?? json['workType'],
      building_no: json['building_no']?.toString() ?? json['buildingNo']?.toString(),
      specialization: json['specialization'],
      publishDate: json['publishDate'],
      duration: json['duration'],
      budget: json['budget'],
      nextMilestone: json['nextMilestone'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectName': title,
      'description': description,
      'status': status,
      'offersCount': offersCount,
      'startDate': startDate,
      'endDate': endDate,
      'progressPercentage': progressPercentage,
      'providerName': providerName,
      'clientName': clientName,
      'area': area,
      'governorate': governorate,
      'address': address,
      'type': type,
      'work_type': work_type,
      'building_no': building_no,
      'specialization': specialization,
      'publishDate': publishDate,
      'duration': duration,
      'budget': budget,
      'nextMilestone': nextMilestone,
      'location': location,
    };
  }
}
