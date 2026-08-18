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

  // Projects (General)
  static const String projects = "/projects";

  // Client Specific
  static const String clientDashboard = "/client/dashboard";
  static const String clientProjects = "/client/projects";
  static const String clientOffers = "/client/offers";
  static const String clientComplaints = "/client/complaints";
  static const String clientRatings = "/client/my-ratings";
  static const String acceptOffer = "/client/projects/"; // /{project}/offers/{offer}/accept
  static const String rejectOffer = "/client/projects/"; // /{project}/offers/{offer}/reject

  // Provider Specific
  static const String providerDashboard = "/provider/dashboard";
  static const String publicTenders = "/provider/public-tenders";
  static const String privateTenders = "/provider/private-tenders";
  static const String providerOffers = "/provider/offers";
  static const String providerProjects = "/provider/projects";
  static const String providerComplaints = "/provider/complaints";
  static const String providerRatings = "/provider/ratings";
  static const String providerInvitations = "/provider/invitations";

  // Interactions
  static const String favorites = "/favorites";
  static const String toggleFavorite = "/favorites/toggle";
}
