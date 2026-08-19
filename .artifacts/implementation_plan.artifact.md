# Implementation Plan - Finalizing Client-Side Backend Integration

This plan focuses on ensuring that *every* client-side interface is fully synchronized with the backend, covering detail views, account management, and dynamic settings.

## User Review Required

> [!IMPORTANT]
> - **Logout Unification**: I will update the `SettingsScreen` logout logic to use the centralized `AuthService.logout()` method, ensuring the session is invalidated on both the client and server.
> - **Offer Accuracy**: The `OfferDetailsScreen` will now fetch live data from the server instead of relying solely on the data passed from the list, ensuring price and status are always up-to-date.

## Proposed Changes

### 1. Account & Settings

#### [MODIFY] [settings_controller.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/controllers/home/settings_controller.dart)
- Update `logout()` to call `AuthService.logout()` instead of manually clearing preferences. This ensures the token is revoked on the Laravel server.

### 2. Bidding & Offers

#### [MODIFY] [offer_details_controller.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/controllers/home/offer_details_controller.dart)
- Implement `refreshOfferDetails()`: Calls `GET /api/client/projects/{project}/offers/{offer}`.
- Trigger this refresh on `onInit` to ensure the user sees the absolute latest version of the offer.

### 3. Service Layer Refinement

#### [MODIFY] [offer_service.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/services/offer_service.dart)
- Add `fetchOfferDetails(int projectId, int offerId)` to support the updated details controller.

### 4. Search & UI Consistency

#### [MODIFY] [search_providers_screen.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/views/home/search_providers_screen.dart)
- Ensure the "ID" and "Rating" fields are correctly mapped from the `UserModel` returned by the backend.

## Verification Plan

### Manual Verification
1.  **Offer Details**: Open an offer, verify the loading spinner appears, and check that all details (price, duration, comments) are pulled live.
2.  **Settings Logout**: Log out from the Settings screen and verify that the backend session is destroyed.
3.  **Search Reliability**: Perform multiple searches for different provider types and verify data consistency.
4.  **Overall Check**: Navigate through all drawer items (Favorites, Ratings, Complaints) and verify live data in each.
