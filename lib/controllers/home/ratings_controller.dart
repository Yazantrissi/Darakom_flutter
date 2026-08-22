import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/rating_model.dart';
import '../../services/interaction_service.dart';

class RatingsController extends GetxController {
  final InteractionService _interactionService = Get.find<InteractionService>();

  var isLoading = false.obs;

  // 1. تقييمات قدمتها (العميل يقيم مزود الخدمة)
  var givenRatings = <RatingModel>[].obs;

  // 2. تقييمات حصلت عليها (مزود الخدمة يقيم العميل)
  var receivedRatings = <RatingModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRatings();
  }

  Future<void> fetchRatings() async {
    try {
      isLoading.value = true;
      final ratings = await _interactionService.fetchClientRatings();
      // Client endpoint returns ratings given by the logged-in client
      givenRatings.value = ratings;
      receivedRatings.value = [];
    } catch (e) {
      print("Error in fetchRatings: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitRating(int projectId, double rating, String comment) async {
    isLoading.value = true;
    final result = await _interactionService.submitRating(projectId, {
      'rating': rating,
      'comment': comment,
    });
    isLoading.value = false;

    if (result['success'] == true) {
      Get.snackbar('تم بنجاح', 'شكراً لك على تقييمك!', backgroundColor: Colors.green, colorText: Colors.white);
      fetchRatings();
    } else {
      Get.snackbar('خطأ', result['message'] ?? 'فشل إرسال التقييم، حاول مرة أخرى', backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }
}
