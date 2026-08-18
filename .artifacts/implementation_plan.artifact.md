# Implementation Plan - Fixing Document Type SQL Error

The project submission is failing because the backend attempts to insert into the `documents` table without providing a required `document_type_id`. I will fix this in the backend controllers to ensure files are saved with the correct type reference.

## User Review Required

> [!IMPORTANT]
> - This fix involves modifying the **Backend (Laravel)** code located at `C:\Users\Yazan\Desktop\Darakom-backend`.
> - I will implement logic to automatically detect if a file is a PDF or an Image and assign the corresponding ID (1 for image, 2 for pdf) as defined in your database seeders.

## Proposed Changes

### Backend (Laravel)

#### [MODIFY] [ProjectController.php](file:///C:/Users/Yazan/Desktop/Darakom-backend/app/Http/Controllers/Project/ProjectController.php)
- Update the `documents` upload loop to determine and include `document_type_id`.

#### [MODIFY] [OfferController.php](file:///C:/Users/Yazan/Desktop/Darakom-backend/app/Http/Controllers/Project/OfferController.php)
- Update the `documents` upload loop to determine and include `document_type_id`.

## Verification Plan

### Manual Verification
1. Open the Flutter app and attempt to "Add Project" with an attachment.
2. Verify that the submission succeeds without the "document_type_id" SQL error.
3. Check the backend `documents` table to ensure `document_type_id` is correctly set (1 or 2).
