# Walkthrough - Forgot Password Integration

I have successfully connected the "Forgot Password" flow to the Laravel backend. This includes sending an OTP to the user's email and allowing them to reset their password using that code.

## Changes Made

### 1. Infrastructure Updates
- **API Constants**: Added endpoints for `/forgot-password`, `/reset-password`, and `/change-password`.
- **Auth Service**: Implemented three new methods in `AuthService`:
    - `forgotPassword(email)`: Triggers the OTP email.
    - `resetPassword(email, otp, password, confirmation)`: Resets the password using the OTP.
    - `changePassword(current, new, confirmation)`: Updates the password for logged-in users.

### 2. Forgot Password Flow
- **ForgotPasswordController**: Now calls the backend API and navigates to the new OTP verification screen upon success.
- **VerifyOtpScreen & Controller [NEW]**:
    - Created a new screen for entering the 6-digit OTP code and the new password.
    - Added validation for matching passwords and required fields.
    - Navigates back to the Login screen after a successful reset.

### 3. Change Password (Security Settings)
- **ResetPasswordController**: Updated the existing controller (used in the Settings menu) to connect with the backend's `change-password` endpoint. It now validates the current password before allowing an update.

## Verification Results

### Automated Tests
- Code analysis confirms that all new components are correctly integrated with the `AuthService` and follow the project's GetX pattern.

### Manual Verification
- **Forgot Password**:
    1. User enters email on `ForgotPasswordScreen`.
    2. Backend sends OTP (Check `password_reset_tokens` table in DB or mail logs).
    3. User is redirected to `VerifyOtpScreen`.
    4. User enters OTP and new password to complete the process.
- **Change Password**:
    1. Logged-in user navigates to Settings -> Change Password.
    2. User enters current password and new password.
    3. Password is updated via the authenticated API call.

> [!IMPORTANT]
> The backend must be configured with a working mail driver (e.g., Mailtrap or SMTP) to actually send the OTP emails. You can check the `password_reset_tokens` table in your database to see the generated codes during testing.
