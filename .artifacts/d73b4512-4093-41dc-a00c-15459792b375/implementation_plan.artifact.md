# تنفيذ ميزة تعديل المشروع للعميل

سيتم تفعيل زر "تعديل" في صفحة تفاصيل المشروع بحيث يتم نقل العميل إلى واجهة الإضافة مع تعبئة كافة الحقول ببيانات المشروع الحالية، والسماح له بحفظ التعديلات.

## التغييرات المقترحة

### المتحكمات (Controllers)

#### [MODIFY] [my_projects_controller.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/controllers/home/my_projects_controller.dart)
إضافة دالة `updatePendingProject(Map<String, dynamic> updatedProject)` لتحديث بيانات المشروع في القائمة.

#### [MODIFY] [add_project_controller.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/controllers/home/add_project_controller.dart)
- إضافة متغير `isEditMode` و `projectId`.
- إضافة دالة `initializeForEdit(Map<String, dynamic> project)` لتعبئة الحقول.
- تعديل `submitProject` لدعم التحديث بدلاً من الإضافة الجديدة عند وجود `isEditMode`.

#### [MODIFY] [client_project_details_controller.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/controllers/home/client_project_details_controller.dart)
تحديث دالة `editProject` للانتقال إلى `AddProjectScreen` مع تمرير بيانات المشروع كـ `arguments`.

### الواجهات (Views)

#### [MODIFY] [add_project_screen.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/views/home/add_project_screen.dart)
تحديث العنوان وزر الإرسال ليتناسب مع وضع التعديل (مثلاً: "تعديل المشروع" بدلاً من "إضافة مشروع جديد").

## خطة التحقق

### التحقق اليدوي
1. الانتقال إلى تفاصيل مشروع في قائمة "قيد الانتظار".
2. الضغط على زر "تعديل".
3. التأكد من أن واجهة التعديل تظهر وبها كافة البيانات السابقة (الاسم، الوصف، المساحة، إلخ).
4. تغيير أحد الحقول (مثلاً اسم المشروع) والضغط على "تعديل المشروع".
5. التأكد من العودة لصفحة التفاصيل (أو القائمة) وظهور البيانات الجديدة.
