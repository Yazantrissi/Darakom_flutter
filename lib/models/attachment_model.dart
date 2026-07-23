import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttachmentModel {
  // نوع الملف (صور، ملفات)
  Rx<String?> type = Rx<String?>(null);

  // عنوان الملف
  TextEditingController titleController = TextEditingController();

  // اسم الملف (للعرض في الواجهة)
  Rx<String?> fileName = Rx<String?>(null);

  // مسار الملف الحقيقي (لإرساله إلى API لاحقاً)
  Rx<String?> filePath = Rx<String?>(null);

  // تنظيف الذاكرة عند الحذف
  void dispose() {
    titleController.dispose();
  }
}