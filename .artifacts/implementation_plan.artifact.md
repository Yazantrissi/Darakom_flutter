# Implementation Plan - Integrating Client Offers with Backend

This plan focuses on finalizing the integration of the Client's Offer views with the Laravel backend.

## User Review Required

> [!IMPORTANT]
> - I will update the `OfferModel` to handle the backend's nested `provider` and `project` data structures.
> - The app will now call specific endpoints for public and private offers: `/api/client/offers/public` and `/api/client/offers/private`.

## Proposed Changes

### 1. Data Models

#### [MODIFY] [offer_model.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/models/offer_model.dart)
- Update `fromJson` to correctly extract nested data from the backend response:
    - `providerName` from `provider.name`.
    - `specialty` from `provider.role_name`.
    - `rating` from `provider.average_rating`.
    - `projectName` from `project.title`.

### 2. Configuration & Services

#### [MODIFY] [api_constants.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/core/api_constants.dart)
- Add `publicOffers = "/client/offers/public"` and `privateOffers = "/client/offers/private"`.

#### [MODIFY] [offer_service.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/services/offer_service.dart)
- Refactor `fetchClientOffers` or add `fetchPublicOffers()` and `fetchPrivateOffers()` to use the specific endpoints.

### 3. Controllers Layer

#### [MODIFY] [client_offers_controller.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/controllers/home/client_offers_controller.dart)
- Update `fetchOffers()` to use the new service methods.
- Ensure state management correctly handles the split between public and private bidding.

### 4. UI Layer

#### [MODIFY] [client_offers_screen.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/views/home/client_offers_screen.dart)
- Ensure the offer cards display real data (e.g., actual provider names and ratings).

## Verification Plan

### Manual Verification
1.  **Public Offers**: Open the "Public Offers" tab; verify you see bids on projects you posted for everyone.
2.  **Private Offers**: Open the "Private Offers" tab; verify you see exclusive invitations.
3.  **Actions**: Accept a public offer; verify it becomes "Active" in the dashboard.
4.  **Consistency**: Verify that the price and duration shown in the list match what appears in the "Details" screen.
