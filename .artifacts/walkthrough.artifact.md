# Walkthrough - Backend Integration & Bug Fixes

I have resolved the project submission failure and fully aligned the frontend with the Laravel backend logic, including enhanced file upload support.

## Key Fixes & Improvements

### 1. Project Submission Alignment
- **Issue**: Submission was failing because the backend requires specific IDs (`project_type_id`, `province_id`) and fields like `work_type` and `tender_duration_unit`.
- **Solution**:
    - Updated `AddProjectController` to fetch real **Provinces** and **Roles** from the backend upon initialization.
    - Mapped the UI selections to their respective database IDs before sending.
    - Added the missing **Building Number** field to the form.
    - Integrated detailed error reporting; if the server rejects the request (e.g., validation error), the app now shows the exact reason in the snackbar.

### 2. Robust File Uploads
- **Universal Support**: Refactored `ProjectService` and `OfferService` to support both Mobile (file paths) and Web (file bytes) uploads using `FormData`.
- **Key Unification**: Unified the file keys to `documents[]` to match the backend `OfferController` and `ProjectController` logic.

### 3. Profile Enhancements
- **Client Profile**: Added the **Province** dropdown and linked it to the backend for both reading and updating.
- **Provider Profile**: Replaced "Work Area" with **Experience Years** as requested, ensuring it's numeric and persisted to the server.
- **Sidebar Sync**: Names and emails in the sidebar now refresh instantly when the profile is updated.

## Technical Details

| Component | Logic Update |
| :--- | :--- |
| **ApiService** | Removed static JSON content-type to allow Dio to manage multipart boundaries. |
| **ProjectService** | Added `createProjectDetailed` for granular error handling. |
| **RegisterController** | Refined the registration flow to ensure all mandatory backend fields are present. |

## Verification Summary
- **Analysis**: Ran `flutter analyze` and verified 0 critical errors.
- **Flow**: Confirmed that data-dependent dropdowns (Provinces/Roles) load before allowing submission.

> [!TIP]
> Make sure your Laravel server is running and the database has at least one province and one role for the dropdowns to populate correctly.
