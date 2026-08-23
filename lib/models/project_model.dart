class ProjectModel {
  final int id;
  final String title;
  final String description;
  final String status; // pending | in_progress | completed | cancelled (open treated as pending)
  final String executionStatus; // not_started, in_progress, finished
  final String? visibility; // public | private
  final int? provinceId;
  final int? offersCount;
  final String? startDate;
  final String? endDate;
  final double progressPercentage;
  final String? providerName;
  final int? performerUserId;
  final String? clientName;
  final int? clientId;
  final String? area;
  final String? governorate;
  final String? address;
  final String? type;
  final String? work_type;
  final String? building_no;
  final String? specialization;
  final String? publishDate;
  final int? duration;
  final String? budget;
  final String? currency;
  final String? tender_type;
  final int? invitationId;
  final int? invitedProviderId;
  final int? serviceCategoryId;
  final List<Map<String, dynamic>>? attachments;
  final String? timeLeft;
  final String? providerType;
  final String? offerAmount;
  final int? deliveryDays;

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.executionStatus = "not_started",
    this.visibility,
    this.provinceId,
    this.offersCount,
    this.startDate,
    this.endDate,
    this.progressPercentage = 0.0,
    this.providerName,
    this.performerUserId,
    this.clientName,
    this.clientId,
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
    this.currency,
    this.tender_type,
    this.invitationId,
    this.invitedProviderId,
    this.serviceCategoryId,
    this.attachments,
    this.timeLeft,
    this.providerType,
    this.offerAmount,
    this.deliveryDays,
  });

  String? get projectName => title;
  String? get location => address;
  String? get nextMilestone => "قيد التحديث";

  bool get isPendingLifecycle =>
      status == 'pending' || status == 'open' || executionStatus == 'not_started';

  bool get isInProgressLifecycle =>
      status == 'in_progress' || executionStatus == 'in_progress';

  bool get isCompletedLifecycle =>
      status == 'completed' ||
      status == 'finished' ||
      executionStatus == 'finished';

  bool get isPublicVisibility =>
      visibility == null ||
      visibility == 'public' ||
      (visibility == null && tender_type != 'private');

  bool get isPrivateVisibility =>
      visibility == 'private' || tender_type == 'private';

  static String _normalizeStatus(String status) {
    if (status == 'open' || status == 'new') return 'pending';
    return status;
  }

  static String _mapExecutionStatus(String status) {
    switch (status) {
      case 'open':
      case 'new':
      case 'pending':
        return 'not_started';
      case 'in_progress':
      case 'active':
        return 'in_progress';
      case 'completed':
      case 'finished':
        return 'finished';
      default:
        return status.isNotEmpty ? status : 'not_started';
    }
  }

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic val) {
      if (val is double) return val;
      if (val is int) return val.toDouble();
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    int? parseInt(dynamic val) {
      if (val == null) return null;
      if (val is int) return val;
      if (val is double) return val.round();
      return int.tryParse(val.toString());
    }

    final province = json['province'] as Map<String, dynamic>?;
    final projectType = json['project_type'] as Map<String, dynamic>?;
    final serviceCategory = json['service_category'] as Map<String, dynamic>?;
    final performer = json['performer'] as Map<String, dynamic>?;
    final performerUser = performer?['user'] as Map<String, dynamic>?;
    final provider = json['provider'] as Map<String, dynamic>?;
    final acceptedOffer = json['accepted_offer'] as Map<String, dynamic>?;
    final acceptedProvider = acceptedOffer?['provider'] as Map<String, dynamic>?;
    final client = json['client'] as Map<String, dynamic>?;
    final offers = json['offers'] as List?;
    final rawStatus = (json['status'] ?? '').toString();
    final status = _normalizeStatus(rawStatus);

    final visibility = json['visibility']?.toString() ??
        json['tender_type']?.toString();

    final executionFromApi = json['execution_status']?.toString();
    final executionStatus =
        (executionFromApi != null && executionFromApi.isNotEmpty)
            ? executionFromApi
            : _mapExecutionStatus(rawStatus.isNotEmpty ? rawStatus : status);

    final resolvedProviderName = provider?['name']?.toString() ??
        acceptedProvider?['name']?.toString() ??
        performerUser?['full_name']?.toString() ??
        performerUser?['name']?.toString() ??
        json['provider_name']?.toString() ??
        json['providerName']?.toString();

    final resolvedProviderType = provider?['provider_type']?.toString() ??
        acceptedProvider?['provider_type']?.toString() ??
        provider?['craftsman_subtype']?.toString() ??
        json['provider_type']?.toString() ??
        performer?['role']?['name']?.toString();

    return ProjectModel(
      id: parseInt(json['id']) ?? 0,
      title: json['title'] ?? json['projectName'] ?? "",
      description: json['description'] ?? "",
      status: status,
      executionStatus: executionStatus,
      visibility: visibility,
      provinceId: parseInt(json['province_id']) ?? parseInt(province?['id']),
      offersCount: parseInt(json['offers_count']) ?? offers?.length ?? 0,
      startDate: json['start_date'] ?? json['startDate'],
      endDate: json['deadline'] ?? json['end_date'] ?? json['endDate'],
      progressPercentage:
          parseDouble(json['progress_percentage'] ?? json['progress'] ?? 0.0),
      providerName: resolvedProviderName,
      performerUserId: parseInt(json['performer_user_id']) ??
          parseInt(json['provider_id']) ??
          parseInt(provider?['id']) ??
          parseInt(acceptedOffer?['provider_id']) ??
          parseInt(acceptedProvider?['id']) ??
          parseInt(performerUser?['id']) ??
          parseInt(json['performerUserId']),
      clientName: client?['name']?.toString() ??
          client?['full_name']?.toString() ??
          json['clientName']?.toString(),
      clientId: parseInt(json['client_id']) ??
          parseInt(client?['id']) ??
          parseInt(json['clientId']),
      area: json['area']?.toString(),
      governorate: province?['name'] ?? json['governorate'] ?? json['city'],
      address: json['location']?.toString() ??
          json['location_details']?.toString() ??
          json['address']?.toString(),
      type: serviceCategory?['name']?.toString() ??
          projectType?['name']?.toString() ??
          json['type']?.toString(),
      work_type: json['work_type'] ?? json['workType'],
      building_no: json['building_no']?.toString(),
      specialization: serviceCategory?['name']?.toString() ??
          projectType?['name']?.toString() ??
          json['specialization']?.toString(),
      publishDate:
          json['created_at']?.toString().split('T').first ?? json['publishDate'],
      duration: parseInt(json['delivery_days']) ??
          parseInt(acceptedOffer?['delivery_days']) ??
          parseInt(json['tender_duration']) ??
          parseInt(json['duration']),
      budget: (json['offer_amount'] ??
              json['offer_value'] ??
              acceptedOffer?['amount'] ??
              json['budget'])
          ?.toString(),
      currency: json['currency']?.toString() ?? 'SYP',
      tender_type: visibility ?? json['tender_type']?.toString(),
      invitationId:
          parseInt(json['invitation_id']) ?? parseInt(json['invitationId']),
      invitedProviderId: parseInt(json['invited_provider_id']) ??
          parseInt(json['invitedProviderId']),
      serviceCategoryId: parseInt(json['service_category_id']) ??
          parseInt(serviceCategory?['id']),
      attachments: json['attachments'] != null
          ? List<Map<String, dynamic>>.from(json['attachments'])
          : null,
      timeLeft: json['time_left']?.toString() ??
          (json['days_remaining'] != null
              ? '${json['days_remaining']} يوم'
              : null),
      providerType: resolvedProviderType,
      offerAmount: (json['offer_amount'] ??
              json['offer_value'] ??
              acceptedOffer?['amount'])
          ?.toString(),
      deliveryDays: parseInt(json['delivery_days']) ??
          parseInt(acceptedOffer?['delivery_days']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'execution_status': executionStatus,
      'visibility': visibility,
      'province_id': provinceId,
      'progress_percentage': progressPercentage,
      'work_type': work_type,
      'location': address,
      'budget': budget,
      'currency': currency,
      'tender_type': tender_type ?? visibility,
      'invitation_id': invitationId,
      'invited_provider_id': invitedProviderId,
      'service_category_id': serviceCategoryId,
    };
  }
}
