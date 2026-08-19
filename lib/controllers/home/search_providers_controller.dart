import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/interaction_service.dart';
import '../../models/user_model.dart';
import 'dart:async';

class SearchProvidersController extends GetxController {
  final InteractionService _interactionService = Get.find<InteractionService>();
  final TextEditingController searchController = TextEditingController();

  var searchResults = <UserModel>[].obs;
  var isLoading = false.obs;
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    // Initial fetch (empty search)
    onSearch("");
  }

  void onSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      isLoading.value = true;
      try {
        final results = await _interactionService.searchProviders(query);
        searchResults.assignAll(results);
      } catch (e) {
        print("Search error: $e");
      } finally {
        isLoading.value = false;
      }
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    _debounce?.cancel();
    super.onClose();
  }
}
