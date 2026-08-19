# Task List - Finalizing Client Backend Integration

- [ ] **Service Layer**
    - [ ] Add `fetchOfferDetails(int projectId, int offerId)` to `OfferService`.
- [ ] **Controller Layer**
    - [ ] Update `OfferDetailsController` to fetch live data on initialization.
    - [ ] Update `SettingsController` to use `AuthService.logout()` for a complete session termination.
- [ ] **UI Layer**
    - [ ] Update `OfferDetailsScreen` to show a loading state while fetching data.
    - [ ] Ensure `SearchProvidersScreen` correctly displays backend `id` and `average_rating`.
- [ ] **Verification**
    - [ ] Run `flutter analyze`.
    - [ ] Verify Logout from both Drawer and Settings.
    - [ ] Verify live updates in Offer Details.
