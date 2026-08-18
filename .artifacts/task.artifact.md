# Task List - Connecting Client's Main Interface to Backend

- [ ] **Configuration & Service Layer**
    - [ ] Add `clientDashboard` endpoint to `ApiConstants`.
    - [ ] Add `fetchClientDashboard()` and `fetchClientProjects()` to `ProjectService`.
- [ ] **Controller Layer**
    - [ ] Update `ClientDashboardController` with live data fetching.
    - [ ] Update `MyProjectsController` to remove mock data and fetch from API.
- [ ] **UI Layer**
    - [ ] Update `ClientDashboardScreen` to display real stats and project lists.
    - [ ] Update `MyProjectsScreen` to handle loading states and display live projects.
- [ ] **Verification**
    - [ ] Run `flutter analyze`.
    - [ ] Manually verify data synchronization.
