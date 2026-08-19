# Implementation Plan - Connecting Ratings and Complaints to Backend

This plan outlines the integration of the "Ratings" and "Complaints" features with the Laravel backend for the Client side.

## User Review Required

> [!IMPORTANT]
> - I will replace all mock data in `RatingsController` and `ComplaintsController` with live data from the API.
> - The UI will be updated to handle loading states and display the correct status labels (e.g., "قيد المراجعة", "تم الحل").

## Proposed Changes

### 1. Data Models

#### [MODIFY] [rating_model.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/models/rating_model.dart)
- Enhance the model to handle both "Given" and "Received" ratings.
- Map fields like `rating`, `comment`, `reviewer_name`, `provider_name`, and `project_title`.

#### [MODIFY] [complaint_model.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/models/complaint_model.dart)
- Update to include `defendant_name`, `project_name`, and `resolution_details`.
- Align fields with the backend `Complaint` model.

### 2. Service Layer

#### [MODIFY] [interaction_service.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/services/interaction_service.dart)
- Ensure `fetchClientRatings()` and `fetchClientComplaints()` are properly calling the `/api/client/my-ratings` and `/api/client/complaints` endpoints.
- Add `submitRating(int projectId, Map<String, dynamic> data)` to allow clients to rate completed projects.

### 3. Controller Layer

#### [MODIFY] [ratings_controller.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/controllers/home/ratings_controller.dart)
- Implement `fetchRatings()` to populate `givenRatings` and `receivedRatings` lists.
- Add `isLoading` state.

#### [MODIFY] [complaints_controller.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/controllers/home/complaints_controller.dart)
- Implement `fetchComplaints()` and categorize them into `pending`, `resolved`, and `rejected`.
- Add `submitNewComplaint(int projectId, String description)` logic.

### 4. UI Layer

#### [MODIFY] [ratings_screen.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/views/home/ratings_screen.dart)
- Wrap lists with `Obx` to show live data and loading spinners.

#### [MODIFY] [complaints_screen.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/views/home/complaints_screen.dart)
- Wrap lists with `Obx`.
- Update the "Submit Complaint" dialog to actually send data to the server.

## Verification Plan

### Manual Verification
1.  **Ratings**: Open "Ratings" and verify that you see real feedback from your projects.
2.  **Complaints List**: Open "Complaints" and verify your filed complaints are listed with their current status.
3.  **Submit Complaint**: Submit a new complaint from a project tracking screen; verify it appears in the "Pending" list.
4.  **Submit Rating**: Rate a finished project; verify the success message and check the backend database.
