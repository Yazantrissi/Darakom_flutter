import 'package:flutter/material.dart';

class ProjectStageModel {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  void dispose() {
    nameController.dispose();
    durationController.dispose();
  }
}