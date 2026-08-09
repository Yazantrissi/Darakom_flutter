# Implementation Plan - Connecting Forgot Password to Backend

This plan outlines the steps to connect the "Forgot Password" and "Reset Password" flow to the Laravel backend.

## User Review Required

> [!IMPORTANT]
> - The flow will consist of two steps:
>   1. Entering the email to receive an OTP code.
>   2. Entering the OTP code along with the new password.
> - I will create a new `VerifyOtpScreen` to handle the second step.
> - The current `ResetPasswordScreen` is designed for logged-in users to change their password. I will update its controller to use the backend's `change-password` endpoint.

## Proposed Changes

### Backend Project (darkum-backend)
- No changes needed (endpoints `/forgot-password`, `/reset-password`, and `/change-password` already exist).

### Flutter Project (darakom_app)

#### [MODIFY] [api_constants.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/core/api_constants.dart)
- Add endpoints for forgot password, reset password, and change password.

#### [MODIFY] [auth_service.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/services/auth_service.dart)
- Add methods: `forgotPassword`, `resetPassword`, and `changePassword`.

#### [MODIFY] [forgot_password_controller.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/controllers/auth/forgot_password_controller.dart)
- Call `AuthService.forgotPassword`.
- On success, navigate to `VerifyOtpScreen`.

#### [NEW] [verify_otp_controller.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/controllers/auth/verify_otp_controller.dart)
- Handle OTP input and new password input.
- Call `AuthService.resetPassword`.

#### [NEW] [verify_otp_screen.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/views/auth/verify_otp_screen.dart)
- UI for entering OTP and new password.

#### [MODIFY] [reset_password_controller.dart](file:///C:/Users/Yazan/Desktop/darakom_app/lib/controllers/auth/reset_password_controller.dart)
- Connect to `AuthService.changePassword` for logged-in users.

## Verification Plan

### Manual Verification
- Test "Forgot Password" flow:
  - Enter email -> Receive OTP (simulated/check backend logs).
  - Enter OTP and new password -> Success.
- Test "Change Password" flow (from Settings):
  - Enter current and new password -> Success.
