# Implementation Plan - Finalizing Client Backend Integration (Search, Favorites, and Logout)

This plan focuses on completing the backend synchronization for the remaining Client-side features: Provider Search, Favorites management, and the Logout process.

## User Review Required

> [!IMPORTANT]
> - **Logout**: This will now call `POST /api/logout` to revoke the token on the server and clear `SharedPreferences`.
> - **Search**: Since there is no general public search endpoint in the backend yet, I will utilize the `AuthService.fetchRoles()` and category-related routes to help the user find providers, or point to a placeholder if a specific search endpoint is needed.
> - **Favorites**: I will add `Obx` to the Favorites screen to ensure it updates instantly when a provider is removed.

## Proposed Changes

### 1. Service Layer

#### [MODIFY] [auth_service.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/services/auth_service.dart)
- Implement `logout()`: Sends a request to the server and clears local storage.

#### [MODIFY] [interaction_service.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/services/interaction_service.dart)
- Ensure `toggleFavorite` refreshes the local state or returns success properly.

### 2. Controller Layer

#### [MODIFY] [search_providers_controller.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/controllers/home/search_providers_controller.dart)
- Replace `allProviders` mock list with an empty list.
- Implement `fetchProviders()` or update `onSearch` to trigger an API call (e.g., fetching by roles/categories).

#### [MODIFY] [favorites_controller.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/controllers/home/favorites_controller.dart)
- Add a `removeFavorite(int providerId)` method that calls `InteractionService.toggleFavorite` and updates the list locally.

### 3. UI Layer

#### [MODIFY] [custom_drawer.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/views/home/custom_drawer.dart)
- Update the "Logout" item to call the `AuthController.logout()` method.

#### [MODIFY] [favorites_screen.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/views/home/favorites_screen.dart)
- Wrap the list with `Obx`.
- Add an "Unfavorite" icon/button to each provider card.

#### [MODIFY] [search_providers_screen.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/views/home/search_providers_screen.dart)
- Bind the search result list to live data.
- Add a loading indicator for searches.

## Verification Plan

### Manual Verification
1.  **Real Logout**: Log out and verify that the token is cleared and you cannot navigate back to the dashboard without logging in.
2.  **Favorites Sync**: Remove a provider from the favorites list and verify they disappear immediately.
3.  **Live Search**: Type a name in the search bar and verify that results (even if filtered from a role-based list) are reactive.
