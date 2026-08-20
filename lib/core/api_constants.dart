class ApiConstants {
  static const String baseUrl = "http://127.0.0.1:8000/api";

  // Auth
  static const String login = "/login";
  static const String register = "/register";
  static const String logout = "/logout";
  static const String profile = "/profile";
  static const String forgotPassword = "/forgot-password";
  static const String resetPassword = "/reset-password";
  static const String changePassword = "/change-password";
  static const String updateProfile = "/profile/update";

  // Settings
  static const String provinces = "/provinces";
  static const String roles = "/roles";
  static const String documentTypes = "/document-types";
  static const String serviceCategories = "/service-categories";

  // Projects (General)
  static const String projects = "/projects";

  // Client Specific
  static const String clientDashboard = "/client/dashboard";
  static const String clientProjects = "/client/projects";
  static const String clientOffers = "/client/offers";
  static const String clientPublicOffers = "/client/offers/public";
  static const String clientPrivateOffers = "/client/offers/private";
  static const String clientComplaints = "/client/complaints";
  static const String clientRatings = "/client/my-ratings";
  static const String acceptOffer = "/client/projects/"; // /{project}/offers/{offer}/accept
  static const String rejectOffer = "/client/projects/"; // /{project}/offers/{offer}/reject
  static const String inviteProvider = "/client/projects"; // /{project}/invitations

  // Provider Specific
  static const String providerDashboard = "/provider/dashboard";
  static const String publicTenders = "/provider/public-tenders";
  static const String privateTenders = "/provider/private-tenders";
  static const String providerOffers = "/provider/offers";
  static const String providerProjects = "/provider/projects";
  static const String providerComplaints = "/provider/complaints";
  static const String providerRatings = "/provider/ratings";
  static const String providerInvitations = "/provider/invitations";

  // Profiles
  static const String profiles = "/profiles";

  // Interactions
  static const String favorites = "/favorites";
  static const String toggleFavorite = "/favorites/toggle";

  // Notifications
  static const String notifications = "/notifications";
  static const String unreadNotifications = "/notifications/unread";
  static const String markNotificationRead = "/notifications"; // /{id}/read
  static const String markAllNotificationsRead = "/notifications/read-all";
}
