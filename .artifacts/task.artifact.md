# Task List - Fixing Ratings and Complaints Submission

- [x] **Data Model Updates**
    - [x] Update `ProjectModel` in `lib/models/project_model.dart` to include `performerUserId`.
- [x] **Service Layer Fixes**
    - [x] Update `InteractionService.submitComplaint` to include `type` and `against_user_id`.
    - [x] Refine `InteractionService.submitRating` to handle server error messages.
- [x] **Controller Logic Alignment**
    - [x] Update `MyProjectsController` to pass `performerUserId` when submitting complaints.
    - [x] Update `ProjectTrackingController` to pass `performerUserId` when submitting complaints.
- [ ] **Verification**
    - [ ] Run `flutter analyze`.
    - [ ] Verify successful submission in backend database.
