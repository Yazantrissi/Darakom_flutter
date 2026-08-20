# Implementation Plan - Dynamic Roles and Provinces for Registration

This plan outlines the steps to replace hardcoded roles and provinces in the `RegisterScreen` with dynamic data fetched from the Laravel backend.

## Proposed Changes

### 1. Controller Layer

#### [MODIFY] [register_controller.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/controllers/auth/register_controller.dart)
- Update `_fetchInitialData()` to call:
    - `_authService.fetchProvinces()`
    - `_authService.fetchRoles()`
    - `_authService.fetchDocumentTypes()`
- Clear the hardcoded initial values for `provinces`, `roles`, and `documentTypes`.
- Update the `register()` method to use the selected `RoleModel` ID correctly.
- Update the document upload logic to use the first available `DocumentTypeModel` ID if no specific type is selected by the user.

### 2. View Layer

#### [MODIFY] [register_screen.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/views/auth/register_screen.dart)
- Ensure the `DropdownButtonFormField` for "Provinces" and "Roles" (Specialization) are correctly bound to the dynamic lists in the controller.
- Add a loading indicator for the initial data fetch if necessary, or rely on the reactive nature of the lists.

## Verification Plan

### Automated Tests
- Run `flutter analyze` to verify syntax and type safety.

### Manual Verification
1.  Open the Registration screen.
2.  Switch to the "Service Provider" (مزود خدمة) tab.
3.  Click the "Specialization" (التخصص) dropdown and verify that roles match the `roles` table in the backend database.
4.  Verify that the "Province" (المحافظة) dropdown displays the full list from the backend.
5.  Complete a registration and verify that the `role_id` and `province_id` are correctly sent to the server.
