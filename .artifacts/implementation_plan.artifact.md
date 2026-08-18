# Implementation Plan - Backend File Upload Integration

This plan details the steps to enable multipart file uploading across all relevant modules (Registration, Projects, Offers, and Stage Updates) using the Dio package.

## User Review Required

> [!IMPORTANT]
> - All file-related requests will be switched from JSON to `FormData`.
> - The backend must be ready to handle `multipart/form-data` on the specified endpoints.
> - We will use the `MultipartFile.fromFile` method to attach files to the requests.

## Proposed Changes

### 1. Infrastructure Layer

#### [MODIFY] [api_service.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/services/api_service.dart)
- Update `post`, `put`, and `patch` to handle `dynamic data` (which can be either a Map or `FormData`).
- Ensure headers are dynamically adjusted by Dio when `FormData` is passed.

### 2. Service Layer

#### [MODIFY] [project_service.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/services/project_service.dart)
- Refactor `createProject` to convert the data Map and attachments to `FormData`.
- Refactor `completeProjectStage` to support comments and file attachments via `FormData`.

#### [MODIFY] [offer_service.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/services/offer_service.dart)
- Refactor `submitOffer` to support multipart data for project stages and attachments.

### 3. Controller Layer

#### [MODIFY] [add_project_controller.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/controllers/home/add_project_controller.dart)
- Logic to collect `projectAttachments` and pass them to `ProjectService.createProject`.

#### [MODIFY] [submit_offer_controller.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/controllers/provider/submit_offer_controller.dart)
- Logic to collect `offerAttachments` and pass them to `OfferService.submitOffer`.

#### [MODIFY] [add_completed_stage_controller.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/controllers/provider/add_completed_stage_controller.dart)
- Logic to collect `attachments` and pass them to `ProjectService.completeProjectStage`.

## Verification Plan

### Manual Verification
1.  **Project Creation**: Add a project with a PDF and an image; verify success.
2.  **Offer Submission**: Submit an offer with attachments; verify success.
3.  **Stage Completion**: Mark a stage as done with a photo; verify success.
4.  **Registration**: Register as a provider with documentation; verify success.

### Automated Tests
- Run `flutter analyze` to ensure all `MultipartFile` and `FormData` references are correct.
