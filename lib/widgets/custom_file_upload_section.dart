import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/attachment_model.dart';

class CustomFileUploadSection extends StatelessWidget {
  final RxList<AttachmentModel> attachments;
  final VoidCallback onAdd;
  final Function(int) onRemove;
  final Function(int) onPick;

  const CustomFileUploadSection({
    super.key,
    required this.attachments,
    required this.onAdd,
    required this.onRemove,
    required this.onPick,
  });

  final Color navyColor = const Color(0xFF1A2A44);
  final Color orangeColor = const Color(0xFFF58A1E);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. الهيدر العلوي (زر الإضافة والعنوان)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add, size: 18, color: Colors.white),
                label: const Text('إضافة ملف', style: TextStyle(fontFamily: 'Tajawal', color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: orangeColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
              Text('رفع الوثائق والمرفقات', style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, fontSize: 16, color: navyColor)),
            ],
          ),
        ),

        // 2. قائمة الملفات الديناميكية
        Obx(() => Column(
          children: attachments.asMap().entries.map((entry) {
            int index = entry.key;
            AttachmentModel item = entry.value;

            return Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                // تمثيل الإطار المتقطع بحدود رمادية ناعمة (يمكن استخدام حزمة dotted_border لاحقاً إذا رغبت)
                border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // لتجنب زحام العناصر على الشاشات الصغيرة
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // حقل نوع الملف
                    _buildColumnWrap('نوع الملف', _buildDropdown(item)),
                    const SizedBox(width: 16),

                    // حقل عنوان الملف
                    _buildColumnWrap('عنوان الملف', _buildTextField(item)),
                    const SizedBox(width: 16),

                    // حقل اختيار الملف المخصص
                    _buildColumnWrap('اختر الملف', _buildFilePicker(item, index)),
                    const SizedBox(width: 16),

                    // زر الحذف
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
                        onPressed: () => onRemove(index),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        )),
      ],
    );
  }

  // --- دوال مساعدة لبناء العناصر الداخلية ---

  Widget _buildColumnWrap(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontFamily: 'Tajawal', fontSize: 13, fontWeight: FontWeight.bold, color: navyColor)),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildDropdown(AttachmentModel item) {
    return SizedBox(
      width: 130,
      height: 48,
      child: Obx(() => DropdownButtonFormField<String>(
        value: item.type.value,
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        style: TextStyle(fontFamily: 'Tajawal', color: navyColor, fontSize: 13),
        decoration: _inputDecoration('اختر...'),
        items: ['صور', 'ملفات'].map((String val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
        onChanged: (val) => item.type.value = val,
      )),
    );
  }

  Widget _buildTextField(AttachmentModel item) {
    return SizedBox(
      width: 180,
      height: 48,
      child: TextFormField(
        controller: item.titleController,
        style: TextStyle(fontFamily: 'Tajawal', color: navyColor, fontSize: 13),
        decoration: _inputDecoration('مثال: صورة الهوية'),
      ),
    );
  }

  Widget _buildFilePicker(AttachmentModel item, int index) {
    return Container(
      width: 220,
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFF9FAFC),
      ),
      child: Row(
        children: [
          // النص التعريفي باسم الملف
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Obx(() => Text(
                item.fileName.value ?? 'لم يتم اختيار أي ملف',
                style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey.shade600, fontSize: 12),
                overflow: TextOverflow.ellipsis,
              )),
            ),
          ),
          // زر "اختيار ملف"
          GestureDetector(
            onTap: () => onPick(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: const Border(right: BorderSide(color: Color(0xFFE0E0E0))), // خط فاصل
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
              ),
              child: Text('اختيار ملف', style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey.shade800, fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontFamily: 'Tajawal', color: Colors.grey, fontSize: 12),
      filled: true,
      fillColor: const Color(0xFFF9FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: navyColor, width: 1.2)),
    );
  }
}