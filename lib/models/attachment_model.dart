import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttachmentModel {
  // نوع الملف (صور، ملفات)
  Rx<String?> type = Rx<String?>(null);

  // عنوان الملف
  TextEditingController titleController = TextEditingController();

  // اسم الملف (للعرض في الواجهة)
  Rx<String?> fileName = Rx<String?>(null);

  // مسار الملف الحقيقي (لإرساله إلى API لاحقاً على الأجهزة المحمولة)
  Rx<String?> filePath = Rx<String?>(null);

  // محتوى الملف كبايتات (لإرساله إلى API على الويب)
  Rx<Uint8List?> fileBytes = Rx<Uint8List?>(null);

  // تنظيف الذاكرة عند الحذف
  void dispose() {
    titleController.dispose();
  }
}
