# Task List - Connecting Ratings and Complaints to Backend

- [ ] **Data Models**
    - [ ] Update `RatingModel` to handle nested provider and project data.
    - [ ] Update `ComplaintModel` to include defendant and resolution details.
- [ ] **Service Layer**
    - [ ] Refine `InteractionService` to call `/client/my-ratings` and `/client/complaints`.
    - [ ] Add `submitRating` and `submitComplaint` methods.
- [ ] **Controller Layer**
    - [ ] Update `RatingsController` with live data fetching and categorization.
    - [ ] Update `ComplaintsController` with live data fetching and categorization.
- [ ] **UI Layer**
    - [ ] Update `RatingsScreen` with `Obx` and loading states.
    - [ ] Update `ComplaintsScreen` with `Obx` and real submission logic.
- [ ] **Verification**
    - [ ] Run `flutter analyze`.
    - [ ] Verify live data display and submission.
