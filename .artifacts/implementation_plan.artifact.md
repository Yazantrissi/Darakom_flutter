# Implementation Plan - Profile Picture Picking for Client

This plan outlines the steps to allow the client to pick a profile picture from their gallery and display it immediately in the Profile screen.

## Proposed Changes

### 1. Controller Layer

#### [MODIFY] [profile_controller.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/controllers/home/profile_controller.dart)
- Add `Rx<Uint8List?> pickedImageBytes` to store image data for Web support.
- Add `RxString pickedImagePath` to store the local path for Mobile support.
- Update `editProfilePicture()`:
    - Use `ImagePicker` to select an image from the gallery.
    - Update `pickedImageBytes` and `pickedImagePath` based on the platform.
- Update `saveChanges()` to include the image in the `updateProfile` request (if persistence is intended now, otherwise just UI display).

### 2. View Layer

#### [MODIFY] [profile_screen.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/views/home/profile_screen.dart)
- Update the profile image container in `_buildCustomHeader()`:
    - Wrap with `Obx`.
    - Check if `pickedImageBytes` or `pickedImagePath` has data.
    - Display the selected image using `Image.memory()` or `Image.file()`.
    - Fallback to the existing profile icon if no image is selected.

## Verification Plan

### Manual Verification
1.  Open the Profile screen.
2.  Tap the edit icon or the profile picture area.
3.  Select an image from the gallery.
4.  Verify that the selected image replaces the default person icon in the UI immediately.
5.  Check that the UI remains responsive and the loading overlay still works.
