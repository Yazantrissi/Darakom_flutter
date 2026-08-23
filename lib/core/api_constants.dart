class ApiConstants {
  static const String baseUrl = "http://127.0.0.1:8000/api";

  // Auth
  static const String login = "/login";
  static const String register = "/register";
  static const String logout = "/logout";
  static const String switchAccount = "/switch-account";
  static const String forgotPassword = "/forgot-password";
  static const String resetPassword = "/reset-password";
  static const String changePassword = "/change-password";

  // Profile
  static const String profile = "/profile";
  static const String updateProfile = "/profile/update";

  // Lookups
  static const String provinces = "/provinces";
  static const String roles = "/roles";
  static const String documentTypes = "/document-types";
  static const String serviceCategories = "/service-categories";
  static const String providerTypes = "/provider-types";

  // Projects (client create/update/delete)
  static const String projects = "/projects";

  // Client
  static const String clientDashboard = "/client/dashboard";
  static const String clientProjects = "/client/projects";
  static String clientProviders = "/client/providers";

  static String clientProviderProfile(int id) => "/client/providers/$id";
  static const String clientComplaints = "/client/complaints";
  static const String clientRatings = "/client/my-ratings";
  static const String clientPublicOffers = "/client/offers/public";
  static const String clientPrivateOffers = "/client/offers/private";

  // Provider
  static const String providerDashboard = "/provider/dashboard";
  static const String publicTenders = "/provider/public-tenders";
  static const String privateTenders = "/provider/private-tenders";
  static const String providerOffers = "/provider/offers";
  static const String providerProjects = "/provider/projects";
  static const String providerComplaints = "/provider/complaints";
  static const String providerRatings = "/provider/ratings";
  static const String providerInvitations = "/provider/invitations";

  // Favorites
  static const String favorites = "/favorites";
  static const String toggleFavorite = "/favorites/toggle";

  // Notifications
  static const String notifications = "/notifications";
  static const String unreadNotifications = "/notifications/unread";
  static const String markAllNotificationsRead = "/notifications/read-all";

  // Path helpers
  static String clientProject(int id) => "/client/projects/$id";

  static String clientProjectOffers(int id) => "/client/projects/$id/offers";

  static String acceptOffer(int projectId, int offerId) =>
      "/client/projects/$projectId/offers/$offerId/accept";

  static String rejectOffer(int projectId, int offerId) =>
      "/client/projects/$projectId/offers/$offerId/reject";

  static String rateProject(int id) => "/client/projects/$id/rate";

  static String inviteProvider(int id) => "/client/projects/$id/invitations";

  static String clientProjectReports(int id) => "/client/projects/$id/reports";

  static String clientProjectSteps(int id) => "/client/projects/$id/steps";

  static String providerProject(int id) => "/provider/projects/$id";

  static String providerSubmitOffer(int id) => "/provider/projects/$id/offers";

  static String providerProjectReports(int id) => "/provider/projects/$id/reports";

  static String providerProjectSteps(int id) => "/provider/projects/$id/steps";

  static String acceptInvitation(int id) => "/provider/invitations/$id/accept";

  static String declineInvitation(int id) => "/provider/invitations/$id/decline";

  static String markNotificationRead(String id) => "/notifications/$id/read";

  static String deleteNotification(String id) => "/notifications/$id";

  static String providerOffer(int id) => "/provider/offers/$id";

  static String projectById(int id) => "/projects/$id";

  // Portfolio
  static const String previousWorks = "/portfolio/previous-works";

  static String previousWork(int id) => "/portfolio/previous-works/$id";
}
