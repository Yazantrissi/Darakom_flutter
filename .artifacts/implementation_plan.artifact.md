# Implementation Plan - Add Mobile Number to Registration

This plan outlines the steps to add a "Mobile Number" field to the registration process and connect it to the backend API.

## User Review Required

> [!IMPORTANT]
> - A new mandatory "Mobile Number" field will be added to the registration screen.
> - The field will appear immediately after the "Confirm Password" field.
> - Data will be sent to the backend using the key `phone`.

## Proposed Changes

### Controllers

#### [MODIFY] [register_controller.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/controllers/auth/register_controller.dart)
- Add `phoneController` to manage the mobile number input.
- Update `_validateInput()` to ensure the phone number is not empty and matches a basic pattern if needed.
- Include `'phone': phoneController.text` in the data map sent to the registration API.
- Ensure `phoneController` is disposed in the `onClose` method.

### Views

#### [MODIFY] [register_screen.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/views/auth/register_screen.dart)
- Insert a new `_buildTextField` for the "Mobile Number" after the password confirmation field.
- Set the `keyboardType` to `TextInputType.phone` for a better user experience.
- Use `Icons.phone_android_outlined` as the icon.

## Verification Plan

### Manual Verification
1. Navigate to the Registration screen.
2. Verify the presence of the "Mobile Number" field after "Confirm Password".
3. Test validation by leaving it empty (should show a warning).
4. Perform a successful registration and verify (via console or backend) that the `phone` field is sent correctly.
