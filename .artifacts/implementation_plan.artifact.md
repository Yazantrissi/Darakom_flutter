# Implementation Plan - Fixing Ratings and Complaints Submission

This plan addresses the "Submission Failed" error when a client tries to send a rating or a complaint by aligning the frontend request structure with the Laravel backend requirements.

## User Review Required

> [!IMPORTANT]
> - **Complaint Requirements**: The backend requires identifying *who* the complaint is against. I will update the project model to fetch the Provider's ID so the app can automatically route the complaint to the correct person.
> - **Rating Rules**: Ratings will only be successful for projects marked as "Finished" in the system. I will ensure the UI accurately reflects this state.

## Proposed Changes

### 1. Data Models

#### [MODIFY] [project_model.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/models/project_model.dart)
- Add `performerUserId` field.
- Update `fromJson` to extract this ID from the `performer` relation or `provider_profile` data.

### 2. Service Layer

#### [MODIFY] [interaction_service.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/services/interaction_service.dart)
- Update `submitComplaint(int projectId, String text, int againstUserId)`:
    - Include `type: 'against_provider'` and `against_user_id` in the payload.
- Update `submitRating(int projectId, Map<String, dynamic> data)`:
    - Ensure it uses the correct backend field names (`rate`, `comment`).

### 3. Controller Layer

#### [MODIFY] [my_projects_controller.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/controllers/home/my_projects_controller.dart)
- Update `showComplaintDialog` to pass the `project.performerUserId` to the service.

#### [MODIFY] [project_tracking_controller.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/controllers/tracking/project_tracking_controller.dart)
- Fetch and store the `performerUserId` when loading project details.
- Update `showComplaintDialog` accordingly.

## Verification Plan

### Manual Verification
1. **Submit Complaint**: Open a project with an assigned provider. Submit a complaint and verify it appears in the backend `complaints` table with the correct `against_user_id`.
2. **Submit Rating**: Complete a project (set to `finished`). Rate it and verify the stars and comment are saved in the `ratings` table.
3. **Error Handling**: Try rating a project twice or one that isn't finished; verify the app shows the specific error message from the server (e.g., "Already rated").
