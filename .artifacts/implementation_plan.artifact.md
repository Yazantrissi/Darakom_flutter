# Implementation Plan - Connecting Project Tracking to Backend

This plan outlines the integration of the Project Tracking screen with the Laravel backend for both Client and Provider views.

## User Review Required

> [!IMPORTANT]
> - I will replace the hardcoded `milestones` in `ProjectTrackingController` with real data fetched from the API.
> - I will create a `ProjectStepModel` to handle the data structure for project steps/milestones.
> - The UI will be updated to display the real progress percentage and step details (title, date, status).

## Proposed Changes

### 1. Data Models

#### [NEW] [project_step_model.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/models/project_step_model.dart)
- Define a model for project steps including fields: `id`, `title`, `description`, `date`, `progressPercent`, and `status`.

### 2. Service Layer

#### [MODIFY] [project_service.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/services/project_service.dart)
- Add `fetchProjectSteps(int projectId, {required bool isProvider})`:
    - If `isProvider`, call `GET /api/provider/projects/{project}/steps`.
    - If `!isProvider` (Client), call `GET /api/client/projects/{project}/steps`.

### 3. Controller Layer

#### [MODIFY] [project_tracking_controller.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/controllers/tracking/project_tracking_controller.dart)
- Remove hardcoded `milestones`.
- Add `RxList<ProjectStepModel> steps = <ProjectStepModel>[].obs`.
- Implement `loadTrackingData()` to fetch both project details (for progress and summary) and project steps.
- Update `onInit` to trigger data fetching.

### 4. UI Layer

#### [MODIFY] [project_tracking_screen.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/views/tracking/project_tracking_screen.dart)
- Bind the timeline list to `controller.steps`.
- Update the step card to use `ProjectStepModel` fields.
- Show a loading indicator during data retrieval.

## Verification Plan

### Manual Verification
1.  **Open Tracking**: Navigate to "Project Tracking" from an active project.
2.  **Verify Steps**: Ensure the steps shown match the milestones defined during the bid/offer process in the backend.
3.  **Status Check**: Verify that completed steps have a checkmark and green color, while pending ones are grey.
4.  **Progress Sync**: Confirm the top progress bar matches the project's overall progress percentage from the API.
